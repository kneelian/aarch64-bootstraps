	_rng_64_branch: .quad _rng_64_fallback
	 	_rng_64:
	 		psh x0

	 		adr x0, _rng_64_branch
	 		ldr x0, [x0]
	 		br  x0

	 	_rng_64_hardware:
	 		mrs x0, s3_3_c2_c4_0		// rndr
	 		str x0, [sp, 8]
	 		pop x0
	 		ret
	 	_rng_64_fallback:
	 		mov x0, 0
	 		ret