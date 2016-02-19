
module dvs_cdma_v1(
// camera input
                    input  pclk,
                    input  vsync,
                    input  href,
                    input  [7:0] pix_data,
                    input  write_enable_in,
// threshold value
                    input  [7:0] threshold,
// signal the PS a new frame has just started
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
reg [1:0] pix_per_pack_count;

assign new_frame = vsync;
assign bram_we  = {write_enable_out, write_enable_out, write_enable_out};
assign bram_rst = reset;
assign bram_en  = !reset;



// read new line flag
always @(posedge pclk or negedge reset) begin
  if (reset == 1'b1) begin
    read_new_line <= 1'b0;
  end
  else begin
        //after writing (col_count = 224), read next
    if( column_counter == 9'd320 || 
       (column_counter == 9'd0 && line_counter == 8'd0)) begin //first pixel, read first line

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
always @(posedge write_enable_in or negedge reset) begin

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
    pixel_per_pack_count
  end  
  
end

endmodule

















