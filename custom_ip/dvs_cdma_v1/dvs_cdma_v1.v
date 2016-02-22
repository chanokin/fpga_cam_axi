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



module dvs_cdma_v1(
// camera input
                    input  pclk,
                    input  vsync,
                    input  href,
                    input  [7:0] pix_data,
                    input  write_enable_in,
// threshold value
                    input  [7:0] threshold,
// signal the PS a new frame has just started (reset PS address/change buffer)
                    output new_frame, 
// signal the PS to issue new line FROM DDR <-
                    output reg read_new_line, 
// signal the PS to transfer new line TO DDR ->
                    output reg write_new_line,
// bram interface
                    output reg [16:0] bram_addr,
                    output bram_clk,
                    output reg [31:0] bram_wrdata,
                    input  [31:0] bram_rddata,
                    output bram_en,
                    output bram_rst,
                    output [3:0] bram_we,
// block reset
                    input  reset
                  );


reg write_enable_out;
reg [8:0] column_counter;
reg [7:0] line_counter;
reg pix_per_pack_count;

assign new_frame = vsync;
assign bram_we  = {write_enable_out, write_enable_out, write_enable_out};
assign bram_rst = reset;
assign bram_en  = !reset;
assign bram_clk = pclk;


// read new line flag
always @(posedge pclk or negedge reset) begin
  if (reset == 1'b1) begin
    read_new_line <= 1'b0;
  end
  else begin
        //after writing (col_count = 224), read next
    if( column_counter == 9'd320 || 
       (column_counter == 9'd0 && line_counter == 8'd0 && new_frame == 1'b1)) begin //first pixel, read first line

      read_new_line <= 1'b1;
    end
    else begin
      read_new_line <= 1'b0;
    end
  end
end


// write results flag
always @(posedge pclk or negedge reset) begin
  if (reset == 1'b1) begin
    write_new_line <= 1'b0; 
  end
  else begin
    if( column_counter == 8'd224 ) begin
      write_new_line <= 1'b1;
    end
    else begin
      write_new_line <= 1'b0;
    end
  end
  
end

// count lines
always @(posedge pclk or negedge reset) begin
  if(reset == 1'b1) begin
    line_counter <= 8'd0;
  end
  else begin
    if (vsync == 1'b0) begin
      line_counter <= 8'd0;
    end
    else begin
      if (column_counter >= 9'd319) begin
        line_counter <= line_counter + 8'd1;
      end
    end
  end
end

//                | | |
// count columns  v v v is this possible?
always @(negedge write_enable_in or negedge reset) begin

  if(reset == 1'b1) begin
    column_counter <= 9'd0;
  end
  else begin
    if ( vsync == 1'b1 || href  == 1'b0 ) begin
      column_counter <= 9'd0;
    end
    else begin
      column_counter <= column_counter + 9'd1;
    end
  end
  
end

// received pixels count
always @(posedge write_enable_in or negedge reset) begin

  if(reset == 1'b1) begin
    pix_per_pack_count <= 1'b0;
  end
  else begin
    if (href == 1'b1 && column_counter > 9'd0) begin
      pix_per_pack_count <= pix_per_pack_count + 1'b1;
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
always @(posedge pclk or negedge reset) begin
  if ( reset == 1'b1 ) begin
    bram_addr <= 17'd0;
  end
  else begin
    if ( pix_per_pack_count == 1'b1 &&
         column_counter >= 9'd96) begin
         
      bram_addr <= bram_addr + 17'd1;
    end
    
    if ( column_counter == 9'd224 ) begin
      bram_addr <= 17'd0;
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
always @(posedge pclk or negedge reset) begin
  if ( reset == 1'b1 ) begin
    bram_wrdata <= 31'd0;
  end
  else begin
    if ( pix_per_pack_count == 1'b0 &&
         write_enable_in == 1'b1 ) begin
      
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
    else begin if ( pix_per_pack_count == 1'b1 &&
                    write_enable_in == 1'b1 ) begin
      
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
always @(posedge pclk or negedge reset) begin
  if ( reset == 1'b1 ) begin
    write_enable_out <= 1'b0;
  end
  else begin
    if ( pix_per_pack_count == 1'b1 &&
         write_enable_in == 1'b0 ) begin

        write_enable_out <= 1'b1;
    end
    else begin
        write_enable_out <= 1'b0;
    end
  end
end

//waddress out
always @(posedge pclk or negedge reset) begin
  if ( reset == 1'b1 ) begin
    bram_addr <= 17'd0;
  end
  else begin
    if ( read_new_line == 1'b1 ) begin

      bram_addr <= 17'd0;
    end
    else begin 
      if ( write_enable_out == 1'b1 ) begin

        bram_addr <= bram_addr + 17'd1;
      end
    end
  end
end

endmodule

















