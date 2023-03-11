module top_checkered (
    input  wire clk,
    output wire oled_cs,
    output wire oled_clk,
    output wire oled_mosi,
    output wire oled_dc,
    output wire reset
);
    //                  checkered      red   green      blue     red       green blue
    wire [15:0] color = x[3] ^ y[3] ? {5'd0, 6'b111111, 5'd0} : {5'b11111, 6'd0, 5'd0};
    // wire [15:0] color = x[3] ? {5'd0, 6'b111111, 5'd0} : {5'b11111, 6'd0, 5'd0};

    wire [7:0] x;
    wire [6:0] y;


    st7735  driver (
        .clk(clk),
        .x(x),
        .y(y),
        .color(color),
        // .next_pixel(next_pixel),
        .oled_cs(oled_cs),
        .oled_clk(oled_clk),
        .oled_mosi(oled_mosi),
        .oled_dc(oled_dc),
        .reset(reset)
    );

endmodule
