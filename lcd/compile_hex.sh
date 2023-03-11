yosys -p 'synth_ice40 -top top_hex_demo -json hex.json' top_hex_demo.v st7735.v hex_decoder.v

nextpnr-ice40 --lp1k --json hex.json --pcf lcd.pcf --asc hex.asc --package cm36

icepack hex.asc hex.bin