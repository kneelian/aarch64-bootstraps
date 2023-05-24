clang -target aarch64-none-elf -c k_01_boot.s -o kernel2.o
ld.lld -Tkernel.ld kernel2.o -o kernel2.elf -s --print-map

