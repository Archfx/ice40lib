// femtorv32, a minimalistic RISC-V RV32I core
//       Bruno Levy, 2020-2021
//
// This file: driver for LEDs (does nearly nothing !)
//

module LEDDriver(
`ifdef NRV_IO_IRDA
    output wire irda_TXD,
    input  wire irda_RXD,
    output wire irda_SD,		
`endif		  
    input wire 	       clk, // system clock
    input wire 	       rstrb, // read strobe		
    input wire 	       wstrb, // write strobe
    input wire 	       sel, // select (read/write ignored if low)
    input wire [31:0]  wdata, // data to be written
    output wire [31:0] rdata, // read data
    output wire [3:0]  LED    // LED pins
);

// The IceStick has an infrared reveiver/transmitter pair
// See EXAMPLES/test_ir_sensor.c and EXAMPLES/test_ir_remote.c
`ifdef NRV_IO_IRDA
   reg [5:0] led_state;
   assign LED = led_state[3:0];
   assign rdata = (sel ? {25'b0, irda_RXD, led_state} : 32'b0);
   assign irda_SD  = led_state[5];
   assign irda_TXD = led_state[4];
`else   
   reg [3:0] led_state;
   assign LED = led_state;
   
   initial begin
      led_state = 4'b0000;
   end
   
   assign rdata = (sel ? {28'b0, led_state} : 32'b0);
`endif
   
   always @(posedge clk) begin
      if(sel && wstrb) begin
`ifdef NRV_IO_IRDA
	 led_state <= wdata[5:0];
`else
	 led_state <= wdata[3:0];	 
`endif	 
`ifdef BENCH
         $display("****************** LEDs = %b", wdata[3:0]);
`endif	 
      end
   end
endmodule
