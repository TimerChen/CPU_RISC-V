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
module CPU_IF(
	clk, rst, state,
	pc, i_datain,
	i_id, opcode
	);
	input wire clk, rst, state;
	input wire [4:0] pc;
	input wire [31:0] i_datain;
	output reg [4:0] i_id;
	output reg [31:0] opcode;

	reg [31:0] pc;

	always @(posedge clk) begin
		if (rst == `True) begin
			opcode <= {25'b0, `OP_IMM};
			pc <= 32'd0; //??
		end	else begin
			opcode <= i_datain;
			i_id <= pc;
		end
	end
endmodule
