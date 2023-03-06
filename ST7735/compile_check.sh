yosys -p 'synth_ice40 -top top -json st7735.json' top.v 

nextpnr-ice40 --lp1k --json st7735.json --pcf lcd.pcf --asc st7735.asc --package cm36

icepack st7735.asc st7735.bin