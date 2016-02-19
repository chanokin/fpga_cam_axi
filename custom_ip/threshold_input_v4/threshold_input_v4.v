// threshold buttons

module threshold_input_v4(
                       input clk,
                       input button_up,
                       input button_down,
                       output reg [7:0]threshold);

initial begin
   threshold <= 8'd12;
end

always @(posedge clk) begin
   if (button_up && threshold <= 8'd250) begin
      threshold <= threshold + 2;
   end
   else if(button_down && threshold >= 8'd4) begin
      threshold <= threshold - 2;
   end
end

endmodule

