
	psh2 x0, x1
	psh2 x2, x3
	clr4 x0, x1, x2, x3
	//psh  x4

	mov x3, 0xC000
	lsl x3, x3, 4

	_fractal_loop:
		
		cmp  x0, 1024
		b.eq _f_x0_toobig
		_f_resume:



		sub  x3, x3, 1
		cbnz x3, _fractal_loop


	//pop  x4
	pop2 x2, x3
	pop2 x0, x1
	b terminate

	_f_x0_toobig:
		mov x0, xzr
		add x1, x1, 1
		b   _f_resume
//
