`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 21:10:45
// Design Name: 
// Module Name: ACC
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


module ACC(
    input clk,
    input [31:0] control_signal,
    input [15:0] from_ALU,
    output [15:0] to_ALU,
    output [15:0] to_MBR,
    output flag,
    output [15:0] BUFF_ACC
    );
	
    reg [15:0] buff=0;
	
always@(posedge clk)
	begin
	    if     (control_signal[9]==1) buff<=from_ALU;
	    else if(control_signal[18]==1)buff<=from_ALU;
	    else if(control_signal[17]==1)buff<=from_ALU;
	    else if(control_signal[16]==1)buff<=from_ALU;
	    else if(control_signal[15]==1)buff<=from_ALU;
	    else if(control_signal[14]==1)buff<=from_ALU;
	    else if(control_signal[12]==1)buff<=from_ALU;
	    else if(control_signal[11]==1)buff<=from_ALU;
	    else if(control_signal[8]==1) buff<=16'h0000;
	    else;
	end

	assign BUFF_ACC=buff;
	assign flag=(buff[15]?0:1);
	assign to_ALU=buff;
	assign to_MBR=buff;

endmodule
