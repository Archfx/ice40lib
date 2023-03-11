module top_checkered (
    input  wire clk,
    output wire oled_cs,
    output wire oled_clk,
    output wire oled_mosi,
    output wire oled_dc,
    output wire reset
);
    //                  checkered      red   green      blue     red       green blue
    // wire [15:0] color = x[3] ^ y[3] ? 16'h5555: 16'hffff;//{5'd0, 6'b111111, 5'd0} : {5'b11111, 6'd0, 5'd0};
    wire [7:0] x;
    wire [6:0] y;

    reg [15:0] color;

    reg [23:0] colcount;

    initial begin
        colcount = 0 ; 
    end

    

    always @(posedge clk) begin

        color = 16'hffff; 

        colcount = colcount + 1;

        // if colcount > 24'hffffffff begin
        //     color = 16'h5555;
        // end else begin
        //     color = 16'hffff; 
        // end
 
    end

    st7735  driver (
        .clk(clk),
        .x(x),
        .y(y),
        .color(color),
        .oled_cs(oled_cs),
        .oled_clk(oled_clk),
        .oled_mosi(oled_mosi),
        .oled_dc(oled_dc),
        .reset(reset)
    );

endmodule
