module top_checkered (
    input  wire clk,
    output wire oled_cs,
    output wire oled_clk,
    output wire oled_mosi,
    output wire oled_dc,
    output wire reset
);
    //                  checkered      red   green      blue     red       green blue
    wire [15:0] pattern1 = x[3] ^ y[2] ? {5'd0, 6'b111111, 5'd0} : {5'd0, 6'd0, 5'b11111};

    // wire [15:0] pattern1 = (y>7'd40) ? {5'd0, 6'b111111, 5'd0} : {5'd0, 6'd0, 5'b11111};
    wire [15:0] pattern2 = (x>8'd80) ? {5'd0, 6'b111111, 5'd0} : {5'b11111, 6'd0, 5'd0};
    // wire [15:0] pattern3 = x[3] ^ y[2] ? {5'd0, 6'b111111, 5'd0} : {5'b11111, 6'd0, 5'd0};
    // wire [15:0] pattern4 = x[3] ? {5'd0, 6'b111111, 5'd0} : {5'b11111, 6'd0, 5'd0};

    wire [15:0] color = (switch<24'h5B8D80) ? pattern1 : pattern2;

    reg [23:0] switch;

    initial begin
        switch = 0;
    end

    always @(posedge clk) begin
        switch= switch + 1 ;
        
    end


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
