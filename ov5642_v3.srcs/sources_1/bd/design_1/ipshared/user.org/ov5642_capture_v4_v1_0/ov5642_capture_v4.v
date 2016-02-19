`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.11.2015 17:00:47
// Design Name: 
// Module Name: ov5642-capture
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


module ov5642_capture_v4(input [7:0]cam_data,
    input href,
    input vsync,
    input pclk,
    input reset_n,
//    output reg end_of_line,
    output reg [16:0]address,
    output [7:0]pix_data,
    output reg write_enable
    );
    
reg [7:0]tmp_data;
reg [8:0]col_counter;

initial begin
    address <= 17'd0;
    tmp_data <= 8'd0;
    write_enable <= 1'b0;
//    col_counter <= 9'd0;
//    end_of_line <= 1'b0;
end    

//data input to buffer 
always @(posedge pclk or negedge reset_n) begin
    if (reset_n == 1'b0) begin
        tmp_data <= 8'd0;
    end
    else begin
        if (vsync == 1'b1) begin
            tmp_data <= 8'd0;
        end
        else if (href == 1'b1) begin //data is valid when href is high
                                     //2 bytes per pixel
            if (pix_counter == 1'b0) begin 
                //first byte (YYYYYYYY)
                tmp_data <= cam_data;
            end  
            //from second byte (UUUUUUUU or VVVVVVVV) 
        end
    end    
end


assign pix_data = tmp_data[7:0];

// input pixel byte counter
reg pix_counter;
always @(posedge pclk or negedge reset_n) begin
    if(reset_n == 1'b0) begin
        pix_counter <= 1'b0;
    end
    else begin
        if(vsync == 1'b1) begin
            pix_counter <= 1'b0;
        end
        else if (href == 1'b1) begin
            pix_counter <= pix_counter + 1'b1;
//            col_counter <= col_counter + 1'b1;
        end
    end
end

//always @(posedge pclk or negedge reset_n) begin
//    if(reset_n == 1'b0) begin
//        col_counter <= 9'd0;
//    end
//    else if (col_counter == 9'd319) begin
//        end_of_line <= 1'b1;
//        col_counter <= 9'd0;
//    end
//    else begin
//        end_of_line <= 1'b0;
//    end
//end
    
// RAM address generation 
always @(posedge pclk or negedge reset_n) begin
    if(reset_n == 1'b0) begin
        address <= 17'd0;
    end
    else if(vsync == 1'b1 ) begin
        address <= 17'd0;
    end
    else if (write_enable == 1'b1) begin
        address <= address + 1'b1;
    end
end

// Write enable
always @(negedge pclk or negedge reset_n) begin
    if(reset_n == 1'b0) begin
        write_enable <= 1'b0;
    end
    else begin
        if (pix_counter == 1'b1) begin
            write_enable <= 1'b1;
        end
        else begin
            write_enable <= 1'b0;
        end
    end
end



endmodule
