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
			- one of the specifiers is illegal or reserved
	*/
	_c_read_line_exit_preamble:
		b _c_read_line_exit
	_c_read_line:
		psh  x30
		psh2 x0, x1
		psh2 x2, x3
		psh2 x4, x5
		psh2 x6, x7
		psh2 x8, x9

		mov x4, 1

		ldr x0, [sp, 88] // address of struct
		ldr x1, [x0], 4  // line number
		ldr x2, [x0], 4  // size of font
		ldr x3, [x0], 4  // number of font

		cbnz x3, _c_read_line_exit_preamble
			// there is only one font allowed for now

		cbz  x2, _c_read_line_size_0

		cmp  x2, x4
		b.eq _c_read_line_size_1

		add  x4, x4, 1
		cmp  x2, x4
		b.eq _c_read_line_size_2

		b _c_read_line_exit
			// reserved sizes are a silent failure

		_c_read_line_size_0:
			//   8x8. this means the max line number is 96
			//   and max line width is 128
			mov x5, 96
			mov x6, 128

			cmp  x1, x5
			b.ge _c_read_line_exit

		_c_read_line_size_1:
			//  8x16. this means the max line number is 48 
			//  and max line width is 128
			mov x5, 48
			mov x6, 128

			cmp  x1, x5
			b.ge _c_read_line_exit

		_c_read_line_size_2:
			// 16x16. this means the max line number is 48 
			// and max line width is 64
			mov x5, 48
			mov x6, 64

			cmp  x1, x5
			b.ge _c_read_line_exit

		mov x4, 0 // counter: how many characters have we written?

		_c_read_line_loop:
			ldr  x3, [x0], 2 // reusing it since we have only one font for now; WIP
			and  x3, x3, 0xffff

			cbz  x3, _c_read_line_exit // 0x0000 null EOL
			sub  x3, x3, 0xa
			cbz  x3, _c_read_line_exit
			sub  x3, x3, 0x2
			cbz  x3, _c_read_line_exit
			add  x3, x3, 0xd

			/*
				WIP
				here we're supposed to do funny printies
			*/

			// x2 holds size

			cbz x2, _c_read_line_loop_8x8
			sub x2, x2, 1
			cbz x2, _c_read_line_loop_8x16
			sub x2, x2, 1
			cbz x2, _c_read_line_loop_16x16

			b _c_read_line_exit // somehow this failed good job
			// this branch is literally impossible or else
			// it wouldve happened already, but safety first kids

			_c_read_line_loop_8x8:
			ldr x7, =SIMPLE_FONT_8x8
			add x7, x7, x3

			lsl x8, x1, 3 // mul 8
			// x8 holds the y pixel
			lsl x9, x4, 3 // mul 8
			// x9 holds the x pixel
			mov  w5, 1
			str  w5, [sp, -4]! // col pt 1
			movn w5, 0
			str  w5, [sp, -4]! // col pt 2
			str  w8, [sp, -4]! // y
			str  w9, [sp, -4]! // x 
			psh  x7			   // bitmap 

			bl _draw_8x8
			b  _c_read_line_loop_skip

			_c_read_line_loop_8x16:
			ldr x7, =SIMPLE_FONT_8x16
			add x2, x2, 1
			add x3, x3, x3
			add x7, x7, x3

			lsl x8, x1, 4 // mul 16
			// x8 holds the y pixel
			lsl x9, x4, 3 // mul 8
			// x9 holds the x pixel
			mov  w5, 1
			str  w5, [sp, -4]! // col pt 1
			movn w5, 0
			str  w5, [sp, -4]! // col pt 2
			str  w8, [sp, -4]! // y
			str  w9, [sp, -4]! // x 
			psh  x7			   // bitmap 

			bl _draw_8x16
			b  _c_read_line_loop_skip

			_c_read_line_loop_16x16:
			ldr x7, =SIMPLE_FONT_16x16
			add x2, x2, 2
			add x3, x3, x3
			add x3, x3, x3
			add x7, x7, x3

			lsl x8, x1, 4 // mul 16
			// x8 holds the y pixel
			lsl x9, x4, 4 // mul 8
			// x9 holds the x pixel
			mov  w5, 1
			str  w5, [sp, -4]! // col pt 1
			movn w5, 0
			str  w5, [sp, -4]! // col pt 2
			str  w8, [sp, -4]! // y
			str  w9, [sp, -4]! // x 
			psh  x7			   // bitmap 

			bl _draw_16x16
			b  _c_read_line_loop_skip

			_c_read_line_loop_skip:

			cmp  x4, x6
			b.ge _c_read_line_exit
			add  x4, x4, 1

			b _c_read_line_loop

		_c_read_line_exit:
			// something errored. this is the label that
			// restores the stack and cleanly returns to caller
		pop2 x8, x9
		pop2 x6, x7
		pop2 x4, x5
		pop2 x2, x3
		pop2 x0, x1
		pop  x30
		add  sp, sp, 8
		ret

	/*
		blanks the screen one pixel at a time
		no arguments are passed
	*/

	_blank_screen:
		psh2 x0, x1
		psh  x2

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

		pop  x2
		pop2 x0, x1 

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

		add sp, sp, 24
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
