        .section .init
        .global start

start:  // Entry point to the kernel.
        mov     sp,     #0x8000
        b       main

        .section .text
main:    // GPIO Pin 16 is the ACT LED.
        mov     r0,     #16
        ldr     r1,     =GPIO_FUNC_OUT
        ldr     r1,     [r1]
        bl      gpio_set_function

_m1:    ldr     r0,     =HELLO
        bl      output_morse
        b       _m1

        // Halt and Catch Fire
_hacf:  b       _hacf

        .section .data
        .align

HELLO:  .asciz "hello "
