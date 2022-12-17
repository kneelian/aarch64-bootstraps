CROSS_PREFIX=aarch64-none-elf-

all: kernel.elf
	
kernel.o: kernel.s k_macros.s k_procedures.s k_font.s k_macro_status_int.s k_testing_functionality.s k_uart_setup.s k_ramfb_init.s k_noncrypto_hashes.s k_sha-256.s k_parser.s
	$(CROSS_PREFIX)as.exe -g -c kernel.s -o $@

kernel.elf: kernel.o
	$(CROSS_PREFIX)ld.exe -Tkernel.ld $^ -o $@

clean:
	rm -f kernel.elf kernel.o kernel.s
