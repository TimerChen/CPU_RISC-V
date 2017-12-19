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


module Reg_PC (
	clk, rst,
	wIs, pcIn,
	pc, ce
	);
	input wire clk, rst, wIs;
	input wire [31:0] pcIn;
	output reg [31:0] pc;
	output reg ce;
	reg [`XLEN-1:0] regs[31:0];

	always @ ( posedge clk ) begin
		if (ce == `False) begin
			pc <= 32'd0;
		end else begin
			$display("pc+4:%d", pc);
			pc = pc + 32'd4;
		end
	end

	always @ ( posedge clk ) begin
		$display("update ce:%d %d", rst, ce);
		if (rst == `True) begin
			ce <= `False;
		end else begin
			ce <= `True;
		end
	end

endmodule // RegFile
