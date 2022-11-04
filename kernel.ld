ENTRY(_Reset)
SECTIONS
{
	. = 0x40000000;
	.startup . : { kernel.o(.text.startup) }
	.text : { *(.text) }
	.data : { *(.data) }
	.bss : { *(.bss COMMON) }
	. = ALIGN(16);
	stack_bottom = .;
	. = . + 0x100000; /* 1MB of stack memory */
	stack_top = .;
	vectors = .;
	. = . + 0x1000; /* 4096 bytes of vectors */
	ramfb_config = .;
	. = . + 0x80;   /* 128 bytes of ramfb config */
	ramfb_bottom = .;
	. = . + 0x400000; /* 4MB of framebuffer data space */
	ramfb_top = .;
	heap_bottom = .;
	. = . + 0x10000000; /* 250MB of heap and other shit */
	heap_top = .;
}
