yosys -p 'synth_ice40 -top top_checkered -json checkered.json' top_checkered.v oled_video.v

nextpnr-ice40 --lp1k --json checkered.json --pcf lcd.pcf --asc checkered.asc --package cm36

icepack checkered.asc check.bin