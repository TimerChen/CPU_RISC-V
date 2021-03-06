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


module RegFile (
	clk, rst, we,
	rr0, rr1, rd0, rd1,

	//lock regs signs
	lk0,

	//regs locked output
	lkd0, lkd1,

	wr0Is,
	wr0, wd0,
	wr1Is,
	wr1, wd1
	);
	input wire 			clk, rst, we;
	input wire [4  : 0] rr0, rr1;
	output reg [31 : 0] rd0, rd1;

	input wire lk0;
	output reg lkd0, lkd1;

	input wire 			wr0Is, wr1Is;
	input wire [4  : 0] wr0, wr1;
	input wire [31 : 0] wd0, wd1;

	reg [31 : 0] regs [31:0];

	//read0
	always @(*) begin
		if (rst == `True) begin
			rd0  <= 32'd0;
			lkd0 <= `False;
		end else begin
			if (rr0 == 5'd0) begin
				lkd0 <= `False;
				rd0 <= 32'd0;
			//wr0 == lr0
			end else if ({lk0, wr0} == {1'b1, rr0}) begin
				lkd0 <= `True;
			end else if (wr0Is == `True && rr0 == wr0) begin
				lkd0 <= `False;
				rd0  <= wd0;
			end else if (wr1Is == `True && rr0 == wr1) begin
				lkd0 <= `False;
				rd0  <= wd1;
			end else begin
				lkd0 <= `False;
				rd0  <= regs[rr0];
			end
		end
	end

	//read1
	always @(*) begin
		if (rst == `True) begin
			rd1  <= 32'd0;
			lkd1 <= `False;
		end else begin
			if (rr1 == 5'd0) begin
				lkd1 <= `False;
				rd1  <= 32'd0;
			end else if ({lk0, wr0} == {1'b1, rr1}) begin
				lkd1 <= `True;
			end else if (wr0Is == `True && rr1 == wr0) begin
				lkd1 <= `False;
				rd1  <= wd0;
			end else if (wr1Is == `True && rr1 == wr1) begin
				lkd1 <= `False;
				rd1  <= wd1;
			end else begin
				lkd1 <= `False;
				rd1  <= regs[rr1];
			end
		end
	end
	//write
	always @(posedge clk) begin
		if ( rst == `True ) begin
			regs[0]  <= 32'b0;
			regs[1]  <= 32'b0;
			regs[2]  <= 32'b0;
			regs[3]  <= 32'b0;
			regs[4]  <= 32'b0;
			regs[5]  <= 32'b0;
			regs[6]  <= 32'b0;
			regs[7]  <= 32'b0;
			regs[8]  <= 32'b0;
			regs[9]  <= 32'b0;
			regs[10] <= 32'b0;
			regs[11] <= 32'b0;
			regs[12] <= 32'b0;
			regs[13] <= 32'b0;
			regs[14] <= 32'b0;
			regs[15] <= 32'b0;
			regs[16] <= 32'b0;
			regs[17] <= 32'b0;
			regs[18] <= 32'b0;
			regs[19] <= 32'b0;
			regs[20] <= 32'b0;
			regs[21] <= 32'b0;
			regs[22] <= 32'b0;
			regs[23] <= 32'b0;
			regs[24] <= 32'b0;
			regs[25] <= 32'b0;
			regs[26] <= 32'b0;
			regs[27] <= 32'b0;
			regs[28] <= 32'b0;
			regs[29] <= 32'b0;
			regs[30] <= 32'b0;
			regs[31] <= 32'b0;
		end else if ( we == `True ) begin
			/*
			if (wr0 != 5'd0)
				regs[wr0] <= wd0;
			if ((wr1 != 5'd0) && (wr1 != wr0))
				regs[wr1] <= wd1;
			*/
			if (wr1Is == `True && wr1 != 5'd0)
				regs[wr1] <= wd1;
		end
	end
endmodule // RegFile
