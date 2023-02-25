
CROSS=riscv32-unknown-elf-
CFLAGS=


# ---- iCE40 iCESugar Board ----
icebsim: icesugar_tb.vvp icesugar_fw.hex
	vvp -N $< +firmware=icesugar_fw.hex

icebsynsim: icesugar_syn_tb.vvp icesugar_fw.hex
	vvp -N $< +firmware=icesugar_fw.hex

icesugar.json: icesugar.v ice40lp1k_spram.v spimemio.v simpleuart.v picosoc.v picorv32.v
	yosys -ql icesugar.log -p 'synth_ice40 -top icesugar -json icesugar.json' $^

icesugar_tb.vvp: icesugar_tb.v icesugar.v ice40up5k_spram.v spimemio.v simpleuart.v picosoc.v picorv32.v spiflash.v
	iverilog -s testbench -o $@ $^ `yosys-config --datdir/ice40/cells_sim.v`

icesugar_syn_tb.vvp: icesugar_tb.v icesugar_syn.v spiflash.v
	iverilog -s testbench -o $@ $^ `yosys-config --datdir/ice40/cells_sim.v`

icesugar_syn.v: icesugar.json
	yosys -p 'read_json icesugar.json; write_verilog icesugar_syn.v'

icesugar.asc: icesugar.pcf icesugar.json
	nextpnr-ice40 --freq 13 --lp1k --asc icesugar.asc --pcf icesugar.pcf --json icesugar.json --package cm36 --pcf-allow-unconstrained

icesugar.bin: icesugar.asc
	icetime -d up5k -c 12 -mtr icesugar.rpt icesugar.asc
	icepack icesugar.asc icesugar.bin

ICELINK_DIR=$(shell df | grep iCELink | awk '{print $$6}')
${warning iCELink path: $(ICELINK_DIR)}

icessim: 
	@nextpnr-ice40 --freq 13 --up5k --pcf icesugar.pcf --json icesugar.json --package sg48 --gui


icesprog: icesugar.bin icesugar_fw.bin
	@echo  "icesprog"
	icesprog icesugar.bin
	icesprog -o 0x100000 icesugar_fw.bin
	@#truncate -s 1048576 icesugar.bin
	@#@cat icesugar.bin icesugar_fw.bin > icesugar_spiflash.bin
	@#if [ -d '$(ICELINK_DIR)' ]; \
        #then \
            #cp icesugar.bin $(ICELINK_DIR); \
        #else \
            #echo "iCELink not found"; \
            #exit 1; \
    #fi

image:
	truncate -s 1048576 icesugar.bin
	cat icesugar.bin icesugar_fw.bin > picorv32.bin

icesugar_sections.lds: sections.lds
	$(CROSS)cpp -P -DICEBREAKER -o $@ $^

icesugar_fw.elf: icesugar_sections.lds start.s firmware.c
	$(CROSS)gcc $(CFLAGS) -DICEBREAKER -march=rv32ic -Wl,-Bstatic,-T,icesugar_sections.lds,--strip-debug -ffreestanding -nostdlib -o icesugar_fw.elf start.s firmware.c

icesugar_fw.hex: icesugar_fw.elf
	$(CROSS)objcopy -O verilog icesugar_fw.elf icesugar_fw.hex

icesugar_fw.bin: icesugar_fw.elf
	$(CROSS)objcopy -O binary icesugar_fw.elf icesugar_fw.bin

# ---- Testbench for SPI Flash Model ----

spiflash_tb: spiflash_tb.vvp firmware.hex
	vvp -N $<

spiflash_tb.vvp: spiflash.v spiflash_tb.v
	iverilog -s testbench -o $@ $^

# ---- ASIC Synthesis Tests ----

cmos.log: spimemio.v simpleuart.v picosoc.v ../picorv32.v
	yosys -l cmos.log -p 'synth -top picosoc; abc -g cmos2; opt -fast; stat' $^

# ---- Clean ----

clean:
	rm -f testbench.vvp testbench.vcd spiflash_tb.vvp spiflash_tb.vcd
	rm -f hx8kdemo_fw.elf hx8kdemo_fw.hex hx8kdemo_fw.bin cmos.log
	rm -f icebreaker_fw.elf icebreaker_fw.hex icebreaker_fw.bin
	rm -f hx8kdemo.blif hx8kdemo.log hx8kdemo.asc hx8kdemo.rpt hx8kdemo.bin
	rm -f hx8kdemo_syn.v hx8kdemo_syn_tb.vvp hx8kdemo_tb.vvp
	rm -f icebreaker.json icebreaker.log icebreaker.asc icebreaker.rpt icebreaker.bin
	rm -f icebreaker_syn.v icebreaker_syn_tb.vvp icebreaker_tb.vvp

.PHONY: spiflash_tb clean
.PHONY: hx8kprog hx8kprog_fw hx8ksim hx8ksynsim
.PHONY: icebprog icebprog_fw icebsim icebsynsim
