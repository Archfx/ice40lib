#rm -f *.o *.elf *.hex *.rawhex *.exe *~ *.a *.bin *.bm_elf *.bm_rawhex

#(cd /ice40lib/femtorv/FIRMWARE//..; make get_RAM_size)

#cd ../RTL; iverilog -IPROCESSOR -IDEVICES get_RAM_size.v -o get_RAM_size.vvp; vvp get_RAM_size.vvp > RAM_size.v; rm -f get_RAM_size.vvp


 #TOOLCHAIN/riscv64-unknown-elf-gcc-8.3.0-2020.04.0-x86_64-linux-ubuntu14/bin/riscv64-unknown-elf-gcc -Os -I LIBFEMTORV32 -I LIBFEMTOC -fno-pic -march=rv32i -mabi=ilp32 -fno-stack-protector -w -Wl,--no-relax  -c EXAMPLES/hello.c


TOOLCHAIN/riscv64-unknown-elf-gcc-8.3.0-2020.04.0-x86_64-linux-ubuntu14/bin/riscv64-unknown-elf-ld -m elf32lriscv -b elf32-littleriscv --no-relax -T CRT_BAREMETAL/femtorv32.ld hello.o -o hello.bm_elf -L CRT_BAREMETAL -L LIBFEMTORV32 -L LIBFEMTOC -lfemtorv32 -lfemtoc TOOLCHAIN/riscv64-unknown-elf-gcc-8.3.0-2020.04.0-x86_64-linux-ubuntu14/riscv64-unknown-elf/lib/rv32i/ilp32/libc.a TOOLCHAIN/riscv64-unknown-elf-gcc-8.3.0-2020.04.0-x86_64-linux-ubuntu14/riscv64-unknown-elf/lib/rv32i/ilp32/libm.a TOOLCHAIN/riscv64-unknown-elf-gcc-8.3.0-2020.04.0-x86_64-linux-ubuntu14/lib/gcc/riscv64-unknown-elf/8.3.0/rv32i/ilp32/libgcc.a TOOLS/firmware_words hello.bm_elf -verilog ../RTL/RAM_size.v -hex hello.hex

#from LIBFEMTOGL
../TOOLCHAIN/xpack-riscv-none-embed-gcc-10.1.0-1.1-linux-arm64/bin/riscv-none-embed-gcc 0s  -I ../LIBFEMTOGL -I ../LIBFEMTORV32 -I ../LIBFEMTOC  -fno-pic -march=rv32i -mabi=ilp32 -fno-stack-protector -w -Wl,--no-relax   -c femtoGL.c