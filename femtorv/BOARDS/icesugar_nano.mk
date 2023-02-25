YOSYS_ICESUGAR_NANO_OPT=-DICE_SUGAR_NANO -q -p "synth_ice40 -relut -top $(PROJECTNAME) -json $(PROJECTNAME).json"
NEXTPNR_ICESUGAR_NANO_OPT=--force --json $(PROJECTNAME).json --pcf BOARDS/icesugar_nano.pcf --asc $(PROJECTNAME).asc \
                       --freq 12 --lp1k --package cm36

#######################################################################################################################

ICESUGAR_NANO:  ICESUGAR_NANO.synth #ICESUGAR_NANO.firmware_config

ICESUGAR_NANO.synth: FIRMWARE/firmware.hex 
	TOOLS/make_config.sh -DICE_SUGAR_NANO
	yosys $(YOSYS_ICESUGAR_NANO_OPT) $(VERILOGS)
	nextpnr-ice40 $(NEXTPNR_ICESUGAR_NANO_OPT)
	icetime -p BOARDS/icesugar_nano.pcf -P cm36 -r $(PROJECTNAME).timings -d lp1k -t $(PROJECTNAME).asc
	icepack -s $(PROJECTNAME).asc $(PROJECTNAME).bin

ICESUGAR_NANO.show: FIRMWARE/firmware.hex 
	yosys $(YOSYS_ICESUGAR_NANO_OPT) $(VERILOGS)
	nextpnr-ice40 $(NEXTPNR_ICESUGAR_NANO_OPT) 

#ICESUGAR_NANO.prog:
#	icesprog $(PROJECTNAME).bin

ICESUGAR_NANO.firmware_config:
	BOARD=icesugar_nano TOOLS/make_config.sh -DICE_SUGAR_NANO
	(cd FIRMWARE; make libs)
