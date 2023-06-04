.include "k_06a_register_val_macros.s"
.include "k_06b_stack_macros.s"

.section .text.startup
.global _Reset

_Reset:
	b 1f

.include "k_04_globals.s"

/*
	kernel rewrite starts here
	30.3.23
	first things we need to do are
		- implement exceptions
		- set up a sane handler for vectors
		- do more sophisticated EL code
	the old code assumed we start in EL1
	which is a valid assumption for the virt
	but writing too platform specific code
	is kinda icky bros

	19.5.23
	we are certainly starting in EL1 and handling
	EL2/3 code is fucked, so I'm ignoring the above
	advice I gave myself
        on the other hand, I've implemented EL switching
    in the most basic way imaginable, and there is a
    basic interrupt / exception handler skeleton
    in place. maybe in a later iteration i'll allow
    code that starts in a higher EL than EL1
*/

1:
	/*
		first thing we do is put the core to sleep
		if it's not the main core
		we are guaranteed to be in at least EL1 so
		the check goes through the EL1 register
	*/

	mrs  x0, mpidr_el1
	and  x0, x0, 0x3
	cbz x0, nosleep

sleep:
	wfi
	b sleep

nosleep:

	ldr x1, =_VECTOR_TABLE_EL1
	msr VBAR_EL1, x1
	ldr x1, =stack_top_el1
//	msr sp_EL1, x1				// contrary to what official docs say, this traps
	mov sp, x1
	ldr x1, =stack_top_el0
	msr sp_EL0, x1

	mov x1, (1 << 16)
	orr x1, x1, (1 << 18)
	orr x1, x1, (1 << 6)  // unaligned access
	mov x2, (1 << 4)
	orr x2, x2, (1 << 3)
	orr x2, x2, (1 << 1)
	neg x2, x2
	and x1, x1, x2 // disable SP faults
	msr SCTLR_EL1, x1

	mov x1, #(0x3 << 20) // enable FPU, SIMD
	orr x1, x1, #(0x3 << 16) // further SIMD
	msr CPACR_EL1, x1
	isb

	/*
		after this, it's time to set up the UART,
		the framebuffer, and all the rest of the
		gang that we had last time
	*/

.include "k_03_uart_setup.s"

	// uart is now working and we should be getting
	// serioal throughput

	b 2f

	_UART_ACTIVATED_MSG: .asciz "UART is now activated\n\r"
	.align 8
	_KERNEL_MSG: .asciz "Kernel version: @\n\r"
	.align 8
	_KERNEL_VER: .asciz "0.01b"
	.align 8

2:
	ldr x0, =_UART_ACTIVATED_MSG
	bl  _uputs_x0

	ldr x0, =_KERNEL_MSG
	ldr x1, =_KERNEL_VER
	psh x1
	bl  _uprintf_x0

   	mov x2, 0x51
	psh x2
	psh x2
	psh x2
	psh x2
   	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	bl _sub_newline

	mov x5, 1000
	fmov d4, x5
	/*
		generally speaking, we should finish setting up
		our kernel functions before we relinquish control
		to userland, so this block should always come
		last in the kernel, when we are calling processes
	*/

	wfi // we are bricking here for now

	mrs  x1, SPSR_EL1
	and  x2, x1, 0xf
	sub  x1, x1, x2
	msr  SPSR_EL1, x1
	ldr x1, =el0_entry
	msr ELR_EL1, x1

	eret

	wfi
	b sleep

el0_entry:
	wfi
	b sleep

.include "k_02_vtable.s"
.include "k_03a_uart_print_subroutines.s"
