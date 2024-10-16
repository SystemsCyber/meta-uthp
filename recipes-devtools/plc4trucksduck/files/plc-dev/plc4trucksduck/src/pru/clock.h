#ifndef CLOCK_H
#define CLOCK_H

#include <stdint.h>

#define CM_PER_BASE ((volatile uint32_t *)(0x44E00000)) /* Clock Module Peripheral Registers Base Address */
#define CLKCTRL_ON 2 /* Clock Control ON value */
#define CLKCTRL_OFF 0 /* Clock Control OFF value */

void clockWarmUp(uint8_t moduleOffset) {
    volatile uint32_t *ptr_cm = CM_PER_BASE;
    ptr_cm[moduleOffset / 4] = CLKCTRL_ON;
    while(ptr_cm[moduleOffset / 4] & 0x00300000);
}

#endif /* CLOCK_H */
