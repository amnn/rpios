        /**
         * Morse
         *
         * Output morse code using the ACT LED.
         */
        .section .text
        .align

output_morse:
        /**
         * public output_morse(s8 * [r0] str)
         *
         * Expects a pointer to a null-terminated sequence of signed bytes which
	 * it interprets as ASCII characters. Every character that can be
	 * interpreted in morse code is outputted using the Raspberry PI's ACT
         * LED (Actuated from GPIO Pin 16).
         */
        .global output_morse

        push    {r4-r6, lr}
        mov     r4,     r0

        b       $om1
_om1:   // Validate letter, out of range characters get mapped to "error".
        movle   r5,     #0

        // Translate letter to pointer into lookup table.
        ldr     r0,     =MORSE_LOOKUP
        ldr     r5,     [r0, r5, LSL #2]

        b       $om2
_om2:   // Delay of `-d` means "do not light LED for `d` units".
        rsblt   r6,     r6,     #0
        mov     r0,     #16
        blge    gpio_off

        // Wait for duration of letter
        mov     r0,     r6
        bl      delay

        mov     r0,     #16
        bl      gpio_on

        mov     r0,     #1
        bl      delay

$om2:   ldrsb   r6,     [r5], #1
        cmp     r6,     #0
        bne     _om2

        // End of letter, wait 2 extra units.
        mov     r0,     #2
        bl      delay

$om1:   ldrsb   r5,     [r4], #1
        cmp     r5,     #0
        bne     _om1
        pop     {r4-r6, pc}

delay:
        /**
         * private delay(u32[r0] n)
         *
         * Wait for `n` units of time. A single unit is "implementation defined".
         */

        ldr     r1,     =0x200000
        mul     r1,     r0
_d1:    subs    r1,     #1
        bne     _d1
        bx      lr

        .section .data
        .align

MORSE_LOOKUP:
        /**
         * private (s8 *)[128] MORSE_LOOKUP
         *
         * Lookup table from ASCII characters to sequences that can be
	 * interpreted as their morse code representation. A positive integer
         * `i` in the sequence indicates the LED being on for `i` units of time,
         * whereas a negative number indicates the LED is explicitly off for
         * `-i` units of time.
         */
        .word   error,  error,  error,  error,  error,  error,  error,  error
        .word   error,  error,  error,  error,  error,  error,  error,  error
        .word   error,  error,  error,  error,  error,  error,  error,  error
        .word   error,  error,  error,  error,  error,  error,  error,  error
        .word   space,  exclm,  dquot,  error,  dollar, error,  and,    squot
        .word   lpar,   rpar,   error,  plus,   comma,  minus,  period, div
        .word   zero,   one,    two,    three,  four,   five,   six,    seven
        .word   eight,  nine,   colon,  scolon, error,  equals, error,  qmark
        .word   at,     a,      b,      c,      d,      e,      f,      g
        .word   h,      i,      j,      k,      l,      m,      n,      o
        .word   p,      q,      r,      s,      t,      u,      v,      w
        .word   x,      y,      z,      error,  error,  error,  error,  under
        .word   error,  a,      b,      c,      d,      e,      f,      g
        .word   h,      i,      j,      k,      l,      m,      n,      o
        .word   p,      q,      r,      s,      t,      u,      v,      w
        .word   x,      y,      z,      error,  error,  error,  error,  under


error:  .byte 1, 1, 1, 1, 1, 1, 1, 1, 0

space:  .byte -4, 0
exclm:  .byte 3, 1, 3, 1, 3, 3, 0
dquot:  .byte 1, 3, 1, 1, 3, 1, 0
dollar: .byte 1, 1, 1, 3, 1, 1, 3, 0
and:    .byte 1, 3, 1, 1, 1, 0
squot:  .byte 1, 3, 3, 3, 3, 1, 0
lpar:   .byte 3, 1, 3, 3, 1, 0
rpar:   .byte 3, 1, 3, 3, 1, 3, 0
plus:   .byte 1, 3, 1, 3, 1, 0
comma:  .byte 3, 3, 1, 1, 3, 3, 0
minus:  .byte 3, 1, 1, 1, 1, 3, 0
period: .byte 1, 3, 1, 3, 1, 3, 0
div:    .byte 3, 1, 1, 3, 1, 0

zero:   .byte 3, 3, 3, 3, 3, 0
one:    .byte 1, 3, 3, 3, 3, 0
two:    .byte 1, 1, 3, 3, 3, 0
three:  .byte 1, 1, 1, 3, 3, 0
four:   .byte 1, 1, 1, 1, 3, 0
five:   .byte 1, 1, 1, 1, 1, 0
six:    .byte 3, 1, 1, 1, 1, 0
seven:  .byte 3, 3, 1, 1, 1, 0
eight:  .byte 3, 3, 3, 1, 1, 0
nine:   .byte 3, 3, 3, 3, 1, 0

colon:  .byte 3, 3, 3, 1, 1, 1, 0
scolon: .byte 3, 1, 3, 1, 3, 1, 0
equals: .byte 3, 1, 1, 1, 3, 0
qmark:  .byte 1, 3, 1, 1, 3, 1, 0
at:     .byte 1, 3, 3, 1, 3, 1, 0

a:      .byte 1, 3, 0
b:      .byte 3, 1, 1, 1, 0
c:      .byte 3, 1, 3, 1, 0
d:      .byte 3, 1, 1, 0
e:      .byte 1, 0
f:      .byte 1, 1, 3, 1, 0
g:      .byte 3, 3, 1, 0
h:      .byte 1, 1, 1, 1, 0
i:      .byte 1, 1, 0
j:      .byte 1, 3, 3, 3, 0
k:      .byte 3, 1, 3, 0
l:      .byte 1, 3, 1, 1, 0
m:      .byte 3, 3, 0
n:      .byte 3, 1, 0
o:      .byte 3, 3, 3, 0
p:      .byte 1, 3, 3, 1, 0
q:      .byte 3, 3, 1, 3, 0
r:      .byte 1, 3, 1, 0
s:      .byte 1, 1, 1, 0
t:      .byte 3, 0
u:      .byte 1, 1, 3, 0
v:      .byte 1, 1, 1, 3, 0
w:      .byte 1, 3, 3, 0
x:      .byte 3, 1, 1, 3, 0
y:      .byte 3, 1, 3, 3, 0
z:      .byte 3, 3, 1, 1, 0

under:  .byte 1, 1, 3, 3, 1, 3, 0
