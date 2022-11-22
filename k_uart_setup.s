		adrp x0, UART_BASE
		add  x0, x0, :lo12:UART_BASE
		ldr  w0, [x0]
		
		add  x0, x0, 0x30		// UART_CNTL

		mov x1,		0x1
		str x1,		[x0]		// set bit 0 = enable
		mov x1,		0x101
		str x1,		[x0]

		add x0,	x0,	0x4		// UART_FIFO 
		mov x1,		0x03ff
		str x1,		[x0]		// disable FIFO interrupts

		add x0,	x0,	0x10		// UART_INTC
		str xzr, 	[x0]		// clear all interrupts

		isb