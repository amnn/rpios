        /**
         * GPIO
         *
         * Set GPIO pin functions, turn them on and off.
         */
        .section .data
        .align

        /**
         * public enum gpio_func_t
         *
         * Available functions for a GPIO pin.
         */
        .global GPIO_FUNC_IN
        .global GPIO_FUNC_OUT
        .global GPIO_FUNC_ALT0
        .global GPIO_FUNC_ALT1
        .global GPIO_FUNC_ALT2
        .global GPIO_FUNC_ALT3
        .global GPIO_FUNC_ALT4
        .global GPIO_FUNC_ALT5

GPIO_FUNC_IN:   .word   0b000
GPIO_FUNC_OUT:  .word   0b001
GPIO_FUNC_ALT0: .word   0b100
GPIO_FUNC_ALT1: .word   0b101
GPIO_FUNC_ALT2: .word   0b110
GPIO_FUNC_ALT3: .word   0b111
GPIO_FUNC_ALT4: .word   0b011
GPIO_FUNC_ALT5: .word   0b010

        .section .text
        .align

        /** private GPIO_BASE_ADDR */
GPIO_BASE_ADDR: .word   0x20200000

gpio_set_function:
        /**
         * public gpio_set_function(u8[r0] pin, gpio_func_t[r1] func)
         *
         * Set the given GPIO pin's function to the one provided. The GPIO
         * pin number must be between 0 and 53, inclusive.
         */
        .global gpio_set_function

        // Check validity of GPIO pin: 0 < pin <= 53
        cmp     r0,     #0
        movlt   pc,     lr
        cmp     r0,     #53
        movgt   pc,     lr

        push    {r4-r5, lr}

        // Calculate offsets
        add     r0,     r0, ASL #1       // r0 *= 3
        mov     r2,     #0

_rlp1:  cmp     r0,     #30
        subge   r0,     #30
        addge   r2,     #1
        bge     _rlp1

        ldr     r3,     GPIO_BASE_ADDR
        ldr     r4,     [r3, r2, LSL #2] // r4 := *(*GPIO_BASE_ADDR + r2 * 4)

        // Clear previous function
        mov     r5,     #0b111
        lsl     r5,     r0
        mvn     r5,     r5
        and     r4,     r5

        // Mask off and shift GPIO function
        and     r1,     #0b111
        lsl     r1,     r0
        orr     r4,     r1
        str     r1,     [r3, r2, LSL #2]

        pop     {r4-r5, pc}

gpio_on:
        /**
         * public gpio_on(u8[r0] pin)
         *
         * Turn on provided GPIO pin (between 0 and 53, inclusive).
         */
        .global gpio_on

        // Check validity of GPIO pin: 0 < pin <= 53
        cmp     r0,     #0
        movlt   pc,     lr
        cmp     r0,     #53
        movgt   pc,     lr

        // Write to SET register
        mov     r1,     #7              // SET Register Base Offset
        add     r1,     r0, LSR #5      // Offset of specific register
        and     r0,     #0b11111        // Offset in register
        mov     r3,     #1
        lsl     r3,     r0
        ldr     r0,     GPIO_BASE_ADDR
        str     r3,     [r0, r1, LSL #2]

        mov     pc,     lr


gpio_off:
        /**
         * public gpio_off(u8[r0] pin)
         *
         * Turn off provided GPIO pin (between 0 and 53, inclusive).
         */
        .global gpio_off

        // Check validity of GPIO pin: 0 < pin <= 53
        cmp     r0,     #0
        movlt   pc,     lr
        cmp     r0,     #53
        movgt   pc,     lr

        // Write to CLEAR register
        mov     r1,     #10             // CLEAR Register Base Offset
        add     r1,     r0, LSR #5      // Offset of specific register
        and     r0,     #0b11111        // Offset in register
        mov     r3,     #1
        lsl     r3,     r0
        ldr     r0,     GPIO_BASE_ADDR
        str     r3,     [r0, r1, LSL #2]

        mov     pc,     lr
