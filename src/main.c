
#include <stdint.h>

#define REG32(addr) (*(volatile uint32_t *)(addr))

#define IO_MUX_GPIO4      0x60009014u
#define GPIO4_OUT_SEL     0x60004564u
#define GPIO_ENABLE_W1TS  0x60004024u
#define GPIO_OUT_W1TS     0x60004008u
#define GPIO_OUT_W1TC     0x6000400Cu

#define GPIO4_MASK (1u << 4)

static void delay(void)
{
    for (volatile uint32_t i = 0; i < 5000000u; i++)
    {
        __asm__ volatile ("nop");
    }
}

void main(void)
{
    // Select GPIO4 function
    REG32(IO_MUX_GPIO4) =
        (REG32(IO_MUX_GPIO4) & ~(7u << 12)) |
        (1u << 12);

    // Select GPIO output source
    REG32(GPIO4_OUT_SEL) = 0x100u;

    // Enable GPIO4 output
    REG32(GPIO_ENABLE_W1TS) = GPIO4_MASK;

    while (1)
    {
        // Turn LED on
        REG32(GPIO_OUT_W1TS) = GPIO4_MASK;
        delay();

        // Turn LED off
        REG32(GPIO_OUT_W1TC) = GPIO4_MASK;
        delay();
    }
}
