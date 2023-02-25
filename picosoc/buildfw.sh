riscv32-unknown-elf-gcc *.c -c -mabi=ilp32 -march=rv32ic -Os --std=c99 -ffreestanding -nostdlib

riscv32-unknown-elf-gcc start.S -c -mabi=ilp32 -march=rv32ic -o start.o

riscv32-unknown-elf-gcc -Os -mabi=ilp32 -march=rv32imc -ffreestanding -nostdlib -o firmware.elf -Wl,--build-id=none,-Bstatic,-T,sections.lds,-Map,firmware.map,--strip-debug start.o firmware.o -lgcc

riscv32-unknown-elf-objcopy -O verilog firmware.elf firmware.hex