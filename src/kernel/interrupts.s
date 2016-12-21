        /**
         * Interrupts
         *
         * Manage the operation of ARM interrupts. Enable/disable interrupts,
	 * and set-up the interrupt handlers.
         */
        .section .text
        .align

        /** private IRQ_BASE_ADDR */
IRQ_BASE_ADDR:  .word   0x2000B000

        /**
         * public void irq_enable()
         *
         * Enable Interrupt Requests.
         */
        .global irq_enable
        cpsie   i
        mov     pc,     lr

        /**
         * public void irq_disable()
         *
         * Disable Interrupt Requests.
         */
        .global irq_disable
        cpsid   i
        mov     pc,     lr

        /**
         * public void fiq_enable()
         *
         * Enable Fast Interrupts.
         */
        .global fiq_enable
        cpsie   f
        mov     pc,     lr

        /**
         * pubflic void fiq_disable()
         *
         * Disable Fast Interrupts.
         */
        .global fiq_disable
        cpsid   f
        mov     pc,     lr

        .section .irq_isr_vtable
        .align

vreset: .word 0x1
vundef: .word 0x2
vswi:   .word 0x3
vpabrt: .word 0x4
vdabrt: .word 0x5
        .word 0x0 // Reserved
virq:   .word 0x6
vfiq:   .word 0x7
