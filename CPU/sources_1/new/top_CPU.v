`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 18:45:32
// Design Name: 
// Module Name: top_CPU
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


module top_CPU(
	input clk,
	output [7:0]TopNumEN,
	output [7:0]TopNum
    );
wire [31:0]control_signal;
wire [7:0]OPcode;
wire flag;
wire [15:0]memory_MBR;//_����˼����ǰһ��ָ���һ��������
wire [15:0]MBR_memory;
wire [7:0]MBR_MAR;
wire [7:0]MBR_PC;
wire [7:0]MBR_IR;
wire [15:0]MBR_BR;
wire [7:0]PC_MAR;
wire [7:0]MAR_memory;
wire [15:0]BR_ALU;
wire [15:0]ALU_ACC;
wire [15:0]ALU_OFR;
wire [15:0]ACC_ALU;
wire [15:0]ACC_MBR;
//-------------------------------------------------------------------------------------------------
reg [9:0]wave = 0;//1024
reg clk_s = 0;
    always@(posedge clk)
        begin
			wave = wave + 1;
			if(wave <= 500) clk_s <= 0;
			else
				begin
				clk_s <= 1;
					if(wave > 1000) wave <= 0;
					else;
				end
        end
//-------------------------------------------------------------------------------------------------
//��һ�󲿷֣�control unit, ����opcode�Ժ󣬸���opcode���������źš�
//΢������Ƶ�ԪControl Unit
CU u_Control_Unit(
    .clk(clk_s),
    .OPcode(OPcode[7:0]),
    .flag(flag),
    .control_signal(control_signal[31:0])
);
//�����ģ�鶼�ܿ����źŵ�Ӱ�����������ݵĴ���
//----------------------------------------------------------------------------------------
//MAR,MBR     cited by F.Y Zhou
//�ܵ��߼�Ӧ���ǣ���addָ��Ϊ��
//1��MBR �� Memory �ж�ȡ�����ĵ�16bitsָ�����OPcode�Լ�����������ַ��
//�����ڲ�������ַ�ĸ��������׼ȷ�����������˵����
//2��MBR�� buff �еĸ߰�λ���ݸ�IR���Ͱ�λ����MAR
//3��IR �յ� OPcode�Ժ� OPcode ���ݸ�control unit
//4��control unit ���� opcode ���ɶ�Ӧ��΢�����ַ
//5��MAR�õ���������ַ�Ժ�MBR���Դ�Memory��ȡ����ȷ������
//6��ALU�ڿ����ź��µ�����ȷ���м������
//7���洢�����CAR��0��������ȡ��һ��ָ��
//-------------------------------------------------------------------------------------------------
//MBR�洢�Ž�Ҫ������memory�������һ�δ�memory�ж���������ֵ
//MBR��16bit
MBR u_MBR(
    .clk(clk_s),
    .control_signal(control_signal[31:0]),
    .from_memory(memory_MBR[15:0]),
    .from_ACC(ACC_MBR[15:0]),
    .to_memory(MBR_memory[15:0]),
    .to_PC(MBR_PC[7:0]),
    .to_IR(MBR_IR[7:0]),
    .to_BR(MBR_BR[15:0]),
    .to_MAR(MBR_MAR[7:0])
);
//-------------------------------------------------------------------------------------------------
//MAR�����Ҫ�Ӵ洢���ж�ȡ��Ҫд��洢���Ĵ洢����ַ
//�˴�������������ΪCPU��memory�ж�����д������ΪCPU������д��memory
//MAR��8bit
MAR u_MAR(
    .clk(clk_s),
    .control_signal(control_signal[31:0]),
    .from_MBR(MBR_MAR[7:0]),
    .from_PC(PC_MAR[7:0]),
    .to_memory(MAR_memory[7:0])
);
//-------------------------------------------------------------------------------------------------
//Ȼ����IR�������ܴ�MBR��������OPCODE���������Control_Unit
//IR���ָ���OPCODE�������룩���֡�
//���γ��У�IR��8bit��
IR u_IR(
    .clk(clk_s),
    .control_signal(control_signal[31:0]),
    .from_MBR(MBR_IR[7:0]),
    .to_CU(OPcode[7:0])
);
//----------------------------------------------------------------------------------------
//ALU �������ǽ��ж�Ԫ�Ĳ����������Ӽ��˳����߼��룬�߼���NOT���߼��������߼�����
wire [15:0]BUFF_ALU;//��ALU��һ�����棬û�б���λ������,(�������������������֣�31��16�����͵�OFR��Overflow Register)
ALU u_ALU(
    .clk(clk_s),
    .control_signal(control_signal[31:0]),
    .from_BR(BR_ALU[15:0]),
    .from_ACC(ACC_ALU[15:0]),
    .to_ACC(ALU_ACC[15:0]),
    .to_OFR(ALU_OFR[15:0]),
    .BUFF_ALU(BUFF_ALU[15:0])
);
//----------------------------------------------------------------------------------------
//ACC��Accumulater��
//��ΪALU�Ĳ�����֮һ��Ҳ�����洢ALU��������û������Ĳ��֣��ڽ���STORE������ʱ��Ҫ�Ȱ�ACC�е�ֵ��װ�ص�MBR��
wire [15:0]BUFF_ACC;
ACC u_ACC(
    .clk(clk_s),
    .control_signal(control_signal[31:0]),
    .from_ALU(ALU_ACC[15:0]),
    .to_ALU(ACC_ALU[15:0]),
    .to_MBR(ACC_MBR[15:0]),
    .flag(flag),
    .BUFF_ACC(BUFF_ACC[15:0])
);
//----------------------------------------------------------------------------------------
//OFR��Overflow Register��   
//�����洢ALU����֮������Ĳ���
wire [15:0]BUFF_OFR;
OFR u_OFR(
    .clk(clk_s),
    .control_signal(control_signal[31:0]),
    .from_ALU(ALU_OFR[15:0]),
    .BUFF_OFR(BUFF_OFR[15:0])
);
//----------------------------------------------------------------------------------------
//PC�Ĵ����������ٳ����н�Ҫʹ�õ�ָ�
//l���γ��У�PC��8���ء�
PC u_PC(
    .clk(clk_s),
    .control_signal(control_signal[31:0]),
    .from_MBR(MBR_PC[7:0]),
    .to_MAR(PC_MAR[7:0])
);
//----------------------------------------------------------------------------------------
//BR��ΪALU��һ�����룬�����ALU��һ����������
//���γ��У�BR��16����
BR u_BR(
    .clk(clk_s),
    .control_signal(control_signal[31:0]),
    .from_MBR(MBR_BR[15:0]),
    .to_ALU(BR_ALU[15:0])
);
//----------------------------------------------------------------------------------------
my_main_memory MM(
  .clka(clk),    			// input wire clka
  .wea(control_signal[19]), // input wire [0 : 0] wea
  .addra(MAR_memory[7:0]),  // input wire [7 : 0] addra
  .dina(MBR_memory[15:0]),  // input wire [15 : 0] dina
  .douta(memory_MBR[15:0])  // output wire [15 : 0] douta
);
//----------------------------------------------------------------------------------------
Show u_Show(
    .clk(clk),
    .data1(BUFF_ACC[15:0]),
    .data2(BUFF_OFR[15:0]),
    .TopNumEN(TopNumEN[7:0]),
    .TopNum(TopNum[7:0])
);
endmodule

