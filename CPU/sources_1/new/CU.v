`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 19:41:07
// Design Name: 
// Module Name: CU
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
module CU(
    input clk,
    input wire [7:0]OPcode,
    input wire flag,
    output wire [31:0]control_signal
    );
	
wire [7:0]micro_addr;   //�洢��Control Memory�е�΢�����ַ��8bits

//���Ƶ�ַ�Ĵ�����CAR������������Ҫ��ȡ��һ��΢ָ�
//Ҳ���Ƕ�ȡ��һ����ַ����CM�ж�ȡ��һ��΢ָ����൱��ִ�������ɸ������ź�
CAR my_CAR(				
    .clk(clk),
    .flag(flag),
	.OPcode(OPcode[7:0]),
    .control_signal(control_signal[31:0]),
    .micro_addr(micro_addr)
); 

//�������Ŀ��ƴ洢����CM���д����ÿһ��ָ���Ӧ��΢����
//΢������������У�ÿ�ж���һ��΢ָ�0��1�����ŶϺ�ͨ��
//��ÿһ��΢ָ����ԣ����������ľ�������һϵ�п����ź���������ؼĴ����Ĳ���
CM my_CM(				
   .micro_addr(micro_addr),
   .control_signal(control_signal[31:0])
);
endmodule 

//���¹������̣�
//CAR����opcode��flag��IR��������ûŪ��������microinstruction������CM��CM�����Ӧ��control_signals
