// text-related console procedures and functions

	.align 8
	/*
		reads a line (pointer to bytestream first argument)
		until it either reaches 0x0000 or 0x000a or 0x000d
		which denote end of line

		every line struct has the shape:
			0x0: number of line in console
			0x4: size of font in pixels
				- 0 ==  8x8
				- 1 ==  8x16
				- 2 == 16x16
				- rest are left reserved
			0x8: font selector
				- 0 == first font
				- 1 == second font
				...
			0xC: first character of stream: these are read
				 four at a time (one whole register)

		returns nothing. can fail silently.
		function performs some elementary sanity checks
		to see that it isn't writing outside legal memory.

		it will fail and return if:
			- the line number is illegal (96+ for 8x8, 48+ for 16x16)
			- character is beyond line width (128+ for 8x8, 64+ for 16x16)
			- it encounters one of the illegal characters
	*/
	_c_read_line:
		psh  x30


		pop  x30
		ret


	/*
		blanks the screen one pixel at a time
		no arguments are passed
	*/

	_blank_screen:
		psh2 x0, x1
		psh2 x2, x3
		psh  x4

		ldr x0, =ramfb_bottom
		mov x1, 1024
		mov x2, 768
		mul x1, x1, x2

		// now x1 contains the number of pixels to write

		mov x2, 0
		_blank_screen_loop:
			str  x2, [x0]
			add  x0, x0, 4
			sub  x1, x1, 1
			cbnz x1, _blank_screen_loop

		pop  x4
		pop2 x2, x3
		pop2 x0, x1 

		mov x17, 0x5050

		ret

	/*
		draws a single 8x8 character to screen
		supposed to be a low-level routine for 8px character handling
		takes 4 arguments on stack, returns 0
			- colour  (word)
			- start y (word)
			- start x (word)
			- bitmap for character (dword)

			colour zero means transparent; use 0x1 for black
	*/
	_draw_8x8:
		psh2 x0, x1
		psh2 x2, x3
		psh2 x4, x5
		psh2 x6, x30
		psh2 x7, x8
		psh2 x9, x10

		ldr  x0, [sp, 96] // bitmap dword 
		ldr  w1, [sp, 104] // start x
		ldr  w2, [sp, 108] // start y
		ldr  x3, [sp, 112] // colour (first bg then fg)

		mov x4, 8  // num of cols
		mov x5, 8  // num of rows

		clr x6     // temp for bitshifted
		mov x7, 63 // num of times to bitshift

		clr2 x8, x9 // x8 + x4 = 8, etc

		clr2 x10, x30

		_draw_8x8_loop_1:
			mov x4, 8
			mov x8, 0

			_draw_8x8_loop_2:
				lsr x6, x0, x7
				sub x7, x7, 1

				and x6, x6, 0x1

				sub x4, x4, 1
				add x8, x8, 1

				cbnz x6, _draw_8x8_loop_2_fg

				ror x3, x3, 32

				cbz w3, _draw_8x8_loop_2_skip_2

				_draw_8x8_loop_2_fg:

				add x10, x8, x1
				add x30, x9, x2

				str w10, [sp, -4]!
				str w30, [sp, -4]!
				str w3,  [sp, -4]!
				bl  _drawpx

				cbnz x6, _draw_8x8_loop_2_skip

				_draw_8x8_loop_2_skip_2:

				ror x3, x3, 32

				_draw_8x8_loop_2_skip:

				cbz x4, _draw_8x8_loop_2_end
				b _draw_8x8_loop_2

			_draw_8x8_loop_2_end:

			mov x4, 8
			sub x5, x5, 1
			add x9, x9, 1

			cbz x5, _draw_8x8_loop_1_end
			b _draw_8x8_loop_1
		_draw_8x8_loop_1_end:

		pop2 x9, x10
		pop2 x7, x8
		pop2 x6, x30
		pop2 x4, x5
		pop2 x2, x3
		pop2 x0, x1

		add sp, sp, 16
		ret

	/*
		draws a single 8x16 character to screen
		supposed to be a low-level routine for 8px character handling
		takes 4 arguments on stack, returns 0
			- colour  (word)
			- start y (word)
			- start x (word)
			- bitmap for character (dword) (popped twice)

			colour zero means transparent; use 0x1 for black
	*/
	_draw_8x16:
		psh2 x0, x1
		psh2 x2, x3
		psh2 x4, x5
		psh2 x6, x30
		psh2 x7, x8
		psh2 x9, x10

		ldr  x0, [sp, 96] // bitmap dword 
		ldr  x0, [x0]
		ldr  w1, [sp, 104] // start x
		ldr  w2, [sp, 108] // start y
		ldr  x3, [sp, 112] // colour (first bg then fg)

		mov x4, 8  // num of cols
		mov x5, 8  // num of rows

		clr x6     // temp for bitshifted
		mov x7, 63 // num of times to bitshift

		clr2 x8, x9 // x8 + x4 = 8, etc

		clr2 x10, x30

		_draw_8x16_loop_1:
			mov x4, 8
			mov x8, 0

			_draw_8x16_loop_2:
				lsr x6, x0, x7
				sub x7, x7, 1

				and x6, x6, 0x1

				sub x4, x4, 1
				add x8, x8, 1

				cbnz x6, _draw_8x16_loop_2_fg

				ror x3, x3, 32
				cbz w3, _draw_8x16_loop_2_skip_2

				_draw_8x16_loop_2_fg:

				add x10, x8, x1
				add x30, x9, x2

				str w10, [sp, -4]!
				str w30, [sp, -4]!
				str w3,  [sp, -4]!
				bl  _drawpx

				cbnz x6, _draw_8x16_loop_2_skip

				_draw_8x16_loop_2_skip_2:

				ror x3, x3, 32

				_draw_8x16_loop_2_skip:

				cbz x4, _draw_8x16_loop_2_end
				b _draw_8x16_loop_2

			_draw_8x16_loop_2_end:

			mov x4, 8
			sub x5, x5, 1
			add x9, x9, 1

			cbz x5, _draw_8x16_loop_1_end
			b _draw_8x16_loop_1
		_draw_8x16_loop_1_end:

		ldr  x0, [sp, 96]
		add  x0, x0, 8
		ldr  x0, [x0]
		add  w2, w2, 8

		mov x4, 8  // num of cols
		mov x5, 8  // num of rows

		clr x6     // temp for bitshifted
		mov x7, 63 // num of times to bitshift

		clr2 x8, x9 // x8 + x4 = 8, etc

		clr2 x10, x30

		_draw_8x16_loop_1_2:
			mov x4, 8
			mov x8, 0

			_draw_8x16_loop_2_2:
				lsr x6, x0, x7
				sub x7, x7, 1

				and x6, x6, 0x1

				sub x4, x4, 1
				add x8, x8, 1

				cbnz x6, _draw_8x16_loop_2_2_fg

				ror x3, x3, 32
				cbz w3, _draw_8x16_loop_2_2_skip_2

				_draw_8x16_loop_2_2_fg:

				add x10, x8, x1
				add x30, x9, x2

				str w10, [sp, -4]!
				str w30, [sp, -4]!
				str w3,  [sp, -4]!
				bl  _drawpx

				cbnz x6, _draw_8x16_loop_2_2_skip

				_draw_8x16_loop_2_2_skip_2:

				ror x3, x3, 32

				_draw_8x16_loop_2_2_skip:

				cbz x4, _draw_8x16_loop_2_2_end
				b _draw_8x16_loop_2_2

			_draw_8x16_loop_2_2_end:

			mov x4, 8
			sub x5, x5, 1
			add x9, x9, 1

			cbz x5, _draw_8x16_loop_1_2_end
			b _draw_8x16_loop_1_2
		_draw_8x16_loop_1_2_end:

		pop2 x9, x10
		pop2 x7, x8
		pop2 x6, x30
		pop2 x4, x5
		pop2 x2, x3
		pop2 x0, x1

		add sp, sp, 16
		ret

	/*
	*/

	_draw_16x16:
		psh2 x0, x1
		psh2 x2, x3
		psh2 x4, x30

		ldr  x0, [sp, 48] // bitmap address 
		ldr  w1, [sp, 56] // start x
		ldr  w2, [sp, 60] // start y
		ldr  x3, [sp, 64] // colour (first bg then fg)

		ldr x4, [x0]

		psh x3
		str w2, [sp, -4]!
		str w1, [sp, -4]!
		psh x4
		bl _draw_8x8
		add sp, sp, 24

		add w1, w1, 8
		ldr x4, [x0, 8]

		psh x3
		str w2, [sp, -4]!
		str w1, [sp, -4]!
		psh x4
		bl _draw_8x8
		add sp, sp, 24

		sub w1, w1, 8
		add w2, w2, 8
		ldr x4, [x0, 16]

		psh x3
		str w2, [sp, -4]!
		str w1, [sp, -4]!
		psh x4
		bl _draw_8x8
		add sp, sp, 24

		add w1, w1, 8
		ldr x4, [x0, 24]

		psh x3
		str w2, [sp, -4]!
		str w1, [sp, -4]!
		psh x4
		bl _draw_8x8
		add sp, sp, 24

		pop2 x4, x30
		pop2 x2, x3 
		pop2 x0, x1 

		add sp, sp, 16
	ret