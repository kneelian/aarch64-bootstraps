CROSS_PREFIX=aarch64-none-elf-

all: kernel.elf
	
kernel.o: kernel.s k_macros.s k_procedures.s k_font.s
	$(CROSS_PREFIX)as.exe -g -c kernel.s -o $@

kernel.elf: kernel.o
	$(CROSS_PREFIX)ld.exe -Tkernel.ld $^ -o $@

clean:
	rm -f kernel.elf kernel.o kernel.s
