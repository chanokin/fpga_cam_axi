/*
Extracting a 128x128 image from a 320x240 frame

   0      96      224     320
   /----------------------/- - -  0
   /      :       :       /
   /      :_______:_ _ _ _/_ _ _  56
   /      |       |       /
   /      |       |       /
   /      |_______|_ _ _ _/_ _ _  184
   /                      /
   /                      /
   /----------------------/- - -  240
*/
module block_to_pixel_v1(input pclk,
                          input [16:0] qvga_address,
                          input [7:0] row_count,
                          input [8:0] col_count,
                          output reg get_new_block,
                          output reg [9:0] pixel_out,
      // bram interface
                          output reg [31:0] bram_addr,
                          input  [31:0] bram_rddata,
                          output bram_en,
                          output bram_rst,
                          output [3:0] bram_we,
      // block reset
                          input  reset);

parameter MAX_LIFE_COUNT = 60;
parameter DEFAULT_GRAY_LEVEL = 15;
parameter LIFE_ZERO = 6'd0;
parameter LIFE_ONE = 6'd1;

reg [5:0] get_new_block_life; 
reg even_odd_pixel;
reg [3:0] default_gray;
assign bram_rst = reset;
assign bram_we = {reset, reset, reset};
assign bram_en = !reset;

initial begin
    default_gray <= DEFAULT_GRAY_LEVEL;
end


// grab new block signal
always @(posedge pclk or negedge reset) begin

  if (reset == 1'b1) begin
    get_new_block <= 1'b0; 
    get_new_block_life <= LIFE_ZERO;
  end
  else begin
// ask for new info at the beginning of the frame to desynchronize DMA accesses
    if( (col_count == 9'd1 &&  ( row_count == 9'd88  || row_count == 9'd120 || 
                                 row_count == 9'd152 || row_count == 9'd184)   ) || 
        (get_new_block_life > LIFE_ZERO && get_new_block_life < MAX_LIFE_COUNT ) ) begin

      get_new_block <= 1'b1;
      get_new_block_life <= get_new_block_life + LIFE_ONE;
    end
    else begin
      get_new_block <= 1'b0;
      get_new_block_life <= LIFE_ZERO;
    end
  end
  
end


// BRAM address
always @(posedge pclk or negedge reset) begin
  if (reset == 1'b1) begin
    bram_addr <= 31'd0;
  end
  else begin
    if ( get_new_block == 1'b0 || bram_addr >=  32'd2048) begin
      bram_addr <= 32'd0;
    end
    else begin
        if ( col_count >= 9'd96 && col_count <= 9'd224 ) begin
          bram_addr <= bram_addr + 32'd1;
        end
    end
  end
  
end

// even or odd pixel
always @(posedge pclk or negedge reset) begin
  if (reset == 1'b1) begin
    even_odd_pixel <= 1'b0;
  end
  else begin
    even_odd_pixel <= even_odd_pixel + 1'b1;
  end
end

// Pixel decoding
// read & write data register
/*
     -------------------------------------------------------------------
 var |   ref0   | colour0 |  pixel0   |   ref1   | colour0 |  pixel0   |
     -------------------------------------------------------------------
 bit |  31 : 24 |  23:22  |  21 : 16  |  15 : 8  |  7 : 6  |   5 : 0   |
     -------------------------------------------------------------------
*/
always @(posedge pclk or negedge reset) begin
  if (reset == 1'b1) begin
    pixel_out <= 10'd0;
  end
  else begin

    if ( col_count >= 9'd96 && col_count <= 9'd224 
          && row_count >= 9'd56 && row_count <= 8'd184 
         ) begin
      if(even_odd_pixel == 1'b1) begin
        pixel_out <= {bram_rddata[21:16], 2'b0, bram_rddata[23:22]};
      end
      else begin
        pixel_out <= {bram_rddata[5:0], 2'b0, bram_rddata[7:6]};
      end
    end
    else begin
      pixel_out <= {default_gray, 4'd0, 2'd0};
    end
  end
end


endmodule







