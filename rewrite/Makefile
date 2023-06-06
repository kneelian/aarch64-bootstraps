#CROSS_PREFIX=../../xpack-aarch64-none-elf-gcc-12.2.1-1.2/bin/aarch64-none-elf-

ifeq ($(OS),Windows_NT)
	AS = aarch64-none-elf-as.exe
	LD = aarch64-none-elf-ld.exe
else
	AS=../../xpack-aarch64-none-elf-gcc-12.2.1-1.2/bin/aarch64-none-elf-as
	LD=../../xpack-aarch64-none-elf-gcc-12.2.1-1.2/bin/aarch64-none-elf-ld
endif

all: kernel.elf
	
kernel.o: k_01_boot.s k_02_vtable.s k_03_uart_setup.s k_03a_uart_print_subroutines.s k_04_globals.s k_06a_register_val_macros.s k_06b_stack_macros.s k_06c_status_macro.s
	$(AS) -g -c k_01_boot.s -o $@

k_07.o: k_07_ramfb_init.s k_07a_ramfb_procedures.s k_07b_font.s
	$(AS) -g -c  k_07_ramfb_init.s -o $@

kernel.elf: kernel.o k_07.o
	$(LD) -Tkernel.ld $^ -o $@

clean:
	rm -f kernel.elf kernel.o kernel.s