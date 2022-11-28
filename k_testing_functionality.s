	framebuffer_example:
		str w21, [x22]
		add w21, w21, 16
		add x22, x22, 4
		sub x20, x20, 1
		cbnz x20, framebuffer_example

	mov x0, 300
	mov x1, 300
	mov x2, 0
	sub x2, x2, 1
	str w0, [sp, -4]!
	str w1, [sp, -4]!
	str w2, [sp, -4]!
	bl _drawpx
	add sp, sp, 12

	ldr x20, =TEMPLATE_TEST_STRING
	ldr x21, =EXAMPLE_STRING

	mov x0, 0xf0fe
	psh x0
	bl  _i2hex_w
	pop x0
	rev32 x0, x0
	ldr x1, =heap_bottom
	str x0, [x1]

	psh x1
	psh x21
	psh x21
	psh x20
	bl _ufputs
	add sp, sp, 24

	mov x0, 47
	mov x1, 10
	clr x2
	mod x0, x1, x2

	mov x0, 0xf0f0
	psh x0
	bl  _i2hex_w
	pop x0
	str x0, [x1]
	psh x1
	bl  _ufputs 

	newline

	mov x0, 0xf0f0
	psh x0
	bl _int2hex32
	pop x0

	newline

	mov  w0, 32
	mov  w1, 256
	
	ldr  x3, =SIMPLE_FONT_8x8
	ldr  x3, [x3, 24]
	
	mov  w2, 1
	str w2,  [sp, -4]!
	movn w2, 0
	str w2,  [sp, -4]!
	str w1,  [sp, -4]!
	str w0,  [sp, -4]!
	psh x3
	bl _draw_8x8
	add sp, sp, 24

	mov w0, 48
	mov w1, 256

	ldr x3, =SIMPLE_FONT_8x16

	mov w2, 1
	str w2,  [sp, -4]!
	movn w2, 0
	str w2,  [sp, -4]!
	str w1,  [sp, -4]!
	str w0,  [sp, -4]!
	psh x3
	bl _draw_8x16
	add sp, sp, 24

	add x3, x3, 16
	add w0, w0, 40
	add w1, w1, 40
	mov w2, 1
	str w2,  [sp, -4]!
	movn w2, 0
	str w2,  [sp, -4]!
	str w1,  [sp, -4]!
	str w0,  [sp, -4]!
	psh x3
	bl _draw_8x16
	add sp, sp, 24

	mov w0, 40
	mov w2, 0
	str w2,  [sp, -4]!
	movn  w2, 0
	str w2,  [sp, -4]!
	str w1,  [sp, -4]!
	str w0,  [sp, -4]!
	psh x3
	bl _draw_8x16
	add sp, sp, 24

	mov w0, 64
	ldr x3, =SIMPLE_FONT_16x16
	mov w2, 1
	str w2,  [sp, -4]!
	movn w2, 0
	str w2,  [sp, -4]!
	str w1,  [sp, -4]!
	str w0,  [sp, -4]!
	psh x3
	bl _draw_16x16

	bl _rng_64
	psh xzr
	newline 
	bl _hash_3r_a_64b
	bl _int2hex

	b terminate