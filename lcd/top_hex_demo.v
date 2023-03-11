module top_hex_demo
(
    input  wire clk,
    output wire oled_cs,
    output wire oled_clk,
    output wire oled_mosi,
    output wire oled_dc,
    output wire reset
);

    
    parameter C_color_bits = 16; 

    localparam BITS = 5;
    localparam LOG2DELAY = 21;

    reg [127:0] counter = 0;
    reg [127:0] R_display; // something to display

    always @(posedge clk)
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
        .clk(clk),
        .en(1'b1),
        .data(R_display),
        .x(x),
        .y(y),
        .next_pixel(next_pixel),
        .color(color)
    );

    

    st7735  driver (
        .clk(clk),
        .x(x),
        .y(y),
        .color(color),
        .next_pixel(next_pixel),
        .oled_cs(oled_cs),
        .oled_clk(oled_clk),
        .oled_mosi(oled_mosi),
        .oled_dc(oled_dc),
        .reset(reset)
    );

endmodule
