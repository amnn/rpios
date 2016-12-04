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

        bl      h
        bl      e
        bl      l
        bl      l
        bl      o

        // Halt and Catch Fire
_hacf:  b       _hacf

delay:  // Wait for `n` units of time.
        //
        // n : r0    Units of time.

        ldr     r1,     =0x200000
        mul     r1,     r0
_dloop: subs    r1,     #1
        bne     _dloop
        bx      lr

dot:    // Turn the LED on for the length of a morse code dot.

        push    {lr}
        mov     r0,     #16
        bl      gpio_off
        mov     r0,     #1
        bl      delay
        mov     r0,     #16
        bl      gpio_on
        mov     r0,     #1
        bl      delay
        pop     {pc}

dash:   // Turn the LED on for the length of a morse code dash.

        push    {lr}
        mov     r0,     #16
        bl      gpio_off
        mov     r0,     #2
        bl      delay
        mov     r0,     #16
        bl      gpio_on
        mov     r0,     #1
        bl      delay
        pop     {pc}

letter: // Wait for the length of a space.
        push    {lr}
        mov     r0,     #1
        bl      delay
        pop     {pc}

word:   // Wait for the length of a space.
        push    {lr}
        mov     r0,     #3
        bl      delay
        pop     {pc}

        // Morse code alphabet
h:      push    {lr}
        bl      dot
        bl      dot
        bl      dot
        bl      dot
        bl      letter
        pop     {pc}

e:      push    {lr}
        bl      dot
        bl      letter
        pop     {pc}

l:      push    {lr}
        bl      dot
        bl      dash
        bl      dot
        bl      dot
        bl      letter
        pop     {pc}

o:      push    {lr}
        bl      dash
        bl      dash
        bl      dash
        bl      letter
        pop     {pc}
