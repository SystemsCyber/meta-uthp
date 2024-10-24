/* PLC4TRUCKSDuck (c) 2024 National Motor Freight Traffic Association
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
*/

#define PRU_NO 0
#define BBB_GPIO_PIN 60 // IDLE LINE DETECT: TODO: Test this
#define UART_NUM 4

/* Host-0 Interrupt sets bit 30 in register R31 */
#define HOST_INT			((uint32_t) 1 << 30)

/* The PRU-ICSS system events used for RPMsg are defined in the Linux device tree
 * PRU0 uses system event 16 (To ARM) and 17 (From ARM)
 * PRU1 uses system event 18 (To ARM) and 19 (From ARM)
 */
#define TO_ARM_HOST 16
#define FROM_ARM_HOST 17

/*
 * Using the name 'rpmsg-pru' will probe the rpmsg_pru driver found
 * at linux-x.y.z/drivers/rpmsg/rpmsg_pru.c
 */
#define CHAN_NAME			"rpmsg-pru"
#define CHAN_DESC			"Channel 30"
#define CHAN_PORT			30

/* PLC requires 12 bits of interframe spacing. PLC also operates at 9600
 * baud and the clock rate of the PRUs is 200MHz. Also the line is active when
 * its low (digital zero). Thus:
 * bit_time = 1/9600 = 1.04e-4
 * time_for_12_bits = 12 * bit_time
 * num_clock_cycles_for_12_bits = time_for_12_bits * 200000000 ~= 250,000
 * Therefore, the code below is checking if the bus is available every half bit.
 */
#define CYCLES_PER_HALF_BIT 10400
#define CHECKS_TILL_BUS_IDLE 24

// SSCP485 Datasheet recommended waiting about 1.5 characters of line idle to
// determine that a message had been sent.
#define CHECKS_TILL_MSG_FINISHED 13 // 13 * 52 µs = 676 µs

//#define UART_TESTING // Remove if not testing UART
#define PLC // needed in common.h

#include <stdint.h>
#include <pru_cfg.h>
#include <pru_intc.h>
#include <pru_ctrl.h>
#include <pru_rpmsg.h>
#include <string.h>
#include <stddef.h>
#include "intc_map_0.h"
#include "common.h"

void main() {
    struct pru_rpmsg_transport transport;
	uint16_t src = 0;
    uint16_t dst = 0;
    uint16_t len = 0;
	
    pruInit(&transport);
    // Need to initialize src and dst
    while(pru_rpmsg_receive(&transport, &src, &dst, transmitBuf, &len) != PRU_RPMSG_SUCCESS);
    memset(transmitBuf, 0, RPMSG_MESSAGE_SIZE);

    while (1) {
        // Is there a message to transmit?
        if (transmitBuf[0] != 0 || pru_rpmsg_receive(&transport, &src, &dst, transmitBuf, &len) == PRU_RPMSG_SUCCESS) {
            if (isBusIdle(CHECKS_TILL_BUS_IDLE)) {
                // Send MID. Using uartWrite over uartPutC so that it waits to
                // return until byte is transmitted.
                uartWrite(transmitBuf, 1);
                // Arbitration: Send MID, check if what we recv is the same
                // (no one else is talking) or greater than what we sent
                // (arbitration win since we have a lower value). If so we
                // continue talking, otherwise we backoff.
                #ifdef UART_TESTING // gets executed even if we aren't receiving anything
                if (uartGetC(&receiveBuf[0]) && transmitBuf[0] > receiveBuf[0]) {
                    // We lost arbitration so read the remaining message.
                    uint16_t recvLen = receiveRemainingMessage(&receiveBuf[1]);
                    pru_rpmsg_send(&transport, dst, src, receiveBuf, recvLen);
                } else {
                    // Either no one else is talking or we won arbitration
                    // uartWrite will only return once all bytes have been sent.
                    uartWrite(transmitBuf + 1, len - 1);
                    // Clear transmitBuf so we know its been sent
                    memset(transmitBuf, 0, RPMSG_MESSAGE_SIZE);
                }
                #else
                if (uartGetC(&receiveBuf[0])) {
                    if (transmitBuf[0] <= receiveBuf[0]) {
                        // Either no one else is talking or we won arbitration
                        // uartWrite will only return once all bytes have been sent.
                        uartWrite(transmitBuf + 1, len - 1);
                        // Clear transmitBuf so we know its been sent
                        memset(transmitBuf, 0, RPMSG_MESSAGE_SIZE);
                    } else {
                        // We lost arbitration so read the remaining message.
                        uint16_t recvLen = receiveRemainingMessage(&receiveBuf[1]);
                        pru_rpmsg_send(&transport, dst, src, receiveBuf, recvLen);
                    }
                } else {
                    // Error - the P485 chip should echo first char back
                    __halt();
                }
                #endif
            }
        } else if (uartGetC(receiveBuf)) { // Is there anything to receive?
            uint16_t recvLen = receiveRemainingMessage(&receiveBuf[1]);
            pru_rpmsg_send(&transport, dst, src, receiveBuf, recvLen);
        }
    }
}
