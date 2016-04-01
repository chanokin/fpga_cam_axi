/**********************************************************************

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
   
   
We read and compare with a reference, one line at a time.
Lines are transfered through a buffer, thus the BRAM controller
Lines are requested with a pulse through read_new_line
A write line request is indicated with a pulse on write_new_line

**********************************************************************/

module dvs_cdma_v3(
// camera input
                    input  pclk,
                    input  vsync,
                    input  href,
                    input  [7:0] pix_data,
                    input  write_enable_in,
// threshold value
                    input  [7:0] threshold,
// signal the PS a new frame has just started (reset PS address/change buffer)
                    output reg new_frame, 
// signal the PS to transfer new block contents TO DDR and read BACK next block ->
                    output reg write_new_line,
// bram interface
                    output reg [31:0] bram_addr,
                    output bram_clk,
                    output reg [31:0] bram_wrdata,
                    input  [31:0] bram_rddata,
                    output bram_en,
                    output bram_rst,
                    output [3:0] bram_we,
// block reset
                    input  reset
                  );

//parameter LIFE_VARS_WIDTH = 4;
//parameter LIFE_VARS_FROM = 3;
parameter MAX_LIFE_COUNT = 2;
parameter LIFE_ZERO = 6'd0;
parameter LIFE_ONE = 6'd1;

reg [1:0] block_counter;
reg write_enable_out;
reg [8:0] col_counter;
reg [7:0] row_counter;
reg pix_per_pack_count;
reg [5:0] write_new_line_life; 
reg [5:0] new_frame_life;

//assign new_frame = vsync;
assign bram_we  = {write_enable_out, write_enable_out, write_enable_out};
assign bram_rst = reset;
assign bram_en  = !reset;
assign bram_clk = pclk;

always @(negedge pclk or negedge reset) begin
  if (reset == 1'b1) begin
    new_frame <= 1'b0;
    new_frame_life <= LIFE_ZERO;
  end
  else begin
      if(vsync == 1'b1 || 
        (new_frame_life > LIFE_ZERO && new_frame_life < MAX_LIFE_COUNT)) begin
        
        new_frame <= 1'b1;
        new_frame_life <= new_frame_life + LIFE_ONE;
      end
      else begin
        new_frame <= 1'b0;
        new_frame_life <= LIFE_ZERO;
      end
  end
end


always @(posedge pclk or negedge reset) begin
  if (reset == 1) begin
    block_counter <= 0;
  end
  else begin
    if( bram_addr == 32'd2048) begin
        block_counter <= block_counter + 1;
    end
  end
end


// write results flag
always @(posedge pclk or negedge reset) begin
  if (reset == 1'b1) begin
    write_new_line <= 1'b0; 
    write_new_line_life <= LIFE_ZERO;
  end
  else begin
    if( (col_counter == 9'd225 &&  ( row_counter == 9'd88  || row_counter == 9'd120 || 
                                        row_counter == 9'd152 || row_counter == 9'd184   ) ) || 
        (write_new_line_life > LIFE_ZERO && write_new_line_life < MAX_LIFE_COUNT ) ) begin
      write_new_line <= 1'b1;
      write_new_line_life <= write_new_line_life + LIFE_ONE;
    end
    else begin
      write_new_line <= 1'b0;
      write_new_line_life <= LIFE_ZERO;
    end
  end
  
end

// count lines
always @(negedge pclk or negedge reset) begin
  if(reset == 1'b1) begin
    row_counter <= 8'd0;
  end
  else begin
    if (vsync == 1'b1) begin
      row_counter <= 8'd0;
    end
    else begin
      if (col_counter == 9'd318 && write_enable_in == 1'b1) begin
        row_counter <= row_counter + 8'd1;
      end
    end
  end
end


// count columns 
always @(negedge pclk or negedge reset) begin

  if(reset == 1'b1) begin
    col_counter <= 9'd0;
  end
  else begin
    if ( vsync == 1'b1 || (col_counter == 9'd319 && write_enable_in == 1'b1) ) begin
      col_counter <= 9'd0;
    end
    else begin
        if ( write_enable_in == 1'b1) begin
            col_counter <= col_counter + 9'd1;
        end
    end
  end
  
end

// received pixels count
always @(posedge pclk or negedge reset) begin

  if(reset == 1'b1) begin
    pix_per_pack_count <= 1'b0;
  end
  else begin
    if (href == 1'b1) begin
      if (col_counter > 9'd0 && write_enable_in == 1'b1) begin
            pix_per_pack_count <= pix_per_pack_count + 1'b1;
      end
    end
    else begin
      pix_per_pack_count <= 1'b0;
    end
  end
  
end


/* ************************************************************ 
   
   BLOCK RAM CONTROL
      output reg [16:0] bram_addr,
      output bram_clk,               <- wire
      output reg [31:0] bram_wrdata,
      input  [31:0] bram_rddata,
      output bram_en,                <- wire
      output bram_rst,               <- wire
      output [3:0] bram_we,
      
   ************************************************************ */

// bram address
always @(negedge pclk or negedge reset) begin
  if ( reset == 1'b1 ) begin
    bram_addr <= 32'd0;
  end
  else begin
    if ( write_new_line == 1'b1 ||  bram_addr >=  32'd2048) begin
        bram_addr <= 32'd0;
    end
    else begin
      if ( write_enable_in == 1'b1 && pix_per_pack_count == 1'b0 &&
           col_counter > 9'd96 && col_counter <= 9'd224) begin
             
          bram_addr <= bram_addr + 32'd1;
      end
    end  

    
  end
end

// read & write data register
/*
     -------------------------------------------------------------------
 var |   ref0   | colour0 |  pixel0   |   ref1   | colour0 |  pixel0   |
     -------------------------------------------------------------------
 bit |  31 : 24 |  23:22  |  21 : 16  |  15 : 8  |  7 : 6  |   5 : 0   |
     -------------------------------------------------------------------
*/
always @(negedge pclk or negedge reset) begin
  if ( reset == 1'b1 ) begin
    bram_wrdata <= 31'd0;
  end
  else begin 
      if (write_enable_in == 1'b1 ) begin
            if ( pix_per_pack_count == 1'b1 ) begin
              
              bram_wrdata[21:16] <= pix_data[7:2];
              
              if( ($signed({1'b0, pix_data[7:0]}) - $signed({1'b0, bram_rddata[31:24]})) > $signed({1'b0, threshold[7:0]}) ) begin
                bram_wrdata[31:24] <= pix_data[7:0];
                bram_wrdata[23:22] <= 2'b01; // green -- positive
              end
              else begin 
                if( ($signed({1'b0, pix_data[7:0]}) - $signed({1'b0, bram_rddata[31:24]})) < -$signed({1'b0, threshold[7:0]}) ) begin
                  bram_wrdata[31:24] <= pix_data[7:0];
                  bram_wrdata[23:22] <= 2'b10; // red -- negative
                end
                else begin
                  bram_wrdata[23:22] <= 2'b00;
                end
              end
            end
            else begin       
            
                bram_wrdata[5:0] <= pix_data[7:2];
                
                if( ($signed({1'b0, pix_data[7:0]}) - $signed({1'b0, bram_rddata[15:8]})) > $signed({1'b0, threshold[7:0]}) ) begin
                  bram_wrdata[15:8] <= pix_data[7:0];
                  bram_wrdata[7:6] <= 2'b01; // green -- positive
                end
                else begin 
                  if( ($signed({1'b0, pix_data[7:0]}) - $signed({1'b0, bram_rddata[15:8]})) < -$signed({1'b0, threshold[7:0]}) ) begin
                    bram_wrdata[15:8] <= pix_data[7:0];
                    bram_wrdata[7:6] <= 2'b10; // red -- negative
                  end
                  else begin
                    bram_wrdata[7:6] <= 2'b00;
                  end
                end
              
            end
      end
  end
  
end

//write enable out
always @(negedge pclk or negedge reset) begin
  if ( reset == 1'b1 ) begin
    write_enable_out <= 1'b0;
  end
  else begin
    if( col_counter >= 9'd96 && col_counter <= 9'd224 &&
        row_counter >= 9'd88  && row_counter <= 9'd184 &&
        pix_per_pack_count == 1'b0 && write_enable_in == 1'b0 ) begin

        write_enable_out <= 1'b1;
    end
    else begin
        write_enable_out <= 1'b0;
    end
  end
end




endmodule


















