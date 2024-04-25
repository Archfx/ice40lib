rm -rf checkered.json checkered.asc check.bin

yosys -p 'synth_ice40 -top top_checkered -json checkered.json' top_checkered.v st7735.v

nextpnr-ice40 --lp1k --json checkered.json --pcf lcd.pcf --asc checkered.asc --package cm36

icepack checkered.asc check.bin