
.section .text, "ax"
.align 4

.global _start
.type _start, @function

_start:
    /* Set stack pointer */
    movi a1, _stack_top

    /* BSS start and end addresses */
    movi a2, _bss_start
    movi a3, _bss_end

    /* Zero value */
    movi a4, 0

.Lbss_loop:
    bgeu a2, a3, .Lbss_done
    s32i a4, a2, 0
    addi a2, a2, 4
    j .Lbss_loop

.Lbss_done:
    /* Call main */
    call0 main

.Lhalt:
    j .Lhalt

.size _start, . - _start
