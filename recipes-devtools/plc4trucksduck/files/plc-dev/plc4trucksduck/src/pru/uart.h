#ifndef UART_H
#define UART_H

#include <stdint.h>
#include "clock.h"

#if (UART_NUM == 1)  /* UART1 */
    #define UART_CLKCTRL_OFFSET 0x6C
    #define UART_BASE 0x48022000
#elif (UART_NUM == 2) /* UART2 */
    #define UART_CLKCTRL_OFFSET 0x70
    #define UART_BASE 0x48024000
#elif (UART_NUM == 3) /* UART3 */
    #define UART_CLKCTRL_OFFSET 0x74
    #define UART_BASE 0x481A6000
#elif (UART_NUM == 4) /* UART4 */
    #define UART_CLKCTRL_OFFSET 0x78
    #define UART_BASE 0x481A8000
#else /* UART5 */
    #define UART_CLKCTRL_OFFSET 0x38
    #define UART_BASE 0x481AA000
#endif

#define UART_SYSC  (*((volatile uint32_t *)(UART_BASE + 0x54))) /* System Config Reg */
#define UART_SYSS  (*((volatile uint32_t *)(UART_BASE + 0x58))) /* System Status Reg */
#define UART_LCR   (*((volatile uint32_t *)(UART_BASE + 0x0C))) /* Line Control Reg */
#define UART_EFR   (*((volatile uint32_t *)(UART_BASE + 0x08))) /* Enhanced Feature Reg */
#define UART_MCR   (*((volatile uint32_t *)(UART_BASE + 0x10))) /* Modem Control Reg */
#define UART_FCR   (*((volatile uint32_t *)(UART_BASE + 0x08))) /* FIFO Control Reg */
#define UART_TLR   (*((volatile uint32_t *)(UART_BASE + 0x1C))) /* Trigger Level Reg */
#define UART_SCR   (*((volatile uint32_t *)(UART_BASE + 0x40))) /* Supplementary Ctrl Reg */
#define UART_MDR1  (*((volatile uint32_t *)(UART_BASE + 0x20))) /* Mode Definition Reg 1 */
#define UART_IER   (*((volatile uint32_t *)(UART_BASE + 0x04))) /* Interrupt Enable Reg */
#define UART_DLL   (*((volatile uint32_t *)(UART_BASE + 0x00))) /* Divisor Latch Low */
#define UART_DLH   (*((volatile uint32_t *)(UART_BASE + 0x04))) /* Divisor Latch High */
#define UART_LSR   (*((volatile uint32_t *)(UART_BASE + 0x14))) /* Line Status Reg */
#define UART_RHR   (*((volatile uint32_t *)(UART_BASE + 0x00))) /* Receiver Holding Reg */
#define UART_THR   (*((volatile uint32_t *)(UART_BASE + 0x00))) /* Transmitter Holding Reg */

// LCR Modes
#define UART_OPERATIONAL_MODE 0x00
#define UART_CONFIG_MODE_A 0x80
#define UART_CONFIG_MODE_B 0xBF


void uartSetMode(uint8_t mode) {
    UART_LCR = mode;
}

void uartSoftReset() {
    UART_SYSC = 0x1; // Set softreset bit to 1
    while((UART_SYSS & 0x1) == 0); // Wait until the operation completes
}

void uartInit() {
    // Start UART Clock
    clockWarmUp(UART_CLKCTRL_OFFSET);
    
    // Init UART per TFM
    uartSoftReset();
    UART_LCR |= 0x40; // Set break control bit. Doesn't match TRM
    uint32_t saved_lcr = UART_LCR;
    uartSetMode(UART_CONFIG_MODE_B);
    uint32_t saved_efr = UART_EFR;
    UART_EFR = (saved_efr | 0x10); // Enter TCR_TLR submode
    uartSetMode(UART_CONFIG_MODE_A);
    uint32_t saved_mcr = UART_MCR;
    UART_MCR = (saved_mcr | 0x40); // Enter TCR_TLR submode
    // Clear the FIFOs and enable it (puts it in interrupt mode). Can't fully
    // utilize UART FIFO interrupts on PRUs because:
    // 1) PRU don't support context switching interrupts only single register polling interrupts
    // 2) According to TRM section 4.4.2.2 the only UART2 system event is tx overflow.
    // Originally was 0x3. Changed to 0x7 to clear TX FIFO too and set Trig
    // levels to 16 bytes.
    UART_FCR = 0x57;
    uartSetMode(UART_CONFIG_MODE_B);
    UART_EFR = saved_efr;
    uartSetMode(UART_CONFIG_MODE_A);
    UART_MCR = saved_mcr;
    UART_LCR = saved_lcr;
    uint32_t saved_reg = UART_MDR1;
    UART_MDR1 = (saved_reg & 0xFFF8) | 0x7; // Disable UART
    uartSetMode(UART_CONFIG_MODE_B);
    saved_efr = UART_EFR;
    UART_EFR = (saved_efr | 0x10);  // Enter TCR_TLR submode
    uartSetMode(UART_OPERATIONAL_MODE);
    UART_IER = 0x00;
    uartSetMode(UART_CONFIG_MODE_B);
    // DLH and DLL (high and low) are combined to get a divisor. TRM indicates
    // 313 is appropriate for 9600 baud.
    UART_DLL = 0x39; // Originally was 0x38=312, changed to match TRM.
    UART_DLH = 0x01;
    uartSetMode(UART_OPERATIONAL_MODE);
    // Set interrupts. Originally none, changed to enable RHR interrupts.
    UART_IER = 0x01;
    uartSetMode(UART_CONFIG_MODE_B);
    UART_EFR = saved_efr;
    // Set data bits to 8 for a total word length of 10: 1 start, 8 data, 1 stop.
    UART_LCR = 0x03;
    // Restore MDR which by default is normal uart x16 sample rate.
    saved_reg = UART_MDR1;
    UART_MDR1 = (saved_reg & 0xFFF8);
}

uint8_t uartGetC(uint8_t* c) {
    if (UART_LSR & 0x1) {
        *c = UART_RHR;
        return 1;
    }
    return 0;
}

uint16_t uartRead(uint8_t* buf, uint16_t len) {
    uint16_t count = 0;
    uint8_t c;
    while (count < len) {
        if (uartGetC(&c)) {
            buf[count++] = c;
        } else {
            break;
        }
    }
    return count;
}

void uartPutC(uint8_t c) {
    while(!(UART_LSR & 0x20));
    UART_THR = c;
}

void uartWrite(uint8_t* buf, uint16_t len) {
    for (uint16_t i = 0; i < len; i++) {
        uartPutC(buf[i]);
    }
    while(!(UART_LSR & 0x20)); // Wait until the last byte is actually transmitted
}

#endif /* UART_H */
