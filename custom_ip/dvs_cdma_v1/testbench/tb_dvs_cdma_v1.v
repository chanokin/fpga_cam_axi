`timescale 1 ns / 1 ns

module tb_dvs_cdma_v1();

reg [3:0] i;

reg pclk;
reg vsync;
reg href;
reg [7:0]pix_data;
reg write_enable_in;
reg [7:0]threshold;
reg [31:0]bram_rddata;
reg reset;

wire new_frame; 
wire read_new_line; 
wire write_new_line;
wire [16:0] bram_addr;
wire bram_clk;
wire [31:0] bram_wrdata;
wire bram_en;
wire bram_rst;
wire [3:0] bram_we;



dvs_cdma_v1 dvs_cdma(.pclk (pclk),
                     .vsync (vsync),
                     .href (href),
                     .pix_data (pix_data),
                     .write_enable_in (write_enable_in),
                     .threshold (threshold),
                     .new_frame (new_frame), 
                     .read_new_line (read_new_line), 
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
  for(i=4'd0; i < 4'd4; i = i + 4'b1) begin
    bram_rddata = 32'd0;

    #5 pix_data = 8'd10;

    #5 write_enable_in = 1'b1;
    #10 write_enable_in = 1'b0;
    

    #5 pix_data = 8'd20;

    #5 write_enable_in = 1'b1;
    #10 write_enable_in = 1'b0;


    bram_rddata = 32'h00002800;


    #5 pix_data = 8'd10;

    #5 write_enable_in = 1'b1;
    #10 write_enable_in = 1'b0;

    #5 pix_data = 8'd20;

    #5 write_enable_in = 1'b1;
    #10 write_enable_in = 1'b0;
  end
  #40 $finish;
end 


endmodule
