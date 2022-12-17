/*
	Here we have the start of a parser
	for a programming/scripting language
	for the kernel. Think of this as a
	proof of concept program rather than
	anything production-ready (for various
	definitions of production you can
	subject a toy bootloader and kernel to)

	Fairly simple operation scheme. The 
	kernel jumps into this and relinquishes
	control. For all intents and purposes
	the interpreter IS the system
	software in a way reminiscent of old
	BASIC or FORTH systems providing a
	simple software stack and the toold
	to build software upon that system.

	The general idea is to build the 
	language to be as simple as possible
	to parse and evaluate, while still
	being useful enough to work in.
	Laziness necessitated some really
	really strange design choices, so
	let's first get those out of the
	way here:

		- the source code is UCS-2-encoded
		stream of CJK characters from the
		BMP
		- each instruction, keyword or
		command must fit inside two 
		bytes AKA one character each
		- variable names must also fit 
		inside exactly two bytes AKA
		one character each again
		- when it comes to integer
		constants, i really don't know
		what to do other than put
		yijing hexagrams as a 
		sort of base 64 encoding
		scheme (but this makes it
		variable width). i don't want
		to do things like use hangul
		or other hanzi for encoding
		numerals more compactly mostly
		because that'd make the source
		completely illegible and opaque

	The interpreter is really just
	a fancy trawler of bytecode: it
	consumes about one character at
	a time (two bytes), and interprets
	it: there is no tokenisation step,
	input is immediately decoded as
	soon as it's consumed and the decoder
	controls whether the consumer will
	get another character or carry on.

	There is no structural whitespace
	and all whitespace tokens are skipped
	when encountered, as are all unknowns.
	Error checking is obviously done
	only at runtimeas the code is not 
	trawled through beforehand.

	I'll have to design the input system
	pretty carefully, since I want not
	only for the code to be configurable
	before runtime, but also for the user
	to be able to *input* code into the
	interpreter, store and run it.
	Basically I wanna set up a primitive
	REPL loop which'll allow the user
	to input CJK into the thing and then
	get it running interactively.

	This sounds like a lot of goals so
	best get started huh.
*/

/*
	Kotodama interpreter.
	a simple scripting language for
	the ennkernel

	Entry point into the interpreter.
	Takes zero arguments, returns zero.
	Preserves initial state upon entry
*/

_kotodama_e:
	psh2 x0, x1
	psh2 x2, x3
	psh2 x4, x5
	psh2 x6, x7
	psh2 x8, x9
	psh2 x10, x11
	psh2 x12, x13
	psh2 x14, x15
	psh2 x16, x17
	psh2 x18, x19
	psh2 x20, x21
	psh2 x22, x23
	psh2 x24, x25
	psh2 x26, x27
	psh2 x28, x29
	psh2 x30, sp

	ldr x0, =heap_bottom
	mov x1, 1
	lsl x1, x1, 16
	add x0, x0, x1 // lift x0 by 64kb off bottom
	mov x2, x0     // this means 64kb of stack space

	add x1, x1, x0 /* and another 64 bits for programs
		which gives us 32767 characters of program, probs
		more than I'll ever write for this thing. If I do
		end up needing more, I'll just repeat this insn lol*/

	/*
		x0 stores the instruction pointer / IP
		x1 stores the heap pointer / HP
		x2 stores the stack pointer / SP
		x3 is the fetch destination
		x4 holds candidates in the decoder

		registers x6--x28 are volatile and can be used for
		whatever purposes subroutines need.

		the interpreter accesses its own data stack via the x2
		register, and otherwise uses the regular SP for
		functionality and calling kernel subroutines and the
		graphics drivers and probs storage down the line.
	
		each iteration of the loop starts by 
		- loading a halfword at x0 into x3
		- jumping to the decoder
		- decoding and performing the op
		- returning 
	*/
    
    _kt_mainloop:
    	ldrh	w3, [x0], 2
    	bl      _kt_decoder
    	//b 		_kt_mainloop

	pop2 x30, sp
	pop2 x28, x29
	pop2 x26, x27
	pop2 x24, x25
	pop2 x22, x23
	pop2 x20, x21
	pop2 x18, x19
	pop2 x16, x17
	pop2 x14, x15
	pop2 x12, x13
	pop2 x10, x11
	pop2 x8, x9
	pop2 x6, x7
	pop2 x4, x5
	pop2 x2, x3
	pop2 x0, x1
ret

/*
	Instruction decoder.
	Infinitely extendable.

	Instruction arrives to decoder
	via x3, so most of the logic
	happens either directly in here or
	in a subroutine called from here 
*/

_kt_decoder:
	cbz x3, _kt_decoder_end

	mov x4, 0x0009
	cmp x3, x4
	b.eq _kt_decoder_end

	add x4, x4, 1
	cmp x3, x4
	b.eq _kt_decoder_end

	add x4, x4, 3
	cmp x3, x4
	b.eq _kt_decoder_end

	add x4, x4, 0x13
	cmp x3, x4
	b.eq _kt_decoder_end

	mov 	x4, 0x200a		// the whole range between
	cmp 	x3, x4 			// 2000--200a inclusive are
	b.gt 	_kt_dc_sk1 		// all whitespace characters
	sub 	x4, x4, 0xa 	// and they're getting skipped
	cmp  	x3, x4 			// collectively instead of one by
	b.ge 	_kt_decoder_end // one in a per character check
	_kt_dc_sk1:

	mov x4, 0x3000 // cjk fullwidth space
	cmp x3, x4
	b.eq _kt_decoder_end

	/*
		actual character literals start
		here. they're not ordered according
		to any special principle, they're just
		a fat ass block. characters that are
		close to eachother in codepoints
		may get lumped together but this serves
		no optimisation purpose (the mov insn
		allows 16 bit immediates in aarch64).
	*/

	mov x4, 0x8a18 // 記 record, remember.
	cmp x3, x4
	// b.eq 
_kt_decoder_end:
	ret