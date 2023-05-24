CROSS_PREFIX=aarch64-none-elf-

all: kernel.elf
	
kernel.o: k_01_boot.s k_02_vtable.s k_03_uart_setup.s k_03a_uart_print_subroutines.s k_04_globals.s k_06a_register_val_macros.s k_06b_stack_macros.s
	$(CROSS_PREFIX)as.exe -g -c k_01_boot.s -o $@

kernel.elf: kernel.o
	$(CROSS_PREFIX)ld.exe -Tkernel.ld $^ -o $@

clean:
	rm -f kernel.elf kernel.o kernel.s
