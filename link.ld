SECTIONS {
         /** Initial text segment, for the bootloader */
         .init 0x8000 : {
             *(.init)
         }

         .text : { *(.text) }
         .data : { *(.data) }

         /DISCARD/ : { *(*) }
}
