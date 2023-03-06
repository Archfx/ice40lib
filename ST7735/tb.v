`include "top.v"

module tb;
reg clk_24mhz;

always #5 clk_24mhz = (clk_24mhz === 1'b0);

initial begin
    $dumpfile("testbench.vcd");
    $dumpvars(0, tb);

    repeat (6) begin
        repeat (5000) @(posedge clk_24mhz);
        $display("+50000 cycles");
    end
    $finish;
end

wire SCE;
wire RST;
wire D_C;
wire MOSI;
wire SCLK;
wire led_out;

top dut(.SCE(SCE), .RST(RST), .D_C(D_C), .MOSI(MOSI),  .SCLK(SCLK), .led_out(led_out), .clk_24mhz(clk_24mhz));

endmodule