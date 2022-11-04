		ret

		_uputs_loop1:
			add x14, x14, 1

			cbz  x1, _uputs_loop1_end
			add  x2, x1, xzr
			cbz  x2, _uputs_loop1_end
			and  x2, x2, 0xff
			cbz  x2, _uputs_loop1_end
			str  x2, [sp, -8]!

			bl   _uputc

			lsr  x1, x1, 8
			cbnz x1, _uputs_loop1

			add  x0, x0, 8
			ldr  x1, [x0]
			mov  x12, x1
			cbz  x2, _uputs_loop1_end
			cbz  x1, _uputs_loop1_end
			b    _uputs_loop1

		_uputs_loop1_end:
		ldp x0, x1,  [sp], 16
		ldp x2, x30, [sp], 16
		add sp, sp, 8

		ret  

		// if x1 is not x2, then DMA is not enabled and we skip right 
		             //       past the end of the framebuffer configuration code

		// if we're in this code path this means that the DMA is enabled
		// and that we can set up the framebuffer now.
		// remember, everything is big endian, so we must do endianness
		// changes if we want to write anything to the cfg

		// the way the DMA interface works is that you set up a chunk
		// of your own memory where you write 32 bits of control,
		//                                    32 bits of length,
		//                                    64 bits of address
		// per operation you want to perform. The operations are
		// stored in the lower nibble of the control in this way:
		//   0x1  error
		//   0x2  read
		//   0x4  skip
		//   0x8  select (from the upper 16 bits)
		//   0x10 write 

		// the read op reads LENGTH bytes from the current selector
		// and offset into ADDRESS provided
		// the write op writes LENGTH bytes from the address into
		// the selected item and drops excess bytes, and set bit
		// zero in the control field (also set when writing to read
		// only items) but we dont care about the errors really

		// if all bits are clear then the op completed successfully
		// if the error bit is set then you fucked up

		// the DMA interface accepts only big-endian input, and must be
		// written to with a 64-bit write or 2x32-bit writes in this way.

		// to set up the ramfb, we need to read/write to the DMA to find the
		// ramfb file, then write a config to it via the interface above

		sub x0, x0, 8 // = 0x09020000
		ldr x1, =ramfb_config // bottom sixteen bytes of config
		sub x1, x1, 16

		movz w2, 0x19
		lsl  w2, w2, 16
		add  w2, w2, 0xa // 0019 000a = select and read  <<< PROBABLE BUG WIP
		rev  w2, w2
		str  w2, [x1], #4

		mov  w2, 4
		str  w2, [x1], #4
		mov  x2, x1
		add  x2, x2, 8
		str  x2, [x1], #8

		mov  w2, w1
		rev  w2, w2
		str  x2, [x0] // we want how many items are in the file dir

		// each file has 32 bits of size
		//               16 bits of selection number
		//               16 bits reserved padding
		//           and 56 bytes of ascii-zero-string name

		// to find the file we need to trawl the tree
		// and check filenames one by one
		// the filename we're looking for is "etc/ramfb\0", but
		// we can cheat and check only the first 8 bytes since
		// the name is 10 bytes and it won't fit a single whole register

		// find the cfg file

		ldr x3, [x1]
		rev x3, x3
		mov x4, x3 

		// x3 now holds the number of items in the cfg
		// x4 holds a copy, which we will loop with

		ldr x5, =0x6574632f72616d66
		rev x5, x5 // the comparison string big-endian

		sub  x1, x1, 16
		movz w2, 0x2 // read
		str  w2, [x1], #4
		mov  w2, 64
		str  w2, [x1], #4
		mov  x2, x1
		add  x2, x2, 8
		str  x2, [x1], #8
		mov  x2, x1
		rev  x2, x2 
		
		add x6, x1, 8 // skip the first 64 bits

		add x17, x17, 1

		mov x19, x4 /// ------------------- IT DOESNT LOAD THE NUMBER OF ITEMS?

		cfg_seek_loop:
			str  x2, [x0]  // poll for read
			sub  x4, x4, 1 // decrease loop cntr

			ldr x7, [x6]
			cmp x7, x5   // is it "etc/ramf" ? 
			beq cfg_seek_loop_end // found it!

			add x17, x17, 1 

			//
			//		THERES A BUG IN HERE SOMEWHERE
			//		ITS STUCK IN AN INFINITE LOOP
			//		TO-DO: FIX TOMORROW
			//

			cbnz x4, cfg_seek_loop // loop still going

			b . // not found, abort
		cfg_seek_loop_end:

		// now we know we found it, let's see which number it is

		ldr x4, [x1]
		rev x4, x4
		lsr x4, x4, 16

		// the lower 16 bits in the reversed reg are the selector number
		// this is what we should write our ramfb config to

		sub  x1, x1, 16
		movz w2, 0x10 // write
		str  w2, [x1], #4
		mov  w2, 64
		str  w2, [x1], #4
		mov  x2, x1
		add  x2, x2, 8
		str  x2, [x1], #8
		mov  x2, x1
		rev  x2, x2

		// TODO: change the bottom to the ramcfg format

		ldr x5,  =ramfb_config // where to write the config
		ldr x6,  =ramfb_bottom // we'll write this address to the cfg
		rev x6,  x6
		ldr x7,  =0x58523234
		rev w7,  w7
		mov x8,  0
		mov x9,  1024
		mov x10, 768
		mul x11, x9,  x10
		lsl x11, x10, 2

		rev x9,  x9
		rev x10, x10
		rev x11, x11
	
		str x6,  [x5], #8
		str x7,  [x5], #4
		str x8,  [x5], #4
		str x9,  [x5], #4
		str x10, [x5], #4
		str x11, [x5], #4

		str x2,  [x0]

		// if all went well, we should get a finished set-up


		//mov x6, xzr
		//ldr x6, =0x58523234 // 'XR24' in bytes