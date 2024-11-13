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
	
wire [7:0]micro_addr;   //存储在Control Memory中的微程序地址，8bits

//控制地址寄存器（CAR）控制着下面要读取哪一条微指令，
//也就是读取哪一个地址，从CM中读取了一条微指令就相当于执行了若干个控制信号
CAR my_CAR(				
    .clk(clk),
    .flag(flag),
	.OPcode(OPcode[7:0]),
    .control_signal(control_signal[31:0]),
    .micro_addr(micro_addr)
); 

//控制器的控制存储器（CM）中存放有每一个指令对应的微程序，
//微程序包含若干行，每行都是一个微指令。0和1代表着断和通。
//对每一个微指令而言，控制器做的就是生成一系列控制信号来控制相关寄存器的操作
CM my_CM(				
   .micro_addr(micro_addr),
   .control_signal(control_signal[31:0])
);
endmodule 

//大致工作流程：
//CAR根据opcode和flag和IR（？这里没弄懂）产生microinstruction，给到CM，CM输出相应的control_signals
