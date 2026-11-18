
ENTRY(_start)

MEMORY
{
    IRAM (rx) : ORIGIN = 0x40378000, LENGTH = 32K
    DRAM (rw) : ORIGIN = 0x3FC90000, LENGTH = 64K
}

SECTIONS
{
    .text : ALIGN(4)
    {
        *(.literal .literal.*)
        *(.text .text.*)
    } > IRAM

    .rodata : ALIGN(4)
    {
        *(.rodata .rodata.*)
    } > DRAM

    .data : ALIGN(4)
    {
        *(.data .data.*)
    } > DRAM

    .bss (NOLOAD) : ALIGN(4)
    {
        _bss_start = .;
        *(.bss .bss.*)
        *(COMMON)
        . = ALIGN(4);
        _bss_end = .;
    } > DRAM

    .stack (NOLOAD) : ALIGN(16)
    {
        . = ALIGN(16);
        . += 4096;
        _stack_top = .;
    } > DRAM
}