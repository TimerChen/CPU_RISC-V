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
	clk, rst, stall,
	pc, i_datain,
	i_id, opCode,

	iAddr,
	rw_flag,
	busy, done,
	stall_o
	);
	input wire clk, rst, stall;
	input wire [31:0] pc;
	input wire [31:0] i_datain;
	output reg [31:0] i_id;
	output reg [31:0] opCode;

	output reg [31:0] iAddr;
	output reg [1:0] rw_flag;
	input wire busy, done;
	output reg stall_o;

	always @ ( posedge clk ) begin
		if(rst == `True) begin
			iAddr <= 32'd0;
		end else if(done == 1'b1) begin
			iAddr <= pc;
		end
	end

	always @( * ) begin
		if(rst == `True) begin
			i_id = 32'b0;
			opCode = {25'b0, `OP_IMM};
			stall_o = 1'b0;
			rw_flag = 2'b0;
		end else if(done == 1'b1) begin
			rw_flag = 2'b0;
			i_id = pc;
			opCode = i_datain;
			stall_o = 1'b0;
		end else if(busy == 1'b0) begin
			rw_flag = 2'b1;
			i_id = pc;
			opCode = i_datain;
			stall_o = 1'b1;
		end else begin
			rw_flag = 2'b1;
			i_id = 32'b0;
			opCode = {25'b0, `OP_IMM};
			stall_o = 1'b1;
		end
	end
endmodule
