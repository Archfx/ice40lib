module blinky (
    input  clki,
    output led
);

    reg [25:0] counter;

   assign led = ~counter[23];

   initial begin
      counter = 0;
   end

   always @(posedge clki)
   begin
      counter <= counter + 1;
   end
endmodule
