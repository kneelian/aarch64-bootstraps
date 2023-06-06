.include "k_06b_stack_macros.s"
.include "k_06c_status_macro.s"

.section .text
.global _Ramfb_Setup

		// and we are gonna set up the framebuffer
		// here, allocating it in ram and doing all
		// sorts of funny shit

		//	the memory map is as follows:
		//		0x40000000        -- QEMU virt ram and kernel start here
		//		STK               -- depending on the size of the kernel
		//		                     the bottom of the stack can move around
		//
		//		STK + 0x00100000  -- top of stack (1mb space), bottom of vectors
		//		STK + 0x00101000  -- top of vectors, bottom of ramfb config
		//		STK + 0x00101080  -- top of ramfb config (128b), bottom of ramfb itself
		//		STK + 0x00501080  -- top of ramfb (4mb space), bottom of heap
		//		STK + 0x10501080  -- top of heap

		// The framebuffer device is basically just
		// a chunk of RAM we dedicate that QEMU will read
		// out of and blit to the screen. 

		// To configure the framebuffer, we must first communicate
		// with QEMU itself, by trawling the QEMU config tree
		// in the device's memory, figuring out if we can use the DMA
		// interface, then writing the configuration through
		// DMA to QEMU's config in big-endian order (!!), and
		// only then can we use the framebuffer.

		// Note that the framebuffer *requires* fw_cfg
		// to have an enabled DMA, so our first step would be
		// to check if DMA is enabled and, if not, to skip
		// framebuffer setup completely and only work with 
		// UART down the line.
		// 
		// see: https://github.com/qemu/qemu/blob/
		//      e93ded1bf6c94ab95015b33e188bc8b0b0c32670
		//      /hw/display/ramfb.c#L124
		//
		// We'll do this by setting a flag if the DMA is not available,
		// and later if we write applications that require
		// the framebuffer we'll check whether it's enabled
		// and gracefully exit informing the user that the
		// functionality isn't available instead of writing to
		// memory that doesn't have any visible effect.

		// the QEMU cfg device starts at 0x09020000, and is laid out as so:
		//
		//		DATA:      0x09020000
		//		SELECTOR:  0x09020008
		//		DMA ADRS:  0x09020010
		//
		// to see if the DMA is available we need to pass 0x0000 to the
		// selector, and then read 8 bytes from the address in the ADDRESS register
	_Ramfb_Setup:
		psh  x30
		ldr  x0, =0x09020000 // base address, also data address address
		add  x0, x0, 8       // selector

		// the way the DMA interface works is that you set up a chunk
		// of your own memory where you write 32 bits of control,
		//                                    32 bits of length,
		//                                    64 bits of address
		// per operation you want to perform. The operations are
		// stored in the lower nibble of the control in this way:
		//   0x1  error
		//   0x2  read
		//   0x4  skip
		//   0x8  select (from the upper 16 bits)
		//   0x10 write 

		// the read op reads LENGTH bytes from the current selector
		//            and offset into ADDRESS provided
		// the write op writes LENGTH bytes from the address into
		//            the selected item and drops excess bytes, and set bit
		//            zero in the control field (also set when writing to read
		//            only items) but we dont care about the errors really

		// if all bits are clear then the op completed successfully
		// if the error bit is set then you fucked up

		// the DMA interface accepts only big-endian input, and must be
		// written to with a 64-bit write or 2x32-bit writes in this way.

		// to set up the ramfb, we need to read/write to the DMA to find the
		// ramfb file, then write a config to it via the interface above

		ldr x2, =heap_bottom
		add x0, x0, 8 // root of cfg interface

		mov w3, 0x190000
		add w3, w3, 0xA
		rev w3, w3
		mov w4, 768
		rev w4, w4
		add x5, x2, 16
		rev x5, x5

		str w3, [x2]
		add x2, x2, 4
		str w4, [x2]
		add x2, x2, 4
		str x5, [x2]
		sub x2, x2, 8

		isb

		rev x2, x2
		str x2, [x0]	// important: you have to pass the address to the DMA
	    rev x1, x2      //    in big endian format, not little endian

		ldr w6, [x1, 16]
		ldr x7, [x1, 24]
		ldr x8, [x1, 40]
		rev w6, w6
		rev x7, x7
		rev x8, x8

		isb

		ldr x16, =0x6574632F72616D66
		rev x16, x16

		add x1, x1, 22

		/*

			the directory is in the format:
				u32 - size
				responses

			the response is in the format:
				u32 - size
				u16 - select
				u16 - reserved
			 u8[56] - name

		trawling the directory, which we load wholesale 
		into the heap, is a bit painful, but it makes sense
		ultimately. so rn we have */

		dma_find_file_loop:
			sub w6, w6, 1
			//cbz w6, 997f

			ldr w12, [x1]
			ldr x13, [x1, 6]
			ldr x14, [x1, 14]

			cmp  x13, x16
			b.eq dma_find_file_loop_end

			add x1, x1, 64

			b dma_find_file_loop

		dma_find_file_loop_end:

		rev  w12, w12
		and  w12, w12, 0xff

		/*
			so now we have the file selector in w12
			and the name in x13. we have to set up the
			config item, and then pass it to item in w12

			the cfg interface is in x0
			the bottom of the memory area is in x1
			the big endian address is in x2
		*/

		ldr x1, =heap_bottom
		rev x2, x1

		add w3, wzr, w12
		lsl w3, w3, 16
		add w3, w3, 0x18
		rev w3, w3
		mov w4, 28
		rev w4, w4

		ldr x5, =ramfb_config
		rev x5, x5

		str w3, [x1]
		str w4, [x1, 4]
		str x5, [x1, 8]

		rev x5, x5

		/* 

		typedef struct {
		    uint32_t control;
		    uint32_t length;
		    uint64_t address;
		} __attribute__((__packed__)) QemuCfgDmaAccess;
	
		*/

		ldr x6, =ramfb_bottom
		ldr w7, =0x58523234
		mov w8, wzr
		mov w9, 1024
		mov w10, 768
		lsl w11, w9, 2

		rev x6, x6
		rev w9, w9
		rev w10, w10
		rev w11, w11
	
		str x6,  [x5]
		str w7,  [x5, 8]
		str w8,  [x5, 12]
		str w9,  [x5, 16]
		str w10, [x5, 20]
		str w11, [x5, 24]

		str x2, [x0]

	ldr  x0, =ramfb_bottom
	mov  x1, 768
	mov  x2, 4096    // 1024 x 4
	mul  x1, x1, x2
	movn x3, 0x0
	_clear_screen_loop:
		str  x3, [x0, x1]
		sub  x1, x1, 4
		cbnz x1, _clear_screen_loop

	psh x30

	mov  x10, 512
	mov  x11, 384
	mov  x12, xzr

	_putpx_test:
		cbz w10, 1f
		cbz w11, 1f
		pshw w10
		pshw w11
		pshw w12
		bl _put_px
		sub  w10, w10, 1
		sub  w11, w11, 1
		b _putpx_test
	1:

		mov x10, 256
		mov x11, 512
		mov x12, 128
		mov x13, 384
		mov x14, xzr
		pshw w10
		pshw w11
		pshw w12
		pshw w13
		pshw w14
	bl _draw_rect

		mov x10, 312
		mov x11, 748
		mov x12, 158
		mov x13, 212
		mov w14, 0x9900
		add w14, w14, 0xff
		pshw w10
		pshw w11
		pshw w12
		pshw w13
		pshw w14
	bl _draw_rect

		mov x10, 115
		mov x11, 524
		mov x12, 208
		mov x13, 272
		mov w14, 0x5555
		add w14, w14, 0xff
		pshw w10
		pshw w11
		pshw w12
		pshw w13
		pshw w14
	bl _draw_rect

		mov x10, 31
		mov x11, 440
		mov x12, 258
		mov x13, 412
		mov w14, 0xf000
		add w14, w14, 0xf0
		pshw w10
		pshw w11
		pshw w12
		pshw w13
		pshw w14
	bl _draw_rect


		mov  x10, 652 // x
		mov  x11, 652 // y
		mov  x12, #0  // fg
		movn x13, #0  // bg
		mov  x14, #0  // font
		mov  x15, #4  // char  //
		pshw w14
		pshw w15
		pshw w11
		pshw w10
		pshw w13
		pshw w12
	bl _drawchar_8x8

		ldr  x10, =SIMPLE_FONT_8x8
		add  x10, x10, 8
		ldr  x10, [x10]
		mov  x11, 752
		mov  x12, 752
		movn w13, 0
		ror  x13, x13, 32
		psh  x13
		pshw w12
		pshw w11
		psh  x10
	bl _draw_8x8

	pop x30
	ret

.include "k_07a_ramfb_procedures.s"
.include "k_07b_font.s"
