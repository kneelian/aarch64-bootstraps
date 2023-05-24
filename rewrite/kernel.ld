ENTRY(_Reset)
SECTIONS
{
	. = 0x40000000;
	.startup . : { kernel.o(.text.startup) }
	.text : { *(.text) }
	.data : { *(.data) }
	.text.startup : { *(.text.startup) }

	bss_start = .;
	.bss : { *(.bss COMMON) }
	. = ALIGN(16);
	bss_end = .;
	
		stack_bottom_el1 = .;
		. = . + 0x100000; /* 1MB of stack memory */
		stack_top_el1 = .;

		stack_bottom_el0 = .;
		. = . + 0x100000; /* 1MB of stack memory */
		stack_top_el0 = .;

	vectors = .;
	. = . + 0x2000; /* 8192 bytes of vectors */
	ramfb_config = .;
	. = . + 0x80;   /* 128 bytes of ramfb config */
	ramfb_bottom = .;
	. = . + 0x400000; /* 4MB of framebuffer data space */
	ramfb_top = .;
	heap_bottom = .;
	. = . + 0x10000000; /* 250MB of heap and other shit */
	heap_top = .;
}
