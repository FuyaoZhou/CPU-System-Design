`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 19:45:43
// Design Name: 
// Module Name: CAR
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

//���Ƶ�ַ�Ĵ�����CAR������������Ҫ��ȡ��һ��΢ָ�
//Ҳ���Ƕ�ȡ��һ����ַ����CM�ж�ȡ��һ��΢ָ����൱��ִ�������ɸ������ź�
module CAR(
    input clk,
    input wire flag,
    input wire [7:0]OPcode,     //opcode���������������
    input wire [31:0]control_signal,
    output reg [7:0]micro_addr = 0  //ͬ��������ҲҪ�����ʼֵ0��������֤CM���ʼִ��ǰ�Ĳ�
    );
//����opcode�����micro_addr
//01  STORE X
//02  LOAD X
//03  ADD X
//04  SUB X
//05  JMPGEZ X
//06  JMP X
//07  HALT
//08  MPY X
//09  DIV X
//0A  AND X
//0B  OR X
//0C  NOT X
//0D  SHIFTR
//0E  SHIFTL
always@(posedge clk)
	begin
		if(control_signal[0]==1)
			micro_addr <= micro_addr+1'b1;
		else if(control_signal[1]==1)
		    begin
				case(OPcode)
				8'h01:micro_addr <= 8'h04;
				8'h02:micro_addr <= 8'h09;
				8'h03:micro_addr <= 8'h0F;
				8'h04:micro_addr <= 8'h15;
				8'h05:
					begin
						if(flag==1) micro_addr <= 8'h1B;
						else micro_addr <= 8'h1D;
					end
				8'h06:micro_addr <= 8'h1B;
				8'h07:micro_addr <= 8'h20;
				8'h08:micro_addr <= 8'h23;
				8'h09:micro_addr <= 8'h29;
				8'h0A:micro_addr <= 8'h2F;
				8'h0B:micro_addr <= 8'h35;
				8'h0C:micro_addr <= 8'h3B;
				8'h0D:micro_addr <= 8'h41;
				8'h0E:micro_addr <= 8'h44;
				default:;
				endcase
			end
		else if(control_signal[2]==1) micro_addr <= 8'h00;
		else;
	end
    
endmodule
