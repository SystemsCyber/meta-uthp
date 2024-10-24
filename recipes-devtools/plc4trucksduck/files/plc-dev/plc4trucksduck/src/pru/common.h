#ifndef COMMON_H
#define COMMON_H

#include <stdint.h>
#include <pru_cfg.h>
#include <pru_intc.h>
#include <pru_ctrl.h>
#include <pru_rpmsg.h>
#include <string.h>
#include <stddef.h>
#include "resource_table.h"
#include "uart.h"
#include "gpio.h"

/*
 * Used to make sure the Linux drivers are ready for RPMsg communication
 * Found at linux-x.y.z/include/uapi/linux/virtio_config.h
 */
#define VIRTIO_CONFIG_S_DRIVER_OK	4
volatile register uint32_t __R31;

// J1708 Message are normally limited to 21 bytes, but if the vehicle is off the
// standard permits longer messages.
#define MAX_PAYLOAD_LEN 255

uint8_t transmitBuf[RPMSG_MESSAGE_SIZE];
uint8_t receiveBuf[MAX_PAYLOAD_LEN];

int __inline isBusIdle(uint8_t numChecks) {
    // This should work with both J1708 and PLC
    /* Number of passes needed to achieve ~5.2 ms idle time
       Each pass of isBusIdle(20) checks for ~1.04 ms
       Thus, we need 5 passes: 5 * 1.04 ms ≈ 5.2 ms */
    numChecks = numChecks * 5;
    for(int i = 0; i < numChecks; i++) {
        #ifdef PLC // P485
        if (readGpioPin(BBB_GPIO_PIN) == 0) {
        #endif J1708 // THVD1410
        if (UART_LSR & 0x1) { // Data Ready bit is set
            // Bus is active, reset idle detection
            return 0; // Bus is not idle
        __delay_cycles(CYCLES_PER_HALF_BIT); // Wait for half bit time (~52 µs)
        }
    }
    return 1; // Bus has been idle for the required duration
}

void pruInit(struct pru_rpmsg_transport* transport) {
    volatile uint8_t *status;

    /* Allow OCP master port access by the PRU so the PRU can read external memories */
    CT_CFG.SYSCFG_bit.STANDBY_INIT = 0;

    /* Clear the status of the PRU-ICSS system event that the ARM will use to 'kick' us */
	CT_INTC.SICR_bit.STS_CLR_IDX = FROM_ARM_HOST;

	/* Make sure the Linux drivers are ready for RPMsg communication */
	status = &resourceTable.rpmsg_vdev.status;
	while (!(*status & VIRTIO_CONFIG_S_DRIVER_OK));

	/* Initialize the RPMsg transport structure */
	pru_rpmsg_init(transport, &resourceTable.rpmsg_vring0, &resourceTable.rpmsg_vring1, TO_ARM_HOST, FROM_ARM_HOST);

	/* Create the RPMsg channel between the PRU and ARM user space using the transport structure. */
	while (pru_rpmsg_channel(RPMSG_NS_CREATE, transport, CHAN_NAME, CHAN_PORT) != PRU_RPMSG_SUCCESS);

    uartInit();
    gpioInit();

    uartRead(receiveBuf, MAX_PAYLOAD_LEN); // Clear anything in RX FIFO
    memset(receiveBuf, 0, MAX_PAYLOAD_LEN); // Clear the buffer
}
//uartGetC(&buf[i]);
int16_t receiveRemainingMessage(uint8_t* buf) {
    int16_t i = -1; // include the first byte: TODO: fix this
    for (; i < MAX_PAYLOAD_LEN; i++) { // Read until we get a bus idle
        uartGetC(&buf[i]);
        if (isBusIdle(CHECKS_TILL_MSG_FINISHED)) { // if bus idle function returns 1 then break
            i++;
            break;
        }
    }
    return i;
}

#endif /* COMMON_H */
