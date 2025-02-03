#ifndef GPIO_H
#define GPIO_H

#include <stdint.h>
#include "clock.h"

// Processor splits up GPIO pins into 4 block, each with 32 pins.
#define GPIO_BLOCK (BBB_GPIO_PIN / 32)
#define GPIO_PIN(pin) ((pin) % 32)
#if (GPIO_BLOCK == 0) /* GPIO0 */
    #define GPIO_CLKCTRL_OFFSET 0 // GPIO0 has a different clock setup routine
    #define GPIO_BASE 0x44E07000
#elif (GPIO_BLOCK == 1) /* GPIO1 */
    #define GPIO_CLKCTRL_OFFSET 0xAC
    #define GPIO_BASE 0x4804C000
#elif (GPIO_BLOCK == 2) /* GPIO2 */
    #define GPIO_CLKCTRL_OFFSET 0xB0
    #define GPIO_BASE 0x481AC000
#else /* GPIO3 */
    #define GPIO_CLKCTRL_OFFSET 0xB4
    #define GPIO_BASE 0x481AD000
#endif

#define GPIO_CTRL     (*((volatile uint32_t *)(GPIO_BASE + 0x130))) /* GPIO Control Register */
#define GPIO_DATAIN   (*((volatile uint32_t *)(GPIO_BASE + 0x138))) /* GPIO Data In Register */

void gpioInit() {
    clockWarmUp(GPIO_CLKCTRL_OFFSET);
    GPIO_CTRL = 0;
}

int readGpioPin(uint8_t pin) {
    return GPIO_DATAIN & (1 << GPIO_PIN(pin));
}

#endif /* GPIO_H */
