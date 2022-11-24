	.section .text.startup
	.global _Reset
	_Reset:
	    b 1f
	    .skip 64

	UART_BASE: .word 0x09000000
//	UART_DATA: .byte 0x00
//	UART_FLAG: .byte 0x18
//	UART_CNTL: .byte 0x30
//	UART_FIFO: .byte 0x34
//	UART_INTC: .byte 0x44

// we want to add a macro for 
// pushing and popping, to make
// the operations slightly easier
// to write

.include "k_macros.s"
.include "k_macro_status_int.s"

	.section .text
	1:
	// SETUP CODE STARTS HERE

		// first thing we do is enable
		// unaligned stack access and
		// unaligned heap access

		mrs x0, SCTLR_EL1
		mov x1, 0x1a
		neg x1, x1
		and x0, x0, x1
		msr SCTLR_EL1, x0

		isb

		// here we'll set up the FPU as well

		mov x0, #(0x3 << 20)
		msr cpacr_el1, x1

		isb

		// and finally the stack itself

		ldr x0, =stack_top
	    add x0, x0, 0x4
    	mov sp, x0

    	mov x0, xzr
    	mov x1, xzr

    	isb

    	// check if RNG is enabled or not

    	mrs x0, ID_AA64ISAR0_EL1
    	//mrs x13, ID_AA64ISAR1_EL1
    	//mrs x16, s3_0_c0_c6_2 		// aa64isar2_el1
    	lsr x0, x0, 60
    	and x0, x0, 1

    	cbz x0, _skip_rng_fallback

    	adr x0, _rng_64_branch
    	adr x1, _rng_64_hardware
    	str x1, [x0]

    	_skip_rng_fallback:

    	isb

    	b 2f

	2:
		.include "k_uart_setup.s"

		// now the UART should be barebones functional
		
		// we have a UART uputc function now, so we can
		// test whether the device is busy, and wait
		// until it's free to blast it with bytes. 

	.include "k_ramfb_init.s"

		/*
			and now ramfb is set up
			and should be working well
			after this point, it should run the colourful paint
			and various functionality tests
		*/

	.include "k_testing_functionality.s"


	terminate:
	997:
		//wfe
		status_int

		wfi

		ldr x0, =0x84000008
		hvc #0

	/////////////////////////// strings

	DMA_DETECTED:   		.asciz "DMA device detected!\n\r"
	DMA_READ_BEGIN: 		.asciz "Probing the fw_cfg file directory through the DMA interface.\n\r"
	DMA_READ_NUM_FILES:		.asciz "Found nr of files: 0x"
	EXAMPLE_STRING:         .asciz "ABC"
	PLEASE_WRITE:           .asciz "Please input a key and I'll do my best to repeat it and tell you if it's odd or even: "
	RAMFB_INITIALISED: 		.asciz "Framebuffer initialised. Current dimensions (x, y, bpp): 1024, 768, 4bpp"

	TEMPLATE_TEST_STRING:   .asciz "Test @ @ @ Test!"

	STACK_IN_USE:			.asciz "Stack starts at 0x@, SP is currently at 0x@; there are 0x@ bytes of stack remaining."

	.align 8

	.include "k_procedures.s"
	.include "k_font.s"
	.include "k_sha-256.s"