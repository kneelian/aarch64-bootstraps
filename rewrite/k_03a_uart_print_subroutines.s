	_sub_newline:
		psh x30
		mov x0, 10
		psh x0
		bl _uputc

		add x0, x0, 3
		psh x0
		bl _uputc

		pop x30
	ret

	.macro _m_newline
		psh x30
		mov x0, 10
		psh x0
		bl _uputc
		add x0, x0, 3
		psh x0
		bl _uputc
		pop x30
	.endm

	// our print function
	// takes 1 arg on stack, returns 0
	// trashes 2 registers
	.global _uputc
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
	    ldr  x1, [sp, 16]	   // reads argument from stack - 3 words
	    str  x1, [x0]

	    pop2 x0, x1
	    add  sp, sp, 8         // pop the argument off the stack

	    ret


	/*
	   string print function
	 	  x0 - address of string
          x1 - scratch register for bytes

	  takes string address in x0, returns nothing
	  void _uputs(char* a, char scratch);
	*/

	_uputs_x0:
		psh x30
		psh x1

		ldrb w1, [x0]
		cbz  x1, _uputs_x0_end

		_uputs_x0_loop:
			psh  x1
			bl   _uputc

			add  x0, x0, 1
			ldrb w1, [x0]
			cbnz x1, _uputs_x0_loop
	_uputs_x0_end:
	pop x1
	pop x30
	ret

	/*
		pseudo-printf function
		takes address of string in x0,
		   arbitrary number of arguments on stack
	      	   (signified through use of @ template char)
		returns nothing
	*/
	_uprintf_x0:
		psh x30
		psh x1
		psh x2

		mov x2, 24

		ldrb w1, [x0]
		cbz  x1, _uprintf_x0_end

		_uprintf_x0_loop:
			cmp  w1, 0x40 // compare to '@'
			b.eq _uprintf_x0_control_char

			psh x1
			bl  _uputc

			add  x0, x0, 1
			ldrb w1, [x0]
			cbnz w1, _uprintf_x0_loop
			b    _uprintf_x0_end

			_uprintf_x0_control_char:
			ldr x1, [sp, x2]
			add x2, x2, 8
			psh x0
			mov x0, x1
			bl  _uputs_x0
			pop x0
			b _uprintf_x0_loop

	_uprintf_x0_end:
	pop x2
	pop x1
	pop x30
	ret
