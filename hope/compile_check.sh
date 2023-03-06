yosys -p 'synth_ice40 -top ST7735 -json st7735.json' ST7735_interface.v

nextpnr-ice40 --lp1k --json st7735.json --pcf lcd.pcf --asc st7735.asc --package cm36

icepack st7735.asc st7735.bin