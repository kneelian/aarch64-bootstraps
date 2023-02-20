SIMPLE_FONT_8x8:
	.dword 0x0000000000000000 // ZERO
	.dword 0x183c66667e666600 // A
	.dword 0x00fc66667c6666fc // B
	.dword 0x003c66c0c0c0663c // C
	.dword 0x00f86c6666666cf8 // D

SIMPLE_FONT_8x16:
	.dword 0x000010386cc6c6fe, 0xc6c6c6c600000000 // IBM A
	.dword 0x0000000018242442, 0x427E424242420000 // UNIFONT A

/*
	general word of notice
	16x16 fonts are rendered in the opposite order of how they're listed
	quarters are rendered 4>3>2>1
*/

SIMPLE_FONT_16x16:
	.dword 0x0C0E0C0C0C0C3F00, 0x1E33301C06333F00, 0x1E33301C30331E00, 0x383C36337F307800 // hex 8x8 glyphs for digits 1 2 3 4
	.dword 0x00000303033f3333, 0x0000000000f03030, 0x333f030303000000, 0x30f0000000000000 // hand drawn 中
	.dword 0x0000010001000100, 0x3FF8210821082108, 0x21083FF821080100, 0x0100010001000000 // unifont kanji for middle 中

.skip 1024

LINES_ARRAY:

.skip 4096

.align 8