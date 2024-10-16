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
    for (int i = 0; i < numChecks; ++i) {
        #ifdef UART_TESTING
        if (readGpioPin(BBB_GPIO_PIN) == 1) {
        #else
        if (readGpioPin(BBB_GPIO_PIN) == 0) {
        #endif
            return 0;
        } else {
            __delay_cycles(CYCLES_PER_HALF_BIT);
        }
    }
    return 1;
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

    // Wait for message to finish
    for (int i = 1; i < CHECKS_TILL_MSG_FINISHED; ++i) {
        #ifdef UART_TESTING
        if (readGpioPin(BBB_GPIO_PIN)) {
        #else
        if (!readGpioPin(BBB_GPIO_PIN)) {
        #endif
            i = 1;
            continue;
        }
        __delay_cycles(CYCLES_PER_HALF_BIT);
    }
    uartRead(receiveBuf, MAX_PAYLOAD_LEN); // Clear anything in RX FIFO
    memset(receiveBuf, 0, MAX_PAYLOAD_LEN);
}

uint16_t receiveRemainingMessage(uint8_t* buf) {
    uint16_t i = 0;
    for (; i < MAX_PAYLOAD_LEN; i++) {
        uartGetC(&buf[i]);
        if (isBusIdle(CHECKS_TILL_MSG_FINISHED)) {
            i++;
            break;
        }
    }
    return i;
}

#endif /* COMMON_H */
