
	psh2 x0, x1
	psh2 x2, x3
	clr4 x0, x1, x2, x3
	//psh  x4

	add x2, x2, 1

	mov x3, 0xC000
	lsl x3, x3, 4

	_fractal_loop:
		cmp  x0, 1024
		b.eq _f_x0_toobig
		_f_resume:

		psh x2
		bl _hash_3r_a_64b
		pop x2

		str w0, [sp, -4]!
		str w1, [sp, -4]!
		str w2, [sp, -4]!
		bl _drawpx
		add sp, sp, 12

		add  x0, x0, 1
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
