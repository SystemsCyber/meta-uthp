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

// TESTED ON: 02/12/2025 - Working with UTHP 1.0.0

#define PRU_NO 0
#define BBB_GPIO_PIN 88 // IDLE LINE DETECT: needs to be set in overlays
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

// SSCP485 Datasheet recommended waiting about 1.5 characters of line idle to
// determine that a message had been sent.
#define CHECKS_TILL_MSG_FINISHED 11 // 13 * 52 µs = 676 µs
#define J1708 // needed in common.h
// Side note: the SSCP485 doesn't include TP

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
                uartWrite(transmitBuf, 1); // write the MID
                __delay_cycles(550000); // wait period for echo back (trust me when I say this exact value is important for reading the echo back and giving enough time for sending the rest of the message)
                if (uartGetC(&receiveBuf[0])) { // check if there is a message to receive
                    // Arbitration: Send MID. If we recv anything and our MID is
                    // greater then we lose arbitration. Otherwise continue
                    // writing the message.
                    if (transmitBuf[0] <= receiveBuf[0]) { // either no one else is transmitting or we won arbitration
                        uartWrite(transmitBuf + 1, len - 1); // write the remaining message
                        memset(transmitBuf, 0, RPMSG_MESSAGE_SIZE);
                    } else { // darn we lost arbitration
                        uint16_t recvLen = receiveRemainingMessage(&receiveBuf[1]);
                        pru_rpmsg_send(&transport, dst, src, receiveBuf, recvLen+1);
                    }
                } else { // SSCP485 did not echo back
                    // enter a safe error loop until the host resets the PRU
                    memset(receiveBuf, 0, MAX_PAYLOAD_LEN);
                    memset(transmitBuf, 0, RPMSG_MESSAGE_SIZE);
                    while (1) { __delay_cycles(1000000); }
                }
            }
        } else if (uartGetC(receiveBuf)) { // Is there anything to receive?
            uint16_t recvLen = receiveRemainingMessage(&receiveBuf[1]);
            pru_rpmsg_send(&transport, dst, src, receiveBuf, recvLen+1);
            memset(receiveBuf, 0, MAX_PAYLOAD_LEN);
        }
    }
}
