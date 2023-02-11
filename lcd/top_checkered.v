module top_checkered (
    input  wire clki,
    output wire oled_csn,
    output wire oled_clk,
    output wire oled_mosi,
    output wire oled_dc,
    output wire oled_resn
);
    //                  checkered      red   green      blue     red       green blue
    wire [15:0] color = x[3] ^ y[3] ? {5'd0, 6'b111111, 5'd0} : {5'b11111, 6'd0, 5'd0};
    wire [6:0] x;
    wire [7:0] y;

    SB_GB clk_gb (
    .USER_SIGNAL_TO_GLOBAL_BUFFER(clki),
    .GLOBAL_BUFFER_OUTPUT(clk_25mhz)
    );
    
    oled_video #(
        .C_init_file("st7735_init.mem"),
        .C_init_size(110)
    ) oled_video_inst (
        .clk(clk_25mhz),
        .x(x),
        .y(y),
        .color(color),
        .oled_csn(oled_csn),
        .oled_clk(oled_clk),
        .oled_mosi(oled_mosi),
        .oled_dc(oled_dc),
        .oled_resn(oled_resn)
    );

endmodule
