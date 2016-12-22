        /**
         * irq_t
         *
         * Manage the operation of ARM interrupts. Enable/disable interrupts,
         * and set-up the interrupt handlers. The FIQ is currently disabled in
	 * this implementation.
         */
        .section .data
        .align

        .global IRQ_TIMER1
        .global IRQ_TIMER3
        .global IRQ_VC_USB

        .global IRQ_ARM_TIMER
        .global IRQ_ARM_MAILBOX
        .global IRQ_ARM_DOORBELL0
        .global IRQ_ARM_DOORBELL1
        .global IRQ_ARM_GPU0_HALTED
        .global IRQ_ARM_GPU1_HALTED
        .global IRQ_ARM_EACCESS0
        .global IRQ_ARM_EACCESS1

IRQ_TIMER1:             .word   0x01
IRQ_TIMER3:             .word   0x03
IRQ_VC_USB:             .word   0x09

IRQ_ARM_TIMER:          .word   0x40
IRQ_ARM_MAILBOX:        .word   0x41
IRQ_ARM_DOORBELL0:      .word   0x42
IRQ_ARM_DOORBELL1:      .word   0x43
IRQ_ARM_GPU0_HALTED:    .word   0x44
IRQ_ARM_GPU1_HALTED:    .word   0x45
IRQ_ARM_EACCESS0:       .word   0x46
IRQ_ARM_EACCESS1:       .word   0x47

        .section .text
        .align

        /** private IRQ_BASE_ADDR */
IRQ_BASE_ADDR:  .word   0x2000B000

        /**
         * public void irq_init()
         *
         * Enable interrupt requests.
         */
        .global irq_init
irq_init:
        push    {r4-r9, lr}
        ldr     r0,     =irq_isr_vtable_begin
        ldr     r1,     =0

        // Copy Vector Table
        ldmia   r0!,    {r2-r9}
        stmia   r1!,    {r2-r9}

        // Copy Link Table
        ldmia   r0!,    {r2-r8}
        stmia   r1!,    {r2-r8}

        // Enable Interrupts
        cpsie   i
        pop     {r4-r9, pc}

        /**
         * public void irq_enable(irq_t[r0] irq)
         *
         * Enable a particular IRQ.
         */
        .global irq_enable
irq_enable:

        // Calculate Register Offset
        ldr     r1,     =0x210  // Interrupt Enable 1 Offset
        b       $ie1
_ie1:   add     r1,     #4
$ie1:   subs    r0,     #32
        bge     _ie1
        add     r0,     #32

        // Write to Register
        ldr     r2,     IRQ_BASE_ADDR
        mov     r3,     #1
        lsl     r3,     r0
        str     r3,     [r2, r1]
        mov     pc,     lr

        /**
         * public void irq_disable(irq_t[r0] irq)
         *
         * Disable a particular IRQ.
         */
        .global irq_disable
irq_disable:

        // Calculate Register Offset
        ldr     r1,     =0x21C  // Interrupt Disable 1 Offset
        b       $id1
_id1:   add     r1,     #4
$id1:   subs    r0,     #32
        bge     _id1
        add     r0,     #32

        // Write to Register
        ldr     r2,     IRQ_BASE_ADDR
        mov     r3,     #1
        lsl     r3,     r0
        str     r3,     [r2, r1]
        mov     pc,     lr
        mov     pc,     lr

        /** Interrupt Service Routines */

        .global irq_handle_reset
irq_handle_reset:
        ldr     r0,     =ONE
        bl      output_morse
        b       irq_handle_reset
ONE:    .asciz "1"

        .global irq_handle_undef
irq_handle_undef:
        ldr     r0,     =TWO
        bl      output_morse
        b       irq_handle_undef
TWO:    .asciz "2"

        .global irq_handle_swi
irq_handle_swi:
        ldr     r0,     =THREE
        bl      output_morse
        b       irq_handle_swi
THREE:  .asciz "3"

        .global irq_handle_prefetch_abort
irq_handle_prefetch_abort:
        ldr     r0,     =FOUR
        bl      output_morse
        b       irq_handle_prefetch_abort
FOUR:   .asciz "4"

        .global irq_handle_data_abort
irq_handle_data_abort:
        ldr     r0,     =FIVE
        bl      output_morse
        b       irq_handle_data_abort
FIVE:   .asciz "5"

        .global irq_handle_irq
irq_handle_irq:
        ldr     r0,     =SIX
        bl      output_morse
        b       irq_handle_irq
SIX:    .asciz "6"

        /** Interrupt Service Routine Vector Table */

irq_isr_vtable_begin:

hreset: ldr     pc,     vreset
hundef: ldr     pc,     vundef
hswi:   ldr     pc,     vswi
hpabrt: ldr     pc,     vpabrt
hdabrt: ldr     pc,     vdabrt
        .word 0x0 // Reserved
hirq:   ldr     pc,     virq
hfiq:   b       hfiq

vreset: .word   irq_handle_reset
vundef: .word   irq_handle_undef
vswi:   .word   irq_handle_swi
vpabrt: .word   irq_handle_prefetch_abort
vdabrt: .word   irq_handle_data_abort
virq:   .word   irq_handle_irq
vfiq:   .word   vfiq
