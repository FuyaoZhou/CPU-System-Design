`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 20:51:58
// Design Name: 
// Module Name: BR
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

//BR��ΪALU��һ�����룬�����ALU��һ����������
//���γ��У�BR��16����
module BR(
    input clk,
    input [31:0] control_signal,
    input [15:0] from_MBR,
    output [15:0] to_ALU
    );
	
	reg [15:0] buff_BR=0;
	
always@(posedge clk)
    begin
		if(control_signal[7]==1) buff_BR <= from_MBR;
		else;
    end
	
	assign to_ALU = buff_BR;	
	
endmodule
