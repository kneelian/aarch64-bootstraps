.macro clr reg
	eor \reg, \reg, \reg
.endm

.macro clr2 rega regb
	eor \rega, \rega, \rega
	eor \regb, \regb, \regb
.endm

.macro inc reg
	add \reg, \reg, 1
.endm

.macro newline
	psh x0
	mov x0, 13
	psh x0
	mov x0, 10
	psh x0
	bl  _uputc
	bl  _uputc
	pop x0
.endm

.macro dec reg
	sub \reg, \reg, 1
.endm

.macro clr4 rega regb regc regd
	eor \rega, \rega, \rega
	eor \regb, \regb, \regb
	eor \regc, \regc, \regc
	eor \regd, \regd, \regd
.endm

.macro mod rega regb temp
	psh \temp

	udiv \temp, \rega, \regb
	msub \rega, \temp, \regb, \rega

	pop \temp
.endm

.macro psh reg 
	str \reg, [sp, #-8]!
.endm

.macro psh2 rega regb
	stp \rega, \regb, [sp, #-16]!
.endm

.macro pop reg
	ldr \reg, [sp], 8
.endm

.macro pop2 rega regb
	ldp \rega, \regb, [sp], 16
.endm

// also adding a macro to 
// make writing to memory itself easier

.macro write_mem addr, val, reg10 = x10, reg11 = x11
	psh2 \reg10, \reg11
	ldr  \reg10, =\addr
	ldr  \reg11, =\val
	str  \reg11, [\reg10]
	pop2 \reg10, \reg11
.endm