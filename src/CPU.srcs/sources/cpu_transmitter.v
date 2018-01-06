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
module CPU_IDTrans(
	clk, rst, stall,

	i_id, opCode,
	i_id_o, opCode_o

	);
	input wire 		    clk, rst;
	input wire [3  : 0] stall;
	input wire [31 : 0] i_id, opCode;
	output reg [31 : 0] i_id_o, opCode_o;

	always @(posedge clk) begin
		if (rst == `True || (stall[1]!=`True&&stall[0]==`True)) begin
			i_id_o   <= 32'b0;
			opCode_o <= {25'b0,`OP_IMM};
		end else if(stall[1] != `True) begin
			i_id_o   <= i_id;
			opCode_o <= opCode;
		end
	end


endmodule

module CPU_EXTrans (
	clk, rst, stall,

	i_id, i_id_o,

	wrIs, wr,
	opCode, opType,
	rd0, rd1, imm,

	wrIs_o, wr_o,
	opCode_o, opType_o,
	rd0_o, rd1_o, imm_o
	);
	input wire 		    clk, rst;
	input wire [3  : 0] stall;

	input wire [31 : 0] i_id;
	output reg [31 : 0] i_id_o;

	input wire 			wrIs;
	input wire [ 4 : 0] wr;
	input wire [ 6 : 0] opCode;
	input wire [ 2 : 0] opType;
	input wire [31 : 0] rd0, rd1, imm;

	output reg          wrIs_o;
	output reg [ 4 : 0] wr_o;
	output reg [ 6 : 0] opCode_o;
	output reg [ 2 : 0] opType_o;
	output reg [31 : 0] rd0_o, rd1_o, imm_o;

	always @ ( posedge clk ) begin
		if (rst == `True || (stall[2]!=`True&&stall[1]==`True)) begin
			i_id_o   <= 5'b0;
			wrIs_o   <= `False;
			wr_o     <= 4'b0;
			opCode_o <= `OP_IMM;
			opType_o <= `ADDI;
			rd0_o    <= 32'b0;
			rd1_o    <= 32'b0;
			imm_o    <= 32'b0;
		end else if(!stall[2]) begin
			i_id_o   <= i_id;
			wrIs_o   <= `True;
			wr_o     <= wr;
			opCode_o <= opCode;
			opType_o <= opType;
			rd0_o    <= rd0;
			rd1_o    <= rd1;
			imm_o    <= imm;
		end
	end

endmodule // CPU_EXTrans

module CPU_MEMTrans (
	clk, rst, stall,

	i_id, i_id_o,

	opCode, opType,
	wrIs, wr, wrData,
	rd0, rd1, imm,

	opCode_o, opType_o,
	wrIs_o, wr_o, wrData_o,
	rd0_o, rd1_o, imm_o
	);
	input wire 		    clk, rst;
	input wire [3  : 0] stall;

	input wire [ 31:0] i_id;
	output reg [ 31:0] i_id_o;

	input wire        wrIs;
	input wire [ 4:0] wr;
	input wire [31:0] wrData;
	input wire [ 6:0] opCode;
	output reg [ 6:0] opCode_o;
	input wire [ 2:0] opType;
	output reg [ 2:0] opType_o;
	input wire [31:0] rd0, rd1, imm;


	output reg 		  wrIs_o;
	output reg [ 4:0] wr_o;
	output reg [31:0] wrData_o;
	output reg [31:0] rd0_o, rd1_o, imm_o;

	always @ ( posedge clk ) begin
		if (rst == `True || (stall[3]!=`True&&stall[2]==`True)) begin
			i_id_o   <= 5'b0;
			wrIs_o   <= `False;
			wr_o     <= 4'b0;
			wrData_o <= 32'b0;
			opCode_o <= `OP_IMM;
			opType_o <= `ADDI;
			rd0_o    <= 32'd0;
			rd1_o    <= 32'd0;
			imm_o    <= 32'd0;
		end else if(!stall[3]) begin
			i_id_o   <= i_id;
			wrIs_o   <= wrIs;
			wr_o     <= wr;
			wrData_o <= wrData;
			opCode_o <= opCode;
			opType_o <= opType;
			rd0_o    <= rd0;
			rd1_o    <= rd1;
			imm_o    <= imm;
			if(opCode == `STORE && opType == 3'b000 && wrData == 'h104 && `DEBUG == 1'b0)
				//$write("%c",rd1);
				$display("%d",rd1);
		end
	end


endmodule // CPU_MEMTrans
