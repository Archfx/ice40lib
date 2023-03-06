`include "ST7735_interface.v"

module tb;

reg clk;
wire spi_cs;
wire reset;
wire spi_dc;
wire spi_mosi;
wire spi_clk;
wire led_out;

always #5 clk = (clk === 1'b0);

ST7735 dut(.spi_cs(spi_cs), .reset(reset), .spi_dc(spi_dc), .spi_mosi(spi_mosi),  .spi_clk(spi_clk), .clk(clk));

initial begin
    $dumpfile("st7735.vcd");
    $dumpvars(0, tb);

    repeat (6) begin
        repeat (5000) @(posedge spi_clk);
        $display("+50000 cycles");
    end
    $finish;
end

endmodule