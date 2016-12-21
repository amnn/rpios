SECTIONS {
         /** Interrupt service routine vector table */
         .irq_isr_vtable 0x0 : {
             build/kernel/interrupts.o(.irq_isr_vtable)
         }

         /** Initial text segment, for the bootloader */
         .init 0x8000 : {
             *(.init)
         }

         .text : { *(.text) }
         .data : { *(.data) }

         /DISCARD/ : { *(*) }
}
