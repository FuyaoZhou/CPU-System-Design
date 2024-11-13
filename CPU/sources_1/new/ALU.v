`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 21:10:01
// Design Name: 
// Module Name: ALU
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


module ALU(
    input clk,
    input [31:0] control_signal,
    input signed [15:0] from_BR,
    input signed [15:0] from_ACC,
    output [15:0] to_ACC,
    output [15:0] to_OFR,
    output [15:0] BUFF_ALU
    );

reg signed [31:0] buff = 0;    //ʹ��32bits��Ŀ�����ڷ�ֹ�����

always@(*)
begin
	if     (control_signal[9]==1)   buff<=from_ACC+from_BR;
	else if(control_signal[11]==1)  buff<=from_ACC-from_BR;          
	else if(control_signal[12]==1)  buff<=from_ACC*from_BR;
	else if(control_signal[14]==1)  buff<=from_ACC&from_BR;        
	else if(control_signal[15]==1)  buff<=from_ACC|from_BR;
	else if(control_signal[16]==1)  buff<=~from_ACC;
	else if(control_signal[17]==1)  buff<=from_ACC>>1;
	else if(control_signal[18]==1)  buff<=from_ACC<<1;
	else;

end

assign BUFF_ALU=buff[15:0];       //û������Ĳ���
assign to_ACC=buff[15:0];         //��������Ĳ��ֱ�����ACC�����ܼ�����Ϊ��һ�μ���Ĳ�������
assign to_OFR=buff[31:16];         //����Ĳ����͵�OFR��Overflow Register��

endmodule
