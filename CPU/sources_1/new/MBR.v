`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 15:11:20
// Design Name: 
// Module Name: MBR
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

//MBR存储着将要被存入memory或者最后一次从memory中读出来的数值
//MBR有16bit
module MBR(
    input clk,
    input wire[31:0] control_signal,
    input wire[15:0] from_memory,
    input wire[15:0] from_ACC,
    output wire[15:0] to_memory,
    output wire[7:0] to_PC,
    output wire[7:0] to_IR,
    output wire[15:0] to_BR,
    output wire[7:0] to_MAR
    );

	reg [15:0] buff_MBR=0;

always @(posedge clk)
	begin 
		if (control_signal[3]==1) buff_MBR <= from_memory;
		else if (control_signal[20]==1) buff_MBR <= from_ACC;
		else;
	end
	assign to_memory = (control_signal[19]==1)?buff_MBR:0;
	assign to_PC = buff_MBR[7:0];
	assign to_IR = buff_MBR[15:8];
	assign to_BR = buff_MBR;
	assign to_MAR = buff_MBR[7:0];

endmodule
