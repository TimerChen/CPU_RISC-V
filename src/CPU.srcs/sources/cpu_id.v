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

	rd0, rd1, imm,

	//locked?
	lkd0, lkd1,
	//stall Request
	stall_o
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

	output reg stall_o;
	input wire lkd0, lkd1;

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
					imm   <= {{21{opCode_i[31]}}, opCode_i[7], opCode_i[30:25], opCode_i[11:8], 1'b0};
				end
				`LOAD: begin
					wrIs  <= `True;
					wr    <= opCode_i[11: 7];
					r0    <= opCode_i[19:15];
					r1    <= 5'd0;
					r0_is <= `True;
					r1_is <= `False;
					imm   <= {{21{opCode_i[31]}}, opCode_i[30:20]};
					if(`DEBUG == 1'b1)	$display("[ID]LOAD rd0:%d", opCode_i[19:15]);
				end
				`STORE: begin
					wrIs  <= `False;
					wr    <= 5'd0;
					r0    <= opCode_i[19:15];
					r1    <= opCode_i[24:20];
					r0_is <= `True;
					r1_is <= `True;
					imm   <= {{21{opCode_i[31]}}, opCode_i[30:25], opCode_i[11:7]};
				end
				`OP_IMM: begin
					wrIs  <= `True;
					wr    <= opCode_i[11: 7];
					r0    <= opCode_i[19:15];
					r1    <= 5'b0;
					r0_is <= `True;
					r1_is <= `False;
					imm   <= {{21{opCode_i[31]}}, opCode_i[30:20]};
				end
				`OP: begin
					wrIs  <= `True;
					wr    <= opCode_i[11: 7];
					r0    <= opCode_i[19:15];
					r1    <= opCode_i[24:20];
					r0_is <= `True;
					r1_is <= `True;
					imm   <= {{16{opCode_i[31]}},opCode_i[30:25]};
				end
				//`MISC_MEM: begin end
				default: begin
					r0     <= 32'b0;
					r1     <= 32'b0;
					r0_is  <= `False;
					r1_is  <= `False;
					opCode <= `OP_IMM;
					opType <= 3'b0;
					wrIs   <= 1'b0;
					wr     <= 32'b0;
					imm    <= 32'd0;
				end
			endcase
		end
	end

	//Get rd0 & rd1
	always @ ( * ) begin
		if (rst == `True) begin
			rd0     <= 32'b0;
			rd1     <= 32'b1;
			stall_o <= `False;
		end else begin
			case (opCode_i[6:0])
				`LUI, `AUIPC, `JAL: begin
					rd0     <= imm;
					rd1     <= 32'd0;
					stall_o <= `False;
				end
				`JALR, `LOAD, `OP_IMM: begin
					if(`DEBUG == 1'b1)	$display("[ID] lkd0: %d, ?=%d",lkd0, lkd0==`False);
					if(lkd0 == `False) begin
						rd0     <= rd0_i;
						rd1     <= imm;
						stall_o <= `False;
					end else begin
						stall_o <= `True;
					end
				end
				`BRANCH, `STORE, `OP: begin
					if(lkd0 == `False && lkd1 == `False) begin
						rd0     <= rd0_i;
						rd1     <= rd1_i;
						stall_o <= `False;
						if(`DEBUG == 1'b1)	$display("[ID]STORE/BRANCH/OP: (%d, %d)->(%d, %d)", rd0_i, rd1_i, rd0, rd1 );
					end else begin
						stall_o <= `True;
					end
				end
				default: begin
					stall_o <= `False;
				end
			endcase


		end
	end
	//Get rd1
endmodule
