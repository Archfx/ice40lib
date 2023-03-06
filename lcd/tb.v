

module tb;
reg clki;

always #5 clki = (clki === 1'b0);

initial begin
    $dumpfile("testbench.vcd");
    $dumpvars(0, tb);

    repeat (6) begin
        repeat (5000) @(posedge clki);
        $display("+50000 cycles");
    end
    $finish;
end

wire oled_csn;
wire oled_resn;
wire oled_dc;
wire oled_mosi;
wire oled_clk;
wire led_out;

top_checkered dut (.clki(clki),
    .oled_csn(oled_csn),
    .oled_clk(oled_clk),
    .oled_mosi(oled_mosi),
    .oled_dc(oled_dc),
    .oled_resn(oled_resn),
    .led(led)
);

endmodule