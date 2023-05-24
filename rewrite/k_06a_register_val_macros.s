.macro clr reg
	mov \reg, 0
.endm

.macro clr2 rega regb
	mov \rega, 0
	mov \regb, 0
.endm

.macro clr4 rega regb regc regd
	mov \rega, 0
	mov \regb, 0
	mov \regc, 0
	mov \regd, 0
.endm

.macro logical rega
	cmp  rega, xzr
	cinc rega, xzr, gt
.endm

