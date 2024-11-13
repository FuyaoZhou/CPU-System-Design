`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 20:45:58
// Design Name: 
// Module Name: PC
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

//PC寄存器用来跟踪程序中将要使用的指令。
//l本课程中，PC有8比特。
module PC(
    input clk,
    input [31:0] control_signal,
    input [7:0] from_MBR,
    output wire[7:0] to_MAR
    );
	
	reg [7:0] buff_PC=0;
	
always@(posedge clk)
    begin
		if(control_signal[6]==1) buff_PC <= buff_PC+1;
		else if(control_signal[21]==1) buff_PC <= from_MBR;
		else;
    end
	assign to_MAR = buff_PC;	
endmodule
