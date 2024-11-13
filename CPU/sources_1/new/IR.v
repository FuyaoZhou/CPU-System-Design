`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 20:31:43
// Design Name: 
// Module Name: IR
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


module IR(
    input clk,
    input [31:0]control_signal,
    input [7:0]from_MBR,
    output wire [7:0]to_CU
    );
	
	reg [7:0] buff_IR=0;
	
always@(posedge clk)
    begin
		if(control_signal[4]==1) buff_IR <= from_MBR;
    end
assign to_CU = buff_IR;	
	
endmodule
