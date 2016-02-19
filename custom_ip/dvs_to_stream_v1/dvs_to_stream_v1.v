module dvs_to_stream_v1(input [7:0]  pix_in,
                        input [9:0]  ref_in,
                        input [16:0] address,
                        input write_enable,
                        input pclk,
                        input reset,

                        output m_axis_tvalid, //write_enable
                        input  m_axis_tready, //receiver ready
                        output reg m_axis_tlast, //end of line
                        output reg [31:0]m_axis_tdata, //32- or 24-bit data
                        output reg m_axis_tuser, //start of frame
                        output aclk //out clock <= !pclk?
                        );
                        
assign m_axis_tvalid = write_enable;
assign aclk = !pclk;
reg [8:0] col_count;

initial begin
  m_axis_tdata <= 31'd0;
  m_axis_tlast <= 1'b0;
  m_axis_tuser <= 1'b0;
  col_count <= 9'd0;
end

always @(posedge pclk or negedge reset) begin
  if(reset == 1'b1) begin
    m_axis_tdata <= 31'd0;
    m_axis_tlast <= 1'b0;
    m_axis_tuser <= 1'b0;
  end
  else begin
                     //alpha--rrrrrr/rrgggggggg/bbbbbbbb
    m_axis_tdata <= {8'd255,  6'd0,  ref_in,       pix_in};
    
    if(address == 17'd0) begin
      m_axis_tuser = 1'b1;
    end
    else begin
      m_axis_tuser = 1'b0;
    end
    
    if(col_count == 9'd319) begin
      m_axis_tlast = 1'b1;
    end
    else begin
      m_axis_tlast = 1'b0;
    end
    
  end
  
end

always @(posedge write_enable or negedge reset) begin
  if(reset == 1'b1) begin
    col_count <= 9'd0;
  end
  else begin
    if(address == 17'd0) begin
      col_count <= 9'd0;
    end
    else begin
      col_count <= col_count + 9'd1;
    end
  end
end

endmodule



