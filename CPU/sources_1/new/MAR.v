`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 18:47:57
// Design Name: 
// Module Name: MAR
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

//MAR�����Ҫ�Ӵ洢���ж�ȡ��Ҫд��洢���Ĵ洢����ַ
//�˴�������������ΪCPU��memory�ж�����д������ΪCPU������д��memory
//MAR��8bit
module MAR(
    input clk,
    input wire[31:0] control_signal,
    input wire[7:0] from_MBR,
    input wire[7:0] from_PC,
    output wire[7:0] to_memory
    );
	
	reg [7:0]buff_MAR = 0;
	
always @(posedge clk)
	begin
		if(control_signal[5]==1) buff_MAR <= from_MBR;
		else if(control_signal[10]==1) buff_MAR <= from_PC;
		else;
	end
	assign to_memory = buff_MAR;
endmodule
