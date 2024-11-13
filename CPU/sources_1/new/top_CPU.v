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
wire [15:0]memory_MBR;//_的意思就是前一个指向后一个的连线
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
//第一大部分，control unit, 输入opcode以后，根据opcode给出控制信号。
//微程序控制单元Control Unit
CU u_Control_Unit(
    .clk(clk_s),
    .OPcode(OPcode[7:0]),
    .flag(flag),
    .control_signal(control_signal[31:0])
);
//其余各模块都受控制信号的影响来进行数据的传输
//----------------------------------------------------------------------------------------
//MAR,MBR     cited by F.Y Zhou
//总的逻辑应该是：以add指令为例
//1、MBR 从 Memory 中读取完整的的16bits指令，包括OPcode以及“操作数地址”
//（关于操作数地址的概念次数不准确，后续会继续说明）
//2、MBR把 buff 中的高八位传递给IR，低八位传给MAR
//3、IR 收到 OPcode以后将 OPcode 传递给control unit
//4、control unit 根据 opcode 生成对应的微程序地址
//5、MAR得到操作数地址以后，MBR得以从Memory读取到正确的数据
//6、ALU在控制信号下得以正确进行计算操作
//7、存储结果，CAR置0，继续读取下一条指令
//-------------------------------------------------------------------------------------------------
//MBR存储着将要被存入memory或者最后一次从memory中读出来的数值
//MBR有16bit
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
//MAR存放着要从存储器中读取或要写入存储器的存储器地址
//此处，“读”定义为CPU从memory中读。“写”定义为CPU把数据写入memory
//MAR有8bit
MAR u_MAR(
    .clk(clk_s),
    .control_signal(control_signal[31:0]),
    .from_MBR(MBR_MAR[7:0]),
    .from_PC(PC_MAR[7:0]),
    .to_memory(MAR_memory[7:0])
);
//-------------------------------------------------------------------------------------------------
//然后是IR，它接受从MBR传输来的OPCODE，并传输给Control_Unit
//IR存放指令的OPCODE（操作码）部分。
//本课程中，IR有8bit。
IR u_IR(
    .clk(clk_s),
    .control_signal(control_signal[31:0]),
    .from_MBR(MBR_IR[7:0]),
    .to_CU(OPcode[7:0])
);
//----------------------------------------------------------------------------------------
//ALU 的作用是进行二元的操作，包括加减乘除，逻辑与，逻辑或，NOT，逻辑左移与逻辑右移
wire [15:0]BUFF_ALU;//给ALU的一个缓存，没有被进位的数据,(当数据有溢出，溢出部分（31：16）被送到OFR，Overflow Register)
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
//ACC（Accumulater）
//作为ALU的操作数之一，也用来存储ALU计算结果（没有溢出的部分）在进行STORE操作的时候，要先把ACC中的值给装载到MBR中
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
//OFR（Overflow Register）   
//用来存储ALU计算之后溢出的部分
wire [15:0]BUFF_OFR;
OFR u_OFR(
    .clk(clk_s),
    .control_signal(control_signal[31:0]),
    .from_ALU(ALU_OFR[15:0]),
    .BUFF_OFR(BUFF_OFR[15:0])
);
//----------------------------------------------------------------------------------------
//PC寄存器用来跟踪程序中将要使用的指令。
//l本课程中，PC有8比特。
PC u_PC(
    .clk(clk_s),
    .control_signal(control_signal[31:0]),
    .from_MBR(MBR_PC[7:0]),
    .to_MAR(PC_MAR[7:0])
);
//----------------------------------------------------------------------------------------
//BR作为ALU的一个输入，存放着ALU的一个操作数。
//本课程中，BR有16比特
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

