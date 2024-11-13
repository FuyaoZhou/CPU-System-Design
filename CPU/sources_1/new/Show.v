`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 21:41:23
// Design Name: 
// Module Name: Show
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
module Show(
	input clk,
	input [15:0] data1, //32 位控制信号
	input [15:0] data2, //32 位控制信号
	output [7:0] TopNumEN,
	output [7:0] TopNum
);
	integer count;
	integer choose_display;
	reg [7:0] Display_Ctrl;
	reg [7:0] Display_Data;

function [7:0] digital_display;
input[3:0] data_in;
begin
if(data_in==4'b0000) digital_display=8'b00000011;
else if(data_in==4'b0001) digital_display=8'b10011111;
else if(data_in==4'b0010) digital_display=8'b00100101;
else if(data_in==4'b0011) digital_display=8'b00001101;
else if(data_in==4'b0100) digital_display=8'b10011001;
else if(data_in==4'b0101) digital_display=8'b01001001;
else if(data_in==4'b0110) digital_display=8'b01000001;
else if(data_in==4'b0111) digital_display=8'b00011111;
else if(data_in==4'b1000) digital_display=8'b00000001;
else if(data_in==4'b1001) digital_display=8'b00001001;
else if(data_in==4'b1010) digital_display=8'b00010001;
else if(data_in==4'b1011) digital_display=8'b11000001;
else if(data_in==4'b1100) digital_display=8'b01100011;
else if(data_in==4'b1101) digital_display=8'b10000101;
else if(data_in==4'b1110) digital_display=8'b01100001;
else if(data_in==4'b1111) digital_display=8'b01110001;
else digital_display=8'b00000011;
end
endfunction

initial
begin
count=0;
choose_display=0;
Display_Ctrl=8'b11111111;
Display_Data=8'b00000000;
end


always@(posedge clk)
begin

if(count>=800000 && count>0) count=0;
else
count=count+1;
if(count>=0 && count<100000) choose_display=0;
else if(count>=100000 && count<200000) choose_display=1;
else if(count>=200000 && count<300000) choose_display=2;
else if(count>=300000 && count<400000) choose_display=3;
else if(count>=400000 && count<500000) choose_display=4;
else if(count>=500000 && count<600000) choose_display=5;
else if(count>=600000 && count<700000) choose_display=6;
else choose_display=7;

case(choose_display) 
0:
begin
Display_Ctrl=8'b11111110;
Display_Data=digital_display(data1[3:0]);
end
1:
begin
Display_Ctrl=8'b11111101;
Display_Data=digital_display(data1[7:4]);
end
2:
begin
Display_Ctrl=8'b11111011;
Display_Data=digital_display(data1[11:8]);
end
3:
begin
Display_Ctrl=8'b11110111;
Display_Data=digital_display(data1[15:12]);
end
4:
begin
Display_Ctrl=8'b11101111;
Display_Data=digital_display(data2[3:0]);
end
5:
begin
Display_Ctrl=8'b11011111;
Display_Data=digital_display(data2[7:4]);
end
6:
begin
Display_Ctrl=8'b10111111;
Display_Data=digital_display(data2[11:8]);
end
7:
begin
Display_Ctrl=8'b01111111;
Display_Data=digital_display(data2[15:12]);
end
default;
endcase
end
assign TopNumEN=Display_Ctrl;
assign TopNum=Display_Data;
endmodule