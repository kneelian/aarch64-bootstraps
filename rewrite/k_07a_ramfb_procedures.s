/*
	pixel draw function
		sp    > colour i32
		sp-4  > y      i32
		sp-8  > x      i32

	trashes x0-x4

	takes colour, x, y on stack, returns nothing
	void _put_px(int x, int y, int colour);
*/

.global _put_px
_put_px:
	
	popw w3  // colour
	popw w2  // y
	popw w1  // x
	ldr  x0, =ramfb_bottom
	
	mov  x4, 1024
	madd x2, x2, x4, x1
	lsl  x2, x2, 2
	str  w3, [x0, x2]

	ret

/*
	pixel draw function
		x20 - colour
		x21 - xpos
		x22 - ypos
		x23 - temp
		x24 - temp

	basically the above one with
	a different calling convention
	for convenience
*/
.global _put_px_x20
_put_px_x20:
	ldr x23, =ramfb_bottom
	mov  x24, 1024
	madd x22, x22, x24, x21
	lsl  x22, x22, 2 
	str  w20, [x23, x22]
	ret


/*
	*old* pixel draw function
		sp+40  > colour i32
		sp+44  > y      i32
		sp+48  > x      i32

	uses and preserves x0-x4

	takes 3 args on stack, returns 0
*/
.global _drawpx
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
	rectangle draw function
		sp     > colour i32
		sp-4   > max y  i32
		sp-8   > min y  i32
		sp-12  > max x  i32
		sp-16  > min x  i32

	trashes x5-x10

	void _draw_rect();
*/

.global _draw_rect
_draw_rect:
	
	popw w10// colour

	popw w5 // ymax
	popw w6 // ymin, ycurr
	popw w7 // xmax
	popw w8 // xmin, xcurr

	psh x30

	mov w9, w8 // temporary

	/*
	assumptions:

		w5 > w6
		w7 > w8
	*/

	cmp x5, x6
	ble 99f
	cmp x7, x8
	ble 99f


	1:
		pshw w8 // x
		pshw w6 // y
		pshw w10// col

		bl _put_px

		add w8, w8, 1
		cmp w8, w7
		blt 1b         // if xmin < xmax jump back

		mov w8, w9     // otherwise restore and compare y
		add w6, w6, 1
		cmp w6, w5
		blt 1b		   // else fallthrough
	99:
	pop x30
	ret

/*
	8x8 character draw function
		sp      > fg colour i32
		sp-4    > bg colour i32
		sp-8    > x         i32
		sp-12   > y         i32
		sp-16   > char id   i32
		sp-20   > font id   i32

	the renderer takes a full descriptor of the
	character to render by stack
	the font id selects which font will be used
	to supply the character bitmaps

	font zero is the fallback font and is currently
	the only font in the font tables

	background and foreground colour encode transparency
	as well as the actual colour; if the colour is #000001
	the pixel is skipped instead of drawn
	this allows easy layering and simplistic combining
	diacritic implementation if I decide to do that later on.
*/

.global _drawchar_8x8
_drawchar_8x8:
	psh2 x0, x1
	psh2 x2, x3
	psh2 x4, x5
	psh2 x6, x30
	psh2 x7, x8

	ldr w0, [sp, 80]  // fg
	ldr w1, [sp, 84]  // bg
	ldr w2, [sp, 88]  // x
	ldr w3, [sp, 92]  // y
	ldr w4, [sp, 96]  // char id
	ldr w5, [sp, 100] // font id

	ldr x6, =FONTS_8x8
	ldr x7, [x6]       // number of fonts
	cmp w5, w7
	bge 99f

	add x5, x5, 1
	lsl w5, w5, 3

	ldr x6, [x6, x5]   // load the font we want

	lsl x5, x4, 3
	add x6, x6, x5     // and the character from it
	ldr x6, [x6]

	rbit x6, x6

	/*
		now x6 contains the bitmap reversed
		and regs x7 and x8 are scratch
	*/

	mov x7, xzr		// x offset
	mov x8, xzr		// y offset
	1:
		and  x4, x6, #1

		cmp  x4, #1
		csel w20, w0, w1, eq

		cmp  w20, #1 // skip if transparent
		b.eq 2f

		add x21, x2, x7
		add x22, x3, x8

		bl _put_px_x20
		add x7, x7, 1

		2:

		lsr  x6, x6, 1

		cmp  x7, 8
		b.lt 1b
		
		mov  x7, xzr

		add  x8, x8, 1
		cmp  x8, 8

		b.lt 1b

	99:

	pop2 x7, x8
	pop2 x6, x30
	pop2 x4, x5
	pop2 x2, x3
	pop2 x0, x1

	add sp, sp, 24 // pop the arguments off stack! important

	ret

	/*
		OLD FUNCTION

		draws a single 8x8 character to screen
		supposed to be a low-level routine for 8px character handling
		takes 4 arguments on stack, returns 0
			- colour  (word)
			- start y (word)
			- start x (word)
			- bitmap for character (dword)

			colour zero means transparent; use 0x1 for black
	*/
	.global _draw_8x8
	_draw_8x8:
		psh2 x0, x1
		psh2 x2, x3
		psh2 x4, x5
		psh2 x6, x30
		psh2 x7, x8
		psh2 x9, x10

		ldr  x0, [sp, 96]  // bitmap dword 
		ldr  w1, [sp, 104] // start x
		ldr  w2, [sp, 108] // start y
		ldr  x3, [sp, 112] // colour (first bg then fg)

		mov x4, 8  // num of cols
		mov x5, 8  // num of rows

		mov x6, xzr // temp for bitshifted
		mov x7, 63  // num of times to bitshift

		mov x8, xzr
		mov x9, xzr

		mov x10, xzr

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
