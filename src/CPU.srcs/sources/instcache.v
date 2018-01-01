`timescale 1ns / 1ps
`include "def.v"
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2017/12/13 15:39:40
// Design Name:
// Module Name: cpu_core
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
module InstCache(
	clk, rst, ce, stall,
	pc,
	instOut,
	stall_o

	);

	input wire clk, rst, ce, stall;
	input wire [31:0] pc;
	output reg [31:0] instOut;
	output reg 		  stall_o;


	reg [7:0] inst[0:1023];


	always @ ( * ) begin
		if (rst == `True) begin
			instOut <= {25'd0, `OP_IMM};
			stall_o <= 1'b0;
		end	else if (ce == `True && stall != `True) begin
			instOut <= {inst[pc+3],inst[pc+2],inst[pc+1],inst[pc]};
		end
	end
endmodule
