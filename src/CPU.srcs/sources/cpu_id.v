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
	clk, rst, stall,

	i_id, opCode_i, i_id_o,

	//

	r0, r1,
	r0_is, r1_is,

	opCode, opType,
	wrIs, wr,

	//

	rd0_i, rd1_i,

	rd0, rd1, imm
	);
	input wire 		     clk, rst, stall;
	input wire [ 31 : 0] i_id;
	output reg [ 31 : 0] i_id_o;
	input wire [ 31 : 0] opCode_i;

	output reg [ 4 : 0] r0, r1;
	output reg 		  	r0_is, r1_is;
	output reg [ 6 : 0] opCode;
	output reg [ 2 : 0] opType;
	output reg       	wrIs;
	output reg [ 4 : 0] wr;


	input wire [31 : 0] rd0_i, rd1_i;
	output reg [31 : 0] rd0, rd1;
	output reg [31 : 0] imm;

	//Translate Code
	always @( * ) begin
		if (rst == `True) begin
			i_id_o <= 5'b0;
			r0     <= 5'b0;
			r1     <= 5'b0;
			opCode <= `OP_IMM;
			opType <= 3'b0;
			wrIs   <= `False;
			wr     <= 32'b0;
			r0_is  <= `False;
			r1_is  <= `False;
			rd0    <= 32'b0;
			rd1    <= 32'b0;
			imm    <= 32'b0;
		end	else if(stall != `True) begin
			i_id_o <= i_id;
			opCode <= opCode_i[ 6: 0];
			opType <= opCode_i[14:12];
			case (opCode_i[6:0])
				`LUI: begin
					wrIs  <= `True;
					wr    <= opCode_i[11: 7];
					r0    <= 5'b0;
					r1    <= 5'b0;
					r0_is <= `False;
					r1_is <= `False;
					imm   <= {opCode_i[31:12], 12'b0};
				end
				`AUIPC: begin
					wrIs  <= `True;
					wr    <= opCode_i[11: 7];
					r0    <= 5'b0;
					r1    <= 5'b0;
					r0_is <= `False;
					r1_is <= `False;
					imm   <= {opCode_i[31:12], 12'b0};
				end
				`JAL: begin
					wrIs  <= `True;
					wr    <= opCode_i[11: 7];
					r0    <= 5'd0;
					r1    <= 5'd0;
					r0_is <= `False;
					r1_is <= `False;
					imm   <= {{12{opCode_i[31]}}, opCode_i[19:12], opCode_i[20], opCode_i[30:25], opCode_i[24:21], 1'b0};
				end
				`JALR: begin
					wrIs  <= `True;
					wr    <= opCode_i[11: 7];
					r0    <= opCode_i[19:15];
					r1    <= 5'b0;
					r0_is <= `True;
					r1_is <= `False;
					imm   <= {{21{opCode_i[31]}}, opCode_i[30:20]};
				end
				`BRANCH: begin
					wrIs  <= `False;
					wr    <= 5'b0;
					r0    <= opCode_i[19:15];
					r1    <= opCode_i[24:20];
					r0_is <= `True;
					r1_is <= `True;
					imm <= {{21{opCode_i[31]}}, opCode_i[7], opCode_i[30:25], opCode_i[11:8], 1'b0};
				end

				`LOAD: begin

					imm <= {{21{opCode_i[31]}}, opCode_i[30:20]};
				end
				`STORE: begin
					wrIs  <= `False;
					wr    <= opCode_i[11: 7];
					r0    <= opCode_i[19:15];
					r1    <= 5'b0;
					r0_is <= `True;
					r1_is <= `False;
					imm   <= {{21{opCode_i[31]}}, opCode_i[30:25], opCode_i[11:7]};
				end
				`OP_IMM: begin
					/*
					if (`DEBUG == `True)
						$display("ID: OP_IMM");*/
					wrIs  <= `True;
					wr    <= opCode_i[11: 7];
					r0    <= opCode_i[19:15];
					r1    <= 5'b0;
					r0_is <= `True;
					r1_is <= `False;
					imm   <= {{21{opCode_i[31]}}, opCode_i[30:20]};
				end
				`OP: begin
					if (`DEBUG == `True)
						$display("ID: OP");
					wrIs  <= `True;
					wr    <= opCode_i[11: 7];
					r0    <= opCode_i[19:15];
					r1    <= opCode_i[24:20];
					r0_is <= `True;
					r1_is <= `True;
					imm   <= {{16{opCode_i[31]}},opCode_i[30:25]};
				end
				`MISC_MEM: begin

				end
				default: begin
					r0     <= 32'b0;
					r1     <= 32'b0;
					opCode <= `OP_IMM;
					opType <= 3'b0;
					wrIs   <= 1'b0;
					wr     <= 32'b0;
				end
			endcase
		end
	end

	//Get rd0 & rd1
	always @ ( * ) begin
		if (rst == `True) begin
			rd0 <= 32'b0;
			rd1 <= 32'b1;
		end else begin
			case (opCode_i[6:0])
				`LUI: begin
					rd0 <= imm;
					rd1 <= 32'd0;
				end
				`AUIPC: begin
					rd0 <= imm;
					rd1 <= 32'd0;
				end
				`JAL: begin
					rd0 <= imm;
					rd1 <= 32'd0;
				end
				`JALR: begin
					rd0 <= rd0_i;
					rd1 <= imm;
				end
				`BRANCH: begin
					rd0 <= rd0_i;
					rd1 <= rd1_i;
				end
				`OP_IMM: begin
					rd0 <= rd0_i;
					if (r1_is == `True)
						rd1 <= rd1_i;
					else
						rd1 <= imm;
				end
				`OP: begin
					rd0 <= rd0_i;
					if (r1_is == `True)
						rd1 <= rd1_i;
					else
						rd1 <= imm;
				end
			endcase


		end
	end
	//Get rd1
endmodule
