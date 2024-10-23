/* PLC4TRUCKSDuck (c) 2020 National Motor Freight Traffic Association
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

// TESTED ON: 10/17/2024 - Working with UTHP 1.0.0

#define PRU_NO 1
#define BBB_GPIO_PIN 40 // fake ILD (not needed for J1708 over PLC.. this is over the THVD1410 transceiver)
#define UART_NUM 2

/* Host-0 Interrupt sets bit 31 in register R31 */
#define HOST_INT			((uint32_t) 1 << 31)

/* The PRU-ICSS system events used for RPMsg are defined in the Linux device tree
 * PRU0 uses system event 16 (To ARM) and 17 (From ARM)
 * PRU1 uses system event 18 (To ARM) and 19 (From ARM)
 */
#define TO_ARM_HOST 18
#define FROM_ARM_HOST 19

/*
 * Using the name 'rpmsg-pru' will probe the rpmsg_pru driver found
 * at linux-x.y.z/drivers/rpmsg/rpmsg_pru.c
 */
#define CHAN_NAME			"rpmsg-pru"
#define CHAN_DESC			"Channel 31"
#define CHAN_PORT			31

/* J1708 requires 10 bits of interframe spacing. J1708 also operates at 9600
 * baud and the clock rate of the PRUs is 200MHz. Also the line is active when
 * its low (digital zero). Thus:
 * bit_time = 1/9600 = 1.04e-4
 * time_for_10_bits = 10 * bit_time
 * num_clock_cycles_for_10_bits = time_for_10_bits * 200000000 ~= 208,000
 * Therefore, the code below is checking if the bus is available every half bit.
 */
#define CYCLES_PER_HALF_BIT 10400
#define CHECKS_TILL_BUS_IDLE 20

#define CHECKS_TILL_MSG_FINISHED 30 // number of half bit intervals to wait (was 13)

#define UART_TESTING // Remove if not testing UART
// #define J1708_TESTING // Remove if not testing J1708 with THVD1410

#include <stdint.h>
#include <pru_cfg.h>
#include <pru_intc.h>
#include <pru_ctrl.h>
#include <pru_rpmsg.h>
#include <string.h>
#include "intc_map_1.h"
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
                // Arbitration: Send MID. If we recv anything and our MID is
                // greater then we lose arbitration. Otherwise continue
                // writing the message.
                if (uartGetC(&receiveBuf[0]) && transmitBuf[0] > receiveBuf[0]) {
                    // We lost arbitration so read the remaining message.
                    uint16_t recvLen = receiveRemainingMessage(&receiveBuf[1]);
                    // send a debugging message to the host
                    uint8_t debugMsg[1] = {0x11};
                    pru_rpmsg_send(&transport, dst, src, debugMsg, 1);
                    pru_rpmsg_send(&transport, dst, src, receiveBuf, recvLen);
                } else {
                    // Either no one else is talking or we won arbitration
                    // uartWrite will only return once all bytes have been sent.
                    uartWrite(transmitBuf + 1, len - 1);
                    // Clear transmitBuf so we know its been sent
                    memset(transmitBuf, 0, RPMSG_MESSAGE_SIZE);
                }
            }
        } else if (uartGetC(receiveBuf)) { // Is there anything to receive?
            uint8_t debugMsg[1] = {0x22};
            pru_rpmsg_send(&transport, dst, src, debugMsg, 1);
            uint16_t recvLen = receiveRemainingMessage(&receiveBuf[1]);
            recvLen += 1; // add the MID
            pru_rpmsg_send(&transport, dst, src, receiveBuf, recvLen);
            // clear receiveBuf so we know its been sent
            memset(receiveBuf, 0, MAX_PAYLOAD_LEN);
        }
    }
}