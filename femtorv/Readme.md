FEMTORV fork for ICESUGAR-NANO FPGA
=======

Build the Firmware
```shell
$ cd FIRMWARE/EXAMPLES
$ make hello.hex
```
This will generate the hex file of the firmware. Next we need to build the hardware with inbuilt firmware. For that follow the below steps.


```shell
$ make ICESUGAR_NANO
```

This will produce the file `femtosoc.bin` at the home folder. You can directly upload this to the FPGA by drag and drop.

Use the terminal to talk with your processor

```shell
brew  install picocom
```

```shell
/opt/homebrew/Cellar/picocom/3.1_1/bin/picocom -b 115200 /dev/tty.usbmodem102  --imap lfcrlf,crcrlf --omap delbs,crlf --send-cmd "ascii-xfr -s -l 30 -n"

/opt/homebrew/Cellar/screen/4.9.0_1/bin/screen /dev/tty.usbmodem102 115200
```