/*
	general noncrypto hashes. these are pretty much
	quick to use and don't have silly requirements
	like sha, and don't use specialised insns
*/
.align 4

_hash_3r_a_64b:
/*
	three rounds of 2 different 32b hashes
	that produce a single hashed 64b number
	the principle is:
		- hash 1 hashes lower word
		- hash 2 hashes upper word
	trashes 4 registers
	
	f: int64 -> int64
*/
	psh2 x0, x1
	psh2 x2, x3

	ldr w0, [sp, 32] // x
	ldr x1, =HASH_CONSTANTS
	ldr w2, [x1], 4 // z

	add w0, w0, w0 // x++

	lsr w3, w0, 17 // y = x >> 17
	eor w0, w0, w3 // x ^= y
	mul w0, w0, w2 // x *= z

	ldr w2, [x1], 4

	lsr w3, w0, 11
	eor w0, w0, w3
	mul w0, w0, w2

	ldr w2, [x1], 4

	lsr w3, w0, 15
	eor w0, w0, w3
	mul w0, w0, w2

	lsr w3, w0, 14
	eor w0, w0, w3 // finalised

	str w0, [sp, 32]
	ldr w0, [sp, 36] // other word

	sub w0, w0, 1 // x--

	ldr w2, [x1], 4

	lsr w3, w0, 16
	eor w0, w0, w3
	mul w0, w0, w2

	ldr w2, [x1], 4

	lsr w3, w0, 14
	eor w0, w0, w3
	mul w0, w0, w2

	ldr w2, [x1], 4

	lsr w3, w0, 16
	eor w0, w0, w3
	mul w0, w0, w2

	lsr w3, w0, 17
	eor w0, w0, w3 // finalised

	str w0, [sp, 36]

	pop2 x2, x3
	pop2 x0, x1
	ret

_hash_3r_b_64b:
/*
	three rounds of 2 different 32b hashes
	that produce a single hashed 64b number
	the principle is:
		- hash 1 hashes lower hw of upper word and upper hw of lower word
		- hash 2 hashes upper hw of lower word and lower hw of upper word
	trashes 6 registers

	int64 -> int64

*/
	ret

HASH_CONSTANTS:
	.word 0xed5ad4bb
	.word 0xac4c1b51
	.word 0x31848bab
	.word 0xaeccedab
	.word 0xac613e37
	.word 0x19c89935