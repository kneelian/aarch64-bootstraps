	/////////////////////// functions and subroutines
	.align 8
	/*
		draws a single 8x8 character to screen
		supposed to be a low-level routine for 8px character handling
		takes 4 arguments on stack, returns 0
			- colour  (word)
			- start y (word)
			- start x (word)
			- bitmap for character (dword)
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
		ret

	/*
		draws a single 8x16 character to screen
		supposed to be a low-level routine for 8px character handling
		takes 4 arguments on stack, returns 0
			- colour  (word)
			- start y (word)
			- start x (word)
			- bitmap for character (dword) (popped twice)
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
		ret

	/*
		8 x 16?
		16x 16?
		many options for other prints

	/*
		draw pixel
		takes 3 args on stack, returns 0
		trashes 5 registers
	*/
	_drawpx:
		psh2 x0, x1
		psh2 x2, x3
		psh  x4

		ldr x0, =ramfb_bottom

		ldr  w1, [sp, 40] // colour
		ldr  w2, [sp, 44] // y
		ldr  w3, [sp, 48] // x

		mov  w4, 1024

		madd w2, w2, w4, w3
		lsl  w2, w2, 2
		add  x0, x0, x2

		str  w1, [x0]

		pop  x4
		pop2 x2, x3
		pop2 x0, x1 
		add sp, sp, 12
	ret

	/*
		transforms int to boolean
		takes 1 arg on stack, returns 1
		trashes 1 register
	*/
	_logical:
		psh x0
		ldr x0, [sp, 8]
		cbz x0, _logical_skip
		mov x0, 1
		_logical_skip:
		str x0, [sp, 8]
		pop x0
	ret

	/*
		copies memory to memory, single bytes
		takes 3 args on stack, returns 0
		trashes 4 registers
	*/
	_memcpy:
		psh2 x0, x1
		psh2 x2, x3

		ldp x0, x1, [sp, 32]
		ldr x2, [sp, 48]

		/*
			x0 -- number of bytes to copy
			x1 -- destination of copy
			x2 -- source of copy
		*/

		_memcpy_loop:
			cbz  x0, _memcpy_loop_end
			ldrb w3, [x2]
			strb w3, [x1]
			sub  x0, x0, 1
			add  x1, x1, 1
			add  x1, x1, 1
			b _memcpy_loop
		_memcpy_loop_end:

		pop2 x2, x3 
		pop2 x0, x1
	ret

	/*
		copies memory to memory, 8 bytes at once
		takes 3 args on stack, returns 0
		trashes 4 registers
	*/
	_memcpy8:
		psh2 x0, x1
		psh2 x2, x3

		ldp x0, x1, [sp, 32]
		ldr x2, [sp, 48]

		/*
			x0 -- number of dwords to copy
			x1 -- destination of copy
			x2 -- source of copy
		*/

		_memcpy8_loop:
			cbz  x0, _memcpy8_loop_end
			ldr  x3, [x2]
			str  x3, [x1]
			sub  x0, x0, 1
			add  x1, x1, 8
			add  x1, x1, 8
			b _memcpy8_loop
		_memcpy8_loop_end:

		pop2 x2, x3 
		pop2 x0, x1
	ret

	/*
		clears a block of memory, 8 bytes at a time
		takes 2 args on stack, returns 0
		trashes 2 registers
	*/

	_clearmem:
		psh2 x0, x1
		ldr  x0, [sp, 16]
		ldr  x1, [sp, 24]

		/*
			x0 -- start of block to erase
			x1 -- number of dwords to erase
		*/

		_clearmem_loop:
			cbz x1, _clearmem_loop_end
			dec x1
			str xzr, [x0]
			add x0, x0, 8
			b   _clearmem_loop
		_clearmem_loop_end:

		pop2 x0, x1
	ret

	/*
		compares strings for equality, returns position of difference or -1 for equal
		takes 2 args on stack, returns 1
		trashes 4 registers
	*/
	_strcompare:
		psh2 x0, x1
		psh2 x2, x3
		psh2 x4, x5

		ldp x0, x1, [sp, 48] // strings to compare

		clr x2 // counter

		_strcompare_loop:
			ldrb w3, [x0]
			ldrb w4, [x1]
			cbz  w3, _strcompare_loop_end
			cbz  w4, _strcompare_loop_end

			cmp  w3, w4
			b.ne _strcompare_loop_end

			add x2, x2, 1
			b _strcompare_loop

		_strcompare_loop_end:

		cmp  w3, w4
		b.ne _strcompare_skip

		movn x2, 0 // in case the loop exits and w3 == w4, then w3 == 0, return -1

		_strcompare_skip:

		pop2 x4, x5
		pop2 x2, x3
		pop2 x0, x1
	ret

	/* broken */

	_i2dec_w:
		psh2 x0, x1
		psh2 x2, x3
		psh2 x4, x30

		clr x4

		mov w0, 10
		ldr w1, [sp, 48]

		psh xzr

		_i2dec_w_loop:
			cbz w1, _i2dec_w_loop_2
			and w2, w1, 0xf
			lsr w1, w1, 4

			psh x2
			bl  _digit2decchar
			b   _i2dec_w_loop
		_i2dec_w_loop_2:
			pop x3
			cbz x3, _i2dec_w_loop_2_end

			orr x4, x4, x3
			lsl x4, x4, 8
			b   _i2dec_w_loop_2

		_i2dec_w_loop_2_end:

		//lsr x4, x4, 8 

		str x4, [sp, 48]

		pop2 x4, x30
		pop2 x2, x3
		pop2 x0, x1
	
	/* get single int turn to char */

	_digit2hexchar:
		psh2 x0, x1

		ldr x0, [sp, 16]
		mov x1, 0x3a
		add  x0, x0, 0x30
		cmp  x0, x1
		b.lt _digit2hexchar_skip
		
		add  x0, x0, 0x7

		_digit2hexchar_skip:

		str  x0, [sp, 16]
		pop2 x0, x1
	ret

	_digit2decchar:
		psh x0
		ldr x0, [sp, 16]
		add x0, x0, 0x30
		str x0, [sp, 16]
		pop x0
	ret


	/*
	*	int to hex
	*	takes a 4-byte number on the stack
	*	returns an 8-byte 8-char string representation
	*
	*	working!
	*/
	_i2hex_w:
		psh2 x0, x1
		psh2 x2, x3
		psh2 x4, x30

		clr x4

		ldr w0, [sp, 48]
		mov w1, w0

		psh xzr

		_i2hex_w_loop:
			cbz w1, _i2hex_w_loop_2
			and w2, w1, 0xf
			lsr w1, w1, 4

			psh x2
			bl  _digit2hexchar
			b   _i2hex_w_loop
		_i2hex_w_loop_2:
			pop x3
			cbz x3, _i2hex_w_loop_2_end

			orr x4, x4, x3
			lsl x4, x4, 8
			b   _i2hex_w_loop_2

		_i2hex_w_loop_2_end:

		lsr x4, x4, 8 

		str x4, [sp, 48]

		pop2 x4, x30
		pop2 x2, x3
		pop2 x0, x1
	ret

	/*
		templated print
		takes pointer to structure on stack
		returns 0
	*/
	_ufputs:
		psh2 x0, x1
		psh2 x2, x3
		psh2 x4, x30

		add x0, sp, 48   // address of first string address 
		ldr x1, [x0]     // start of first string
		add x2, x0, 8    // first substring

		mov w4, 0x40     // '@'

		_ufputs_loop1:

			ldrb w3, [x1]
			add  x1, x1, 1
			cbz  w3, _ufputs_loop1_end
			cmp  w3, w4
			b.ne _ufputs_loop1_skip // is it 0x40 = '@'?

			// yes it is

			ldr x0, [x2]
			psh x0
			add x2, x2, 8
			bl  _uputs

			b _ufputs_loop1

			_ufputs_loop1_skip: // no it isn't

			psh x3
			bl  _uputc
			b _ufputs_loop1

		_ufputs_loop1_end:

		pop2 x4, x30
		pop2 x2, x3
		pop2 x0, x1

	ret

	// our print function
	// takes 1 arg on stack, returns 0
	// trashes 2 registers
	_uputc:
		psh2 x0, x1
		
		adrp x0, UART_BASE
		add  x0, x0, :lo12:UART_BASE
		ldr  w0, [x0]
				// now x0 has the UART_BASE location
		
		add  x0, x0, 0x18    // UART_FLAG address

		_uputc_loop1:
			ldr  x1, [x0]          // read from UART_FLAG

			and  x1, x1, 0xff      // 0010 1000 = busy & transmit full
			bic  x1, x1, 0xc0      // but we gotta do it the long way
			bic  x1, x1, 0x10
			bic  x1, x1, 0x07      
			cbnz x1, _uputc_loop1

	    sub  x0, x0, 0x18      // back to BASE / DATA
	    ldr  x1, [sp, 16]
	    str  x1, [x0]

	    pop2 x0, x1
	    add  sp, sp, 8         // pop the argument off the stack

	    ret

	// handler for string printing
	// takes 1 arg on stack, returns 0
	// trashes 4 registers
	_uputs:
		psh2 x0, x1
		psh2 x2, x30
		ldr x0, [sp, 32]    // the string address	

		_uputs_loop1:
			ldr x1, [x0]                  // the initial memory read
			cbz x1, _uputs_loop1_end

			and x2, x1, 0xff              // extract byte
			cbz x2, _uputs_loop1_end
			psh x2
			bl  _uputc 

			asr x1, x1, 8
			and x2, x1, 0xff
			cbz x2, _uputs_loop1_end
			psh x2
			bl  _uputc

			asr x1, x1, 8
			and x2, x1, 0xff
			cbz x2, _uputs_loop1_end
			psh x2
			bl  _uputc

			asr x1, x1, 8
			and x2, x1, 0xff
			cbz x2, _uputs_loop1_end
			psh x2
			bl  _uputc

			asr x1, x1, 8
			and x2, x1, 0xff
			cbz x2, _uputs_loop1_end
			psh x2
			bl  _uputc

			asr x1, x1, 8
			and x2, x1, 0xff
			cbz x2, _uputs_loop1_end
			psh x2
			bl  _uputc

			asr x1, x1, 8
			and x2, x1, 0xff
			cbz x2, _uputs_loop1_end
			psh x2
			bl  _uputc

			asr x1, x1, 8
			and x2, x1, 0xff
			cbz x2, _uputs_loop1_end
			psh x2
			bl  _uputc

			add x0, x0, 8             // shift pointer by 8, and loop

			b _uputs_loop1

		_uputs_loop1_end:

		pop2 x2, x30
		pop2 x0, x1
		add sp, sp, 8
	ret

	// our input function
	// takes 0 arg on stack, returns 1
	// trashes 2 registers
	_ugetc:
		psh xzr
		psh2 x0, x1
		
		adrp x0, UART_BASE
		add  x0, x0, :lo12:UART_BASE
		ldr  w0, [x0]
				// now x0 has the UART_BASE location
		
		add  x0, x0, 0x18    // UART_FLAG address

		_ugetc_loop1:
			ldr  x1, [x0]
			and  x1, x1, 0x10
			cbnz x1, _ugetc_loop1

		sub  x0, x0, 0x18
		ldr  x0, [x0]
		str  x0, [sp, 16]
		pop2 x0, x1
		ret

///////////////////////////////////////////////
/// RNG function
/// takes 0 arguments
/// returns 1 on the stack
/// trashes 1-3 registers

	_rng_64_branch: .quad _rng_64_fallback
	 	_rng_64:
	 		psh2 xzr, x0

	 		adr x0, _rng_64_branch
	 		ldr x0, [x0]
	 		br  x0

	 	_rng_64_hardware:
	 		mrs x0, s3_3_c2_c4_0		// rndr
	 		str x0, [sp, 8]
	 		ldr x0, [sp], 8
	 		ret
	 	_rng_64_fallback:
	 		mov x0, 0
	 		pop x30
	 		ret

///

	_int2hex:
	/*
		takes one arg on stack (64-bit hex)
		prints as hex
		returns zero
	*/
		psh2 x0, x1
		psh2 x2, x3
		psh2 x4, x30

		ldr x0, [sp, 48] // the number
		mov x1, 0x78
		psh x1
		mov x1, 0x30
		psh x1
		bl  _uputc
		bl  _uputc

		mov x2, #60
		ldr x3, =HEXDIGITS_LOWERCASE

		_int2hex_loop:
			cbz x2, _int2hex_loop_end
			lsr x1, x0, x2
			and x1, x1, 0xf
			ldr x4, [x3, x1]
			psh x4
			bl  _uputc
			sub x2, x2, 4
			b _int2hex_loop

		_int2hex_loop_end:

		and x1, x0, 0xf
		ldr x4, [x3, x1]
		psh x4
		bl  _uputc

		pop2 x4, x30
		pop2 x2, x3
		pop2 x0, x1
		ret

	_int2hex32:
	/*
		takes one arg on stack (64-bit hex)
		prints as hex
		returns zero
	*/
		psh2 x0, x1
		psh2 x2, x3
		psh2 x4, x30

		ldr w0, [sp, 48] // the number
		mov x1, 0x78
		psh x1
		mov x1, 0x30
		psh x1
		bl  _uputc
		bl  _uputc

		mov x2, #28
		ldr x3, =HEXDIGITS_LOWERCASE

		_int2hex32_loop:
			cbz x2, _int2hex32_loop_end
			lsr x1, x0, x2
			and x1, x1, 0xf
			ldr x4, [x3, x1]
			psh x4
			bl  _uputc
			sub x2, x2, 4
			b _int2hex32_loop

		_int2hex32_loop_end:

		and x1, x0, 0xf
		ldr x4, [x3, x1]
		psh x4
		bl  _uputc

		pop2 x4, x30
		pop2 x2, x3
		pop2 x0, x1
		ret

	_reverse_string:
	/*
		takes 2 arguments on stack:
			sp   -- destination address
			sp+8 -- source address, zero terminated
	*/
		ret

		HEXDIGITS_UPPERCASE:   	.asciz "0123456789ABCDEF"
		HEXDIGITS_LOWERCASE:    .asciz "0123456789abcdef"