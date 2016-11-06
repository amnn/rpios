        .section .init
        .global _start

_start: @@ Entry point to the kernel.

        ldr r0, =GPIO

        @ GPIO Pin 16 is Output
        mov r1, #1
        lsl r1, #18
        str r1, [r0, #4]

_sloop: @ Flash "hello world"
        bl h
        bl e
        bl l
        bl l
        bl o
        bl word
        bl w
        bl o
        bl r
        bl l
        bl d
        bl word
        bl word
        b _sloop

        @ Halt and Catch Fire
_hacf:  b _hacf

GPIO:   @@ Base Address of the GPIO Registers.
        .word 0x20200000

delay:  @@ Wait for `n` units of time.
        @@
        @@ n : r0    Units of time.

        ldr r1, =0x200000
        mul r1, r0
_dloop: subs r1, #1
        bne _dloop
        bx lr

clear:  @@ Clear output on GPIO pin 16

        ldr r0, GPIO
        mov r1, #1
        lsl r1, #16
        str r1, [r0, #40]
        bx lr

set:    @@ Set output on GPIO pin 16

        ldr r0, GPIO
        mov r1, #1
        lsl r1, #16
        str r1, [r0, #28]
        bx lr

dot:    @@ Turn the LED on for the length of a morse code dot.

        push {lr}
        bl clear
        mov r0, #1
        bl delay
        bl set
        mov r0, #1
        bl delay
        pop {pc}

dash:   @@ Turn the LED on for the length of a morse code dash.

        push {lr}
        bl clear
        mov r0, #2
        bl delay
        bl set
        mov r0, #1

letter: @@ Wait for the length of a space.
        push {lr}
        mov r0, #1
        bl delay
        pop {pc}

word:   @@ Wait for the length of a space.
        push {lr}
        mov r0, #3
        bl delay
        pop {pc}

        @@ Morse code alphabet
h:      push {lr}
        bl dot
        bl dot
        bl dot
        bl dot
        bl letter
        pop {pc}

e:      push {lr}
        bl dot
        bl letter
        pop {pc}

l:      push {lr}
        bl dot
        bl dash
        bl dot
        bl dot
        bl letter
        pop {pc}

o:      push {lr}
        bl dash
        bl dash
        bl dash
        bl letter
        pop {pc}

w:      push {lr}
        bl dot
        bl dash
        bl dash
        bl letter
        pop {pc}

r:      push {lr}
        bl dot
        bl dash
        bl dot
        bl letter
        pop {pc}

d:      push {lr}
        bl dash
        bl dot
        bl dot
        bl letter
        pop {pc}
