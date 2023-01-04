	clr4 x0, x1, x2, x3

	add x2, x2, 2

	mov x3, 0xC000
	lsl x3, x3, 4

	_fractal_loop:
		cmp  x0, 1024
		b.eq _f_x0_toobig
		_f_resume:
		cmp  x1, 768
		b.eq _fractal_loop_end

		psh x2
		bl _hash_3r_a_64b
		pop x2
		and x4, x2, 1
		cbz x4, _f_skip
		lsr x2, x2, 12
		_f_skip:
		add x2, x2, 1

		and x4, x2, 0xff
		add x2, x2, x4
		add x2, x2, x4
		add x2, x2, x4

		str w0, [sp, -4]!
		str w1, [sp, -4]!
		str w2, [sp, -4]!
		bl _drawpx

		add  x0, x0, 1
		sub  x3, x3, 1
		cbnz x3, _fractal_loop
	_fractal_loop_end:

	b terminate

	_f_x0_toobig:
		mov x0, xzr
		add x1, x1, 1
		b   _f_resume
//
