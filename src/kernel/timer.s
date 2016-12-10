        /**
         * Timer
         *
         * Routines for timing things.
         */
        .section .text
        .align

delay:
        /**
         * public delay(u32[r0] n)
         *
         * Wait for `n` units of time. A single unit is "implementation defined".
         */
        .global delay

        ldr     r1,     =0x200000
        mul     r1,     r0
_d1:    subs    r1,     #1
        bne     _d1
        bx      lr
