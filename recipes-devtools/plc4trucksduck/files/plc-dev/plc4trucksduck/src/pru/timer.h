#ifndef TIMER_H
#define TIMER_H

#include <pru_cfg.h>
#include <pru_iep.h>
#include <stdint.h>

/* Define constants for time conversions */
#define PRU_CLOCK_FREQUENCY 200000000  // PRU clock frequency is 200 MHz

/* Initialize the IEP timer */
static inline void timerInit(void) {
    /* Clear SYSCFG[STANDBY_INIT] to enable OCP master port */
    CT_CFG.SYSCFG_bit.STANDBY_INIT = 0;

    /* Disable counter */
    CT_IEP.TMR_GLB_CFG_bit.CNT_EN = 0;

    /* Reset Count register */
    CT_IEP.TMR_CNT = 0x0;

    /* Clear overflow status register */
    CT_IEP.TMR_GLB_STS_bit.CNT_OVF = 0x1;

    /* Set a large compare value to avoid overflow */
    CT_IEP.TMR_CMP0 = 0xFFFFFFFF;  // No overflow for our purpose

    /* Clear compare status */
    CT_IEP.TMR_CMP_STS_bit.CMP_HIT = 0xFF;

    /* Disable compensation */
    CT_IEP.TMR_COMPEN_bit.COMPEN_CNT = 0x0;

    /* Enable counter */
    CT_IEP.TMR_GLB_CFG_bit.CNT_EN = 1;
}

/* Get the current IEP timer count (in microseconds) */
static inline uint32_t getIEPTimerCount(void) {
    return CT_IEP.TMR_CNT / (PRU_CLOCK_FREQUENCY / 1000000);  // Convert cycles to microseconds
}

/* Calculate the elapsed time between two timer counts */
static inline uint32_t calculateElapsedTime(uint32_t start_time, uint32_t end_time) {
    if (end_time >= start_time) {
        return end_time - start_time;
    } else {
        // Handle timer rollover
        return (0xFFFFFFFF - start_time) + end_time + 1;
    }
}

#endif  /* TIMER_H */
