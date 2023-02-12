module top_hex_demo
(
    input  wire clki,
    output wire oled_csn,
    output wire oled_clk,
    output wire oled_mosi,
    output wire oled_dc,
    output wire oled_resn
);

    SB_GB clk_gb (
    .USER_SIGNAL_TO_GLOBAL_BUFFER(clki),
    .GLOBAL_BUFFER_OUTPUT(clk_25mhz)
    );
    parameter C_color_bits = 16; 

    localparam BITS = 5;
    localparam LOG2DELAY = 21;

    reg [127:0] counter = 0;
    reg [127:0] R_display; // something to display

    always @(posedge clk_25mhz)
    begin
        counter <= counter + 1;
        R_display <= counter >> LOG2DELAY;
    end

    wire [6:0] x;
    wire [7:0] y;
    wire next_pixel;
    wire [C_color_bits-1:0] color;

    hex_decoder
    #(
        .C_data_len(128),
        .C_font_file("oled_font.mem"),
	.C_color_bits(C_color_bits)
    )
    hex_decoder_inst
    (
        .clk(clk_25mhz),
        .en(1'b1),
        .data(R_display),
        .x(x),
        .y(y),
        .next_pixel(next_pixel),
        .color(color)
    );

    localparam C_init_file = "st7735_init.mem";

    oled_video
    #(
        .C_init_file(C_init_file),
        .C_init_size(110)
    )
    oled_video_inst
    (
        .clk(clk_25mhz),
        .x(x),
        .y(y),
        .next_pixel(next_pixel),
        .color(color),
        .oled_csn(oled_csn),
        .oled_clk(oled_clk),
        .oled_mosi(oled_mosi),
        .oled_dc(oled_dc),
        .oled_resn(oled_resn)
    );

endmodule
