# iCE40lib : FPGA pheripheral Library 

This repository contains various pheripheral drivers written in verilog for open source ICE40 FPGAs.

Content
======

1. blinky : LED blink example 
2. lcd : Driver for PMOD LCD ([based st7735 IP](https://github.com/lawrie/ulx3s_examples))




Build
======

Yosys tool chain is required to build the binary files.
For this you can use the following docker container with all the dependencies

<p align="center">
  <img src="https://dockerico.blankenship.io/image/archfx/yosystools" alt="Sublime's custom image"/>
</p>

<!-- [![dockeri.co](https://dockerico.blankenship.io/image/archfx/yosystools)](https://hub.docker.com/r/archfx/yosystools) -->

Follow the steps to build usign the docker environemt. (You should have the docker deamon installed on your system)

1. Clone the repository

```shell
git clone https://github.com/Archfx/ice40lib
```

2. Pull the docker image from docker-hub


```shell
docker pull archfx/ice40tools
```

3. Set the expected location to mount with the container
```shell
export LOC=/ice40lib
```

4. Run the Docker image
```shell
sudo docker run -t -p 6080:6080 -v "${PWD}/:/$LOC" -w /$LOC --name ice40tools archfx/ice40tools
```
This will open up a browser window with 

5. Connect to the docker image

```shell
sudo docker exec -it ice40tools /bin/bash
```

6. Comlpile the design and upload

Note change the --pl1k parameter with the chip model that you have. iCESugar Nano uses ice40LP1k-CM36 chip

```shell
cd ice40/examples/blinky

yosys -p 'synth_ice40 -top blinky -json blinky.json' blinky.v               # synthesize into blinky.json

nextpnr-ice40 --lp1k --json blinky.json --pcf blinky.pcf --asc blinky.asc --package cm36  # run place and route
icepack blinky.asc blinky.bin                                               # generate binary bitstream file

iceprog blinky.bin                                                       
```



Relevant Docs
=========

IceSugar Nano Schematic :

https://github.com/wuxx/icesugar-nano/blob/main/schematic/ICESugar-nano-v1.2.pdf
