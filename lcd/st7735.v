//the state machine will first send the init commands to set up the screen, then it will be
//stuck in the send pixels mode and wait the pixels from the outside to send to the screen one by one


// time delay values calculated correctly. Look at the adafruit library for specific configurations

module st7735(
   input clk, 
   output reg oled_clk, 
   output reg oled_mosi, 
   output reg oled_dc, 
   output reg oled_cs, 
   output reg reset,
   
   output reg  [7:0] x,
   output reg  [6:0] y,
   output reg  next_pixel, // 1 when x/y changes
   input  wire [15:0] color
   
   
   );

   parameter FREQ_MAIN_HZ = 12000000; // Pulse width (1/12)us
   parameter FREQ_TARGET_SPI_HZ = 4000000; // Pulse width (1/3)us = (1/3000)ms // Pulse width (1/2)us = (1/2000)ms
   parameter HALF_UART_PERIOD = (FREQ_MAIN_HZ/FREQ_TARGET_SPI_HZ)/2;

   parameter SCREEN_WIDTH = 161; //x - pixel size displayed on screen
   parameter SCREEN_HEIGHT = 81; //y - pixel size displayed on screen

   // parameter SCREEN_WIDTH = 80; //pixel size displayed on screen
   // parameter SCREEN_HEIGHT = 160; //pixel size displayed on screen

   
   reg [3:0] clk_counter_tx;
   reg [24:0] counter_send_interval; //to wait between the commands
   reg [7:0] counter_current_param;

   reg [4:0] current_byte_pos;
   reg [19:0] current_pixel;

   reg [15:0] buffer_pixel_write;

   reg advertise_pixel_consume;
   reg advertise_pixel_consume_buffer;
   reg [15:0] pixel_display;

   reg [3:0] state;
   parameter STATE_IDLE=0, SEND_CMD=STATE_IDLE+1, CMD_WAIT=SEND_CMD+1, STATE_FRAME_INIT=CMD_WAIT+1,
               STATE_WAITING_PIXEL=STATE_FRAME_INIT+1, STATE_FRAME=STATE_WAITING_PIXEL+1;

   
   reg reg_valid;



   // parameter CMD_SWRESET_DELAY = 300000; //150ms delay (150*2000)
   // parameter CMD_SLPOUT_DELAY = 510000; //255ms delay
   // parameter CMD_NORON_DELAY = 20000; //10ms delay
   // parameter CMD_DISPON_DELAY = 200000; //100ms delay


   reg [23:0] delay_counter;
   reg is_init;

   reg buffer_free;
   wire [15:0] pixel_write;
   reg wr_en;
   reg enable;

   assign pixel_write = color;


   reg [7:0] param_array [34];
   reg [5:0] cmd_selector;
   reg [24:0] wait_time;
   // assign x = current_pixel/SCREEN_WIDTH;
   // assign y = current_pixel%SCREEN_WIDTH;


   initial begin
      clk_counter_tx = 0;

      current_byte_pos = 7;
      // current_pixel = 0;
      x = 0;
      y = 0;
      counter_send_interval = 0;
      counter_current_param = 0;

      oled_clk = 1;
      oled_mosi = 0;
      oled_dc = 0;
      oled_cs = 1;

      // read_reg = 0;
      reg_valid = 0;
      buffer_pixel_write = 16'hffff;

      is_init = 0;
      next_pixel = 0;

      buffer_free = 1;
      // pixel_write_free = 0;

      advertise_pixel_consume = 0;
      advertise_pixel_consume_buffer = 0;
      pixel_display = 0;

      delay_counter = 0;
      enable <= 0;

      state = SEND_CMD;

      reset = 0;
      oled_dc = 0;
      oled_cs = 1;

      // pixel_write = 16'hffff;
      wr_en = 1;

      param_array[0] = 8'h01; //software reset CMD_SWRESET = 8'h01; //software reset
      param_array[1] = 8'h11; //sleep out CMD_SLPOUT = 8'h11; //sleep out
      param_array[2] = 8'hb4; //display inversion control CMD_INVCTR = 8'hb4; //display inversion control
      param_array[3] = 8'h07; //normal mode CMD_PARAM_INVCTR = 8'h07; //normal mode 
      param_array[4] = 8'hC0; // CMD_PWCTR1 = 8'hC0;
      param_array[5] = 8'hA2;//8'h82; CMD_PARAM1_PWCTR1 = 8'hA2;//8'h82;
      param_array[6] = 8'h02;// CMD_PARAM2_PWCTR1 = 8'h02;
      param_array[7] = 8'h84;// CMD_PARAM3_PWCTR1 = 8'h84;
      param_array[8] = 8'hC3; //CMD_PWCTR4 = 8'hC3;
      param_array[9] = 8'h8A; // CMD_PARAM1_PWCTR4 = 8'h8A;
      param_array[10] = 8'h2A;// CMD_PARAM2_PWCTR4 = 8'h2A;//8'h2E;
      param_array[11] = 8'hC4;// CMD_PWCTR5 = 8'hC4;
      param_array[12] = 8'h8A;// CMD_PARAM1_PWCTR5 = 8'h8A;
      param_array[13] = 8'hEE;// CMD_PARAM2_PWCTR5 = 8'hEE;//8'hAA;
      param_array[14] = 8'hC5;// CMD_VMCTR1 = 8'hC5;
      param_array[15] = 8'h0E; // CMD_PARAM_VMCTR1 = 8'h0E; 
      param_array[16] = 8'h21;// CMD_INVON = 8'h21;
      param_array[17] = 8'h36;// CMD_MADCTL = 8'h36;
      param_array[18] = 8'hC8;// CMD_PARAM_MADCTL = 8'hC8;
      param_array[19] = 8'h3A;// CMD_COLMOD = 8'h3A;
      param_array[20] = 8'h05;// CMD_PARAM_COLMOD = 8'h05;

      // // x  Top left corner x coordinate
      // // y  Top left corner x coordinate
      // // w  Width of window
      // // h  Height of window

      param_array[21]  = 8'h2A;// CMD_CASET = 8'h2A;
      // //start and end of column position to draw on the screen
      // //the drawable area is starting at 0 // Rmcd2green160x80 from Adafruit library
      param_array[22] = 8'h00;// CMD_PARAM1_CASET = 8'h00;
      param_array[23] = 8'h1A;// CMD_PARAM2_CASET = 8'h1A;
      param_array[24] = 8'h00;// CMD_PARAM3_CASET = 8'h00;
      param_array[25] = 8'h6A;// CMD_PARAM4_CASET = 8'h6A;
      // //start and end of row position to draw on the screen
      // //the drawable area is starting at 0
      param_array[26] = 8'h2B;// CMD_RASET =  8'h2B;
      param_array[27] = 8'h00;// CMD_PARAM1_RASET = 8'h00;
      param_array[28] = 8'h01;// CMD_PARAM2_RASET = 8'h01;//01;
      param_array[29] = 8'h00;// CMD_PARAM3_RASET = 8'h00;
      param_array[30]  = 8'hA1;// CMD_PARAM4_RASET = 8'hA1;

      param_array[31] = 8'h13;// CMD_NORON = 8'h13;

      param_array[32] = 8'h29;// CMD_DISPON = 8'h29;

      param_array[33]  = 8'h2C;// CMD_RAMWR = 8'h2C;

      cmd_selector = 0;
      wait_time = 0;
   end


   always @(posedge clk) begin // lets do the display reset here

      if(delay_counter < 24'h780000) begin //screen in reset mode
         delay_counter <= delay_counter + 1;
         
         if(delay_counter == 24'h400000) begin
            reset <= 1;
         end
      end else begin
         enable <= 1;
      end

      
   end

   always @(posedge clk)
   begin
      if(enable == 1) begin
         clk_counter_tx <= clk_counter_tx+1;
      end

      //generate clock for the spi
      if(clk_counter_tx == HALF_UART_PERIOD) begin
         clk_counter_tx <= 0;
         oled_clk <= ~oled_clk;
      end

      
      if (is_init) buffer_pixel_write <= pixel_write;
      else buffer_pixel_write <= 16'hffff;

      

      //read pixel, will be consumed by the SPI state machine
      if(wr_en == 1) begin
         buffer_free <= 0;
      end

      // get info that the spi has read the buffer (synchronised)
      advertise_pixel_consume_buffer <= advertise_pixel_consume;

      if(advertise_pixel_consume_buffer != advertise_pixel_consume) begin
         buffer_free <= 1;
      end

   end

   always @(negedge oled_clk)
   begin
      oled_dc <= 0; //set mosi as "command"
      oled_cs <= 1;

      current_byte_pos <= current_byte_pos-1;

      case (state) //send the config data, then the screen data
      SEND_CMD : begin
         oled_mosi <= param_array[cmd_selector][current_byte_pos];
         oled_cs <= 0;
         if(current_byte_pos == 0) begin
            // state <= CMD_WAIT;
            current_byte_pos <= 7;
            counter_send_interval <= 0;

            if(cmd_selector == 0) begin
               state <= CMD_WAIT;
               wait_time <= (FREQ_TARGET_SPI_HZ/12);
               oled_dc <= 0;
               current_byte_pos <= 7;
            end
            else if(cmd_selector == 1) begin
               state <= CMD_WAIT;
               wait_time <= (FREQ_TARGET_SPI_HZ/4);
               oled_dc <= 0;
               current_byte_pos <= 7;
            end
            else if(cmd_selector == 3 || cmd_selector == 5 || cmd_selector == 6 || cmd_selector == 7 || cmd_selector == 9
               || cmd_selector == 10 || cmd_selector == 12 || cmd_selector == 13 || cmd_selector == 15 || cmd_selector == 18
               || cmd_selector == 20 || cmd_selector == 22 || cmd_selector == 23 || cmd_selector == 24 || cmd_selector == 25
               || cmd_selector == 27 || cmd_selector == 28 || cmd_selector == 29 || cmd_selector == 30   ) begin
               
               wait_time <= 0;
               current_byte_pos <= 7;
               if (cmd_selector == 30) begin

                  if(is_init) begin
                     // state <= STATE_SEND_RAMWR;
                     cmd_selector <= 35;
                     state <= SEND_CMD;
                  end
                  else begin
                     cmd_selector <= cmd_selector + 1;
                     state <= SEND_CMD;
                  end
                  
               end
               else begin
                  cmd_selector <= cmd_selector + 1;
                  state <= SEND_CMD;
               end
               oled_dc <= 1; //params are seen as data
            end
            else if(cmd_selector == 31) begin
               state <= CMD_WAIT;
               wait_time <= (FREQ_TARGET_SPI_HZ/200);
               oled_dc <= 0;
               current_byte_pos <= 7;
            end
            else if(cmd_selector == 33) begin
               state <= CMD_WAIT;
               wait_time <= (FREQ_TARGET_SPI_HZ/20);
               oled_dc <= 0;
               current_byte_pos <= 7;
            end
            else if(cmd_selector == 35 ) begin //STATE_SEND_RAMWR
               if (is_init) begin
                  state <= STATE_WAITING_PIXEL;
               end
               else begin
                  state <= STATE_FRAME_INIT;
               end
               current_byte_pos <= 15;
               counter_send_interval <= 0;
               oled_dc <= 0;
            end
            else begin
               cmd_selector <= cmd_selector + 1;
               current_byte_pos <= 7;
               counter_send_interval <= 0;
               counter_current_param <= 0;
               oled_dc <= 0;
            end
         end
      end
      CMD_WAIT : begin
         counter_send_interval <= counter_send_interval + 1;
         if(counter_send_interval == wait_time) begin //wait
               current_byte_pos <= 7;
               state <= SEND_CMD;
               cmd_selector <= cmd_selector + 1;
         end
      end
      
      
      //fill the display with black pixels
      STATE_FRAME_INIT: begin
         oled_cs <= 0;
         if(current_byte_pos == 0) begin
            current_byte_pos <= 15;
            // current_pixel <= current_pixel + 1;

            if (x<SCREEN_WIDTH-1) begin
               if(y == (SCREEN_HEIGHT-1)) begin
                  y = 0;
                  x = x + 1;
               end else begin
                  y = y + 1;
               end               
            end

            if(x == (SCREEN_WIDTH-1)) begin //image finished
               x <= 0;
               y <= 0;
               // state <= STATE_SEND_CMD_CASET; //go back to the CASET param and then draw pixels
               state <= SEND_CMD; 
               cmd_selector <= 23;

               is_init <= 1; //finish the init sequence, advertise to the upper modules    
            end
   
         end
         oled_dc <= 1; //set mosi as "data"
         oled_mosi <= 0; //black
      end

      STATE_WAITING_PIXEL: begin
         oled_cs <= 1;
         next_pixel <= 1;
         // state <= STATE_FRAME;
         // current_byte_pos <= 15;
         if(buffer_free == 0) begin
            state <= STATE_FRAME;
            
            //consume next pixel and advertise the register system
            pixel_display <= buffer_pixel_write;
            advertise_pixel_consume <= ~advertise_pixel_consume;
            current_byte_pos <= 15;
         end
      end
      STATE_FRAME: begin
         oled_cs <= 0;
         next_pixel <= 0;
         if(current_byte_pos == 0) begin
            current_byte_pos <= 15;
            if (x<SCREEN_WIDTH-1) begin
               if(y == (SCREEN_HEIGHT-1)) begin
                  y = 0;
                  x = x + 1;
               end else begin
                  y = y + 1;
               end               
            end

            if(x == (SCREEN_WIDTH-1)) begin //image finished
               x <= 0;
               y <= 0;
               // current_pixel <= 0;
               // state <= STATE_SEND_RAMWR; //send a new frame
               state <= SEND_CMD; 
               cmd_selector <= 35;
               reg_valid <= 1;
            end
            else begin
               state <= STATE_WAITING_PIXEL;
            end
            
         end
         oled_dc <= 1; //set mosi as "data"
         oled_mosi <= pixel_display[current_byte_pos];
      end

      endcase
   end
endmodule
