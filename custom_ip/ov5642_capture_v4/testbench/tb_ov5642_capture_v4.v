`timescale 1 ns / 1 ns

module tb_ov5642_capture_v4();

reg [3:0]i;

reg [7:0]cam_data;
reg href;
reg vsync;
reg pclk;
reg reset_n;

wire [16:0]address;
wire [7:0]pix_data;
wire write_enable;

ov5642_capture_v4 ov5642(.cam_data(cam_data),
                         .href(href),
                         .vsync(vsync),
                         .pclk(pclk),
                         .reset_n(reset_n),
                         .address(address),
                         .pix_data(pix_data),
                         .write_enable(write_enable));

initial begin
  pclk = 0;
  href = 0;
  vsync = 0;
  reset_n = 0;
  cam_data = 0;
  forever #5 pclk = !pclk;
  
end

initial begin
  $dumpfile ("tb_ov5642_capture_v4.vcd"); 
  $dumpvars;//(tb_dvs_cdma_v1); 
  #15 reset_n = 1;
  #1  vsync = 1;
  #9  vsync = 0;
  #10 href  = 1;
  for (i = 0; i < 4; i = i + 1) begin
    #10 cam_data = 255;
    #10 cam_data = 10;
    #10 cam_data = 255;
    #10 cam_data = 20;
    #10 cam_data = 255;
    #10 cam_data = 30;
  end
  #10 href = 0;
  #10 $finish;
end


endmodule
