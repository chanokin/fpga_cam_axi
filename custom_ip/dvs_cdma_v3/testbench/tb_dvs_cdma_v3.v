`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.03.2016 14:44:21
// Design Name: 
// Module Name: tb_dvs_cdma_v2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_dvs_cdma_v3();

reg [8:0] col_idx;
reg [8:0] row_idx;

reg pclk;
reg vsync;
reg href;
reg [7:0]pix_data;
reg write_enable_in;
reg [7:0]threshold;
reg [31:0]bram_rddata;
reg reset;

wire new_frame; 
wire write_new_line;
wire [16:0] bram_addr;
wire bram_clk;
wire [31:0] bram_wrdata;
wire bram_en;
wire bram_rst;
wire [3:0] bram_we;



dvs_cdma_v3 dvs_cdma(.pclk (pclk),
                     .vsync (vsync),
                     .href (href),
                     .pix_data (pix_data),
                     .write_enable_in (write_enable_in),
                     .threshold (threshold),
                     .new_frame (new_frame), 
                     .write_new_line (write_new_line),
                     .bram_addr (bram_addr),
                     .bram_clk (bram_clk),
                     .bram_wrdata (bram_wrdata),
                     .bram_rddata (bram_rddata),
                     .bram_en (bram_en),
                     .bram_rst (bram_rst),
                     .bram_we (bram_we),
                     .reset (reset)
                    );


initial begin
  pclk = 1'b1;
  forever #5 pclk = !pclk;
end

initial  begin
  $dumpfile ("vcd_dvs_cdma.vcd"); 
  $dumpvars;//(tb_dvs_cdma_v1); 
  
  vsync = 1'b0;
  href = 1'b0;
  pix_data = 8'd0;
  write_enable_in = 1'b0;
  threshold = 8'd12;
  bram_rddata = 32'd0;
  reset = 1'b1;
  
  #10 reset = 1'b0;
  
  #1 pix_data = 8'd10;
  
  #9 vsync = 1'b1;
  
  #10 vsync = 1'b0;
  
  #10 href = 1'b1;
  #5
  for(row_idx=9'd0; row_idx < 9'd34; row_idx = row_idx + 9'b1) begin
      href = 1'b0;
      #10 href = 1'b1;
      #5
      for(col_idx=9'd0; col_idx < 9'd80; col_idx = col_idx + 9'b1) begin
        bram_rddata = 32'd0;
    
        #5 pix_data = 8'd10;
    
        #5 write_enable_in = 1'b1;
        #10 write_enable_in = 1'b0;
        
    
        #5 pix_data = 8'd20;
    
        #5 write_enable_in = 1'b1;
        #10 write_enable_in = 1'b0;
    
    
        bram_rddata = 32'h00002800;
    
    
        #5 pix_data = 8'd30;
    
        #5 write_enable_in = 1'b1;
        #10 write_enable_in = 1'b0;
    
        #5 pix_data = 8'd40;
    
        #5 write_enable_in = 1'b1;
        #10 write_enable_in = 1'b0;
      end
  end
  #40 $finish;
end 


endmodule
