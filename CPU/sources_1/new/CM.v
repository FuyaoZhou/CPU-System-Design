`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 19:46:20
// Design Name: 
// Module Name: CM
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

//控制器的控制存储器（CM）中存放有每一个指令对应的微程序，
//微程序包含若干行，每行都是一个微指令。0和1代表着断和通。
//对每一个微指令而言，控制器做的就是生成一系列控制信号来控制相关寄存器的操作
module CM(
    input wire [7:0] micro_addr,
	output reg [31:0] control_signal = 0
    );
always@(*)
    begin
        case(micro_addr[7:0])
            //每个操作都会进行前面这几步
            8'h00:control_signal<=32'h00000001;
            8'h01:control_signal<=32'h00000009;
            8'h02:control_signal<=32'h00000011;
            8'h03:control_signal<=32'h00000002;
            //STORE X
            8'h04:control_signal<=32'h00000061;
            8'h05:control_signal<=32'h00100001;
            8'h06:control_signal<=32'h00080001;
            8'h07:control_signal<=32'h00000404;
            8'h08:control_signal<=32'h00000000;
            //LOAD X
            8'h09:control_signal<=32'h00000061;
            8'h0A:control_signal<=32'h00000009;
            8'h0B:control_signal<=32'h00000181;
            8'h0C:control_signal<=32'h00000201;
            8'h0D:control_signal<=32'h00000404;
            8'h0E:control_signal<=32'h00000000;
            //ADD X
            8'h0F:control_signal<=32'h00000061;
            8'h10:control_signal<=32'h00000009;
            8'h11:control_signal<=32'h00000081;
            8'h12:control_signal<=32'h00000201;
            8'h13:control_signal<=32'h00000404;
            8'h14:control_signal<=32'h00000000;
            //SUB X
            8'h15:control_signal<=32'h00000061;
            8'h16:control_signal<=32'h00000009;
            8'h17:control_signal<=32'h00000081;
            8'h18:control_signal<=32'h00000801;
            8'h19:control_signal<=32'h00000404;
            8'h1A:control_signal<=32'h00000000;
            //JMP GEZ X and JMP X
            8'h1B:control_signal<=32'h00200001;
            8'h1C:control_signal<=32'h00000404;
            8'h1D:control_signal<=32'h00000041;
            8'h1E:control_signal<=32'h00000404;
            8'h1F:control_signal<=32'h00000000;
            //HALT
            8'h20:control_signal<=32'h00000000;
            8'h21:control_signal<=32'h00000000;
            8'h22:control_signal<=32'h00000000;
            //MPY X
            8'h23:control_signal<=32'h00000061;
            8'h24:control_signal<=32'h00000009;
            8'h25:control_signal<=32'h00000081;
            8'h26:control_signal<=32'h00001001;
            8'h27:control_signal<=32'h00000404;
            8'h28:control_signal<=32'h00000000;
            //DIV X
            8'h29:control_signal<=32'h00000061;
            8'h2A:control_signal<=32'h00000009;
            8'h2B:control_signal<=32'h00000081;
            8'h2C:control_signal<=32'h00002001;
            8'h2D:control_signal<=32'h00000404;
            8'h2E:control_signal<=32'h00000000;
            //AND X
            8'h2F:control_signal<=32'h00000061;
            8'h30:control_signal<=32'h00000009;
            8'h31:control_signal<=32'h00000081;
            8'h32:control_signal<=32'h00004001;
            8'h33:control_signal<=32'h00000404;
            8'h34:control_signal<=32'h00000000;
            //OR X
            8'h35:control_signal<=32'h00000061;
            8'h36:control_signal<=32'h00000009;
            8'h37:control_signal<=32'h00000081;
            8'h38:control_signal<=32'h00008001;
            8'h39:control_signal<=32'h00000404;
            8'h3A:control_signal<=32'h00000000;
            //NOT X
            8'h3B:control_signal<=32'h00000061;
            8'h3C:control_signal<=32'h00000009;
            8'h3D:control_signal<=32'h00000081;
            8'h3E:control_signal<=32'h00010001;
            8'h3F:control_signal<=32'h00000404;
            8'h40:control_signal<=32'h00000000;
            //SHIFTR
            8'h41:control_signal<=32'h00020041;    
            8'h42:control_signal<=32'h00000404;
            8'h43:control_signal<=32'h00000000;
            //SHIFTL
            8'h44:control_signal<=32'h00040041;
            8'h45:control_signal<=32'h00000404;
            8'h46:control_signal<=32'h00000000;
            default:;
        endcase
    end	
endmodule
