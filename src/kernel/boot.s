        .section .init
        .global _start

_start: @ GPIO Base Address
        ldr r0, =0x20200000


        @ GPIO Pin 16 is Output
        mov r1, #1
        lsl r1, #18
        str r1, [r0, #4]

        @ Signal Pin
        mov r1, #1
        lsl r1, #16
        str r1, [r0, #40]

_hacf:  b _hacf
