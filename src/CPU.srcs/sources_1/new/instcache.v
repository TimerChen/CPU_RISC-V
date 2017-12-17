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
	clk, rst, state, stall,
	pc,
	instOut

	);

	input wire clk, rst, state, stall;
	input wire [31:0] pc;
	output reg [31:0] instOut;


	reg [7:0] inst[1023:0];


	always @ ( * ) begin
		if (rst == `True) begin

		end	else if (stall != `True) begin
			instOut <= inst[pc];
		end
	end
endmodule
