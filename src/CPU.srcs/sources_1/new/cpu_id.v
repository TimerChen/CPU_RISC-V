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
module CPU_ID(
	clk, rst, state,

	i_id, opCode_i, i_id_o,

	//

	r0, r1,
	r0_is, r1_is,

	opCode, opType
	wr_is, wr

	//

	rd0_i, rd1_i,

	rd0, rd1, imm
	);
	input wire 		  clk, rst, state;
	input wire [ 4:0] i_id;
	output reg [ 4:0] i_id_o;
	input wire [31:0] opCode_i;

	output reg [ 4:0] r0, r1;
	output reg 		  r0_is, r1_is;
	output reg [ 6:0] opCode;
	output reg [ 2:0] opType;
	output reg        is_w;
	output reg [ 4:0] wr;


	input wire [31:0] rd0_i, rd1_i;
	output reg [31:0] rd0, rd1;
	output reg [31:0] imm;

	//Translate Code
	always @(posedge clk) begin
		if (rst == `True) begin
			i_id_o <= 5'b0;
			r0 <= 5'b0;
			r1 <= 5'b0;
			opCode <= `OP_IMM
			opType <= 3'b0;
			opSp <= 1'b0;
			is_w <= `False;
			wr <= 32'b0;
			r0_is <= `False;
			r1_is <= `False;

			imm <= 32'b0;
		end	else begin
			i_id_o <= i_id;
			opCode = opCode_i[ 6: 0];
			opType = opCode_i[14:12];
			case (opCode)
				`LUI: begin

					imm <= {opCode_i[31:12], 12'b0};
				end
				`AUIPC: begin


					imm <= {opCode_i[31:12], 12'b0};
				end
				`JAL: begin

					imm <= {{12{opCode_i[31]}}, opCode_i[19:12], opCode_i[20], opCode_i[30:25], opCode_i[24:21], 1'b0};
				end
				`JALR: begin


					imm <= {{21{opCode_i[31]}}, opCode_i[30:20]};
				end
				`BRANCH: begin

					imm <= {{21{opCode_i[31]}}, opCode_i[7], opCode_i[30:25], opCode_i[11:8], 1'b0};
				end

				`LOAD: begin

					imm <= {{21{opCode_i[31]}}, opCode_i[30:20]};
				end
				`STORE: begin
					is_w <= 'False;
					wd  <= opCode_i[11: 7];
					r0 <= opCode_i[19:15];
					r1 <= 5'b0;
					r0_is <= `True;
					r1_is <= `False;
					imm <= {{21{opCode_i[31]}}, opCode_i[30:25], opCode_i[11:7]}
				end
				`OP_IMM: begin
					is_w <= `True;
					wd  <= opCode_i[11: 7];
					r0 <= opCode_i[19:15];
					r1 <= 5'b0;
					r0_is <= `True;
					r1_is <= `False;
					imm <= {{21{opCode_i[31]}}, opCode_i[30:20]};
				end
				`OP: begin
					is_w <= `True;
					wd  <= opCode_i[11: 7];
					r0 <= opCode_i[19:15];
					r1 <= 5'b0;
					r0_is <= `True;
					r1_is <= `False;
					imm <= {opCode_i[31:12], 12'b0};
				end
				`MISC_MEM: begin

				end
				default: begin
					r0 <= 32'b0;
					r1 <= 32'b0;
					opcode <= `OP_IMM
					optype <= 3'b0;
					is_w <= 1'b0;
					wr <= 32'b0;
				end
			endcase
		end
	end

	//Get rd0 & rd1
	always @ ( * ) begin
		if (rst == `False) begin
			rd0 <= 32'b0;
			rd1 <= 32'b1;
		end else begin
			rd0 <= rd0_i;
			if (r1_is)
				rd1 <= rd1_i;
			else
				rd1 <= imm;
			end
		end
	end
	//Get rd1
endmodule
