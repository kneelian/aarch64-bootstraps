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

.macro ping
	psh x0
	psh x30 

	mov x0, 'e'
	psh x0
	bl _uputc
	newline

	pop x30
	pop x0
.endm

.macro status_int
	newline

	psh x0
	psh x30

	mov x0, 0x3a
	psh x0
	mov x0, 0x30
	psh x0
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	ldr x0, [sp]
	psh x0
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x31
	psh x0
	mov x0, 0x30 
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x1
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x32
	psh x0
	mov x0, 0x30 
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x2
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x33
	psh x0
	mov x0, 0x30 
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x3
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x34
	psh x0
	mov x0, 0x30 
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x4
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x35
	psh x0
	mov x0, 0x30 
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x5
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x36
	psh x0
	mov x0, 0x30 
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x6
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x37
	psh x0
	mov x0, 0x30 
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x7
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x38
	psh x0
	mov x0, 0x30 
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x8
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x39
	psh x0
	mov x0, 0x30 
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x9
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x30
	psh x0
	mov x0, 0x31 
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x10
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x31
	psh x0
	mov x0, 0x31 
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x11
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x32
	psh x0
	mov x0, 0x31 
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x12
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x33
	psh x0
	mov x0, 0x31 
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x13
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x34
	psh x0
	mov x0, 0x31 
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x14
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x35
	psh x0
	mov x0, 0x31 
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x15
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x36
	psh x0
	mov x0, 0x31 
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x16
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x37
	psh x0
	mov x0, 0x31 
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x17
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x38
	psh x0
	mov x0, 0x31 
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x18
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x39
	psh x0
	mov x0, 0x31 
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x19
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x30
	psh x0
	mov x0, 0x32
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x20
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x31
	psh x0
	mov x0, 0x32
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x21
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x32
	psh x0
	mov x0, 0x32
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x22
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x33
	psh x0
	mov x0, 0x32
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x23
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x34
	psh x0
	mov x0, 0x32
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x24
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x35
	psh x0
	mov x0, 0x32
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x25
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x36
	psh x0
	mov x0, 0x32
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x26
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x37
	psh x0
	mov x0, 0x32
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x27
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x38
	psh x0
	mov x0, 0x32
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x28
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x39
	psh x0
	mov x0, 0x32
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	psh x29
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x30
	psh x0
	mov x0, 0x33
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	ldr x30, [sp]
	psh x30
	bl _int2hex
	add sp, sp, 8
	newline

	mov x0, 0x3a
	psh x0
	mov x0, 0x70
	psh x0
	mov x0, 0x73
	psh x0
	mov x0, 0x78
	psh x0
	bl _uputc
	bl _uputc
	bl _uputc
	bl _uputc
	add sp, sp, 32
	mov x0, sp
	psh x0
	bl _int2hex
	add sp, sp, 8
	newline

	pop x0
	pop x30
.endm
