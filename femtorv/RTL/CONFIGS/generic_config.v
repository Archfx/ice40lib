// Default femtosoc configuration file for IceStick

/************************* Devices **********************************************************************************/

`define NRV_IO_LEDS        // Mapped IO, LEDs D1,D2,D3,D4 (D5 is used to display errors)
//`define NRV_IO_UART        // Mapped IO, virtual UART (USB)
//`define NRV_IO_SSD1351     // Mapped IO, 128x128x64K OLed screen
//`define NRV_IO_MAX7219   // Mapped IO, 8x8 led matrix
//`define NRV_MAPPED_SPI_FLASH // SPI flash mapped in address space. Can be used with MINIRV32 to run code from SPI flash.

/************************* Frequency ********************************************************************************/

`define NRV_FREQ 50      // Frequency in MHz. Recomm: 50 MHz (FOMU: 16MHz) Overclocking: 80-100 MHz (HX1K, ECP5)

/************************* RAM (in bytes, needs to be a multiple of 4)***********************************************/

`define NRV_RAM 6144     // default for ICESTICK (cannot do more !)
//`define NRV_RAM 1024   // small ICESTICK config (to further save LUTs if need be)

/************************* Processor configuration ******************************************************************/

//`define NRV_CSR         // Uncomment if using something below (counters,...)
//`define NRV_COUNTERS    // Uncomment for instr and cycle counters (won't fit on the ICEStick)
//`define NRV_COUNTERS_64 // ... and uncomment this one as well if you want 64-bit counters
`define NRV_TWOSTAGE_SHIFTER // if not RV32M, comment-out if running out of LUTs (at the expense of slower shifts)
//`define NRV_LATCH_ALU // Uncomment to latch all ALU ops (reduces critical path)

/************************* Advanced processor configuration *********************************************************/

`define NRV_RESET_ADDR 0                // The address the processor jumps to on reset 
//`define NRV_RESET_ADDR 32'h00800000  // If using NRV_MINIRV32 and mapped SPI Flash, you may want to jump to
                                        // a bootloader or firmware stored there.

`define NRV_IO_HARDWARE_CONFIG // Comment-out to disable hardware config registers mapped in IO-Space
                               // (only if you use your own firmware, libfemtorv32 depends on it)

/******************************************************************************************************************/

