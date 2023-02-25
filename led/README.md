LED IP
======


```shell
yosys -p 'synth_ice40 -top led -json led.json' led.v

nextpnr-ice40 --lp1k --json led.json --pcf led.pcf --asc led.asc --package cm36

icepack led.asc led.bin
```
