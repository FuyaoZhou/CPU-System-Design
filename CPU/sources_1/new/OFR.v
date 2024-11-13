`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 21:10:34
// Design Name: 
// Module Name: OFR
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


module OFR(
    input clk,
    input [31:0] control_signal,
    input [15:0] from_ALU,
    output [15:0] BUFF_OFR
    );
reg [15:0] buff = 0;

always@(posedge clk)
begin
    if(control_signal[12]==1)buff<=from_ALU;
end

assign BUFF_OFR = buff;       //之后仿真我们可以通过观察BUFF_OFR来判断是否有溢出的产生
    
endmodule
