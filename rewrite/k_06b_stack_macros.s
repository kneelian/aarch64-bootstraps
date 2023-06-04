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

.macro pshw rega
	str \rega, [sp, #-4]!
.endm

.macro popw rega
	ldr \rega, [sp], 4
.endm

.macro pshw2 rega regb
	stp \rega, \regb, [sp, #-8]!
.endm

.macro popw2 rega regb
	ldp \rega, \regb, [sp], 8
.endm