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
module CPU_EX(
	clk, rst, state, stall,

	i_id, i_id_o,

	wrIs, wr,
	opCode, opType,
	rd0, rd1, imm,

	wrIs_o, wr_o, wrData_o,
	wPcIs_o, wPcData_o,
	opCode_o, opType_o,
	rd0_o, rd1_o, imm_o,

	clear,
	lk_o

	);
	input wire clk, rst, state, stall;

	input wire [31 : 0] i_id;
	output reg [31 : 0] i_id_o;

	input wire 			wrIs;
	input wire [ 4 : 0] wr;
	input wire [ 6 : 0] opCode;
	input wire [ 2 : 0] opType;
	input wire [31 : 0] rd0, rd1, imm;

	output reg          wrIs_o;
	output reg [ 4 : 0] wr_o;
	output reg [31 : 0] wrData_o;
	output reg 			wPcIs_o;
	output reg [31 : 0]	wPcData_o;
	output reg [ 6 : 0] opCode_o;
	output reg [ 2 : 0] opType_o;
	output reg [31 : 0] rd0_o, rd1_o, imm_o;

	output reg clear, lk_o;

	reg tmp0, tmp1, tmpOut, jumpFlag;



	always @( * ) begin
		if (rst == `True) begin
			i_id_o    <= 5'b0;

			wrIs_o    <= `False;
			wr_o      <= 4'b0;
			wrData_o  <= 32'b0;
			opCode_o  <= 7'b0;
			opType_o  <= 3'b0;
			rd0_o     <= 32'b0;
			rd1_o     <= 32'b0;
			imm_o     <= 32'b0;
			wPcIs_o   <= 1'b0;
			wPcData_o <= 32'b0;

			clear     <= 1'b0;
			lk_o      <= `False;
		end	else if (stall != `True) begin
			i_id_o   <= i_id;
			opCode_o <= opCode;
			opType_o <= opType;
			wrIs_o   <= wrIs;
			wr_o     <= wr;
			rd0_o    <= rd0;
			rd1_o    <= rd1;
			imm_o    <= imm;

			case (opCode)
			`LUI: begin
				wrData_o  <= imm;
				wPcIs_o   <= 1'b0;
				wPcData_o <= 32'b0;
				clear     <= `False;
			end
			`AUIPC: begin
				wrData_o  <= i_id + imm;
				wPcIs_o   <= 1'b0;
				wPcData_o <= 32'b0;
				clear     <= `False;
			end
			`JAL: begin
				wrData_o  <= i_id + 4;
				wPcIs_o   <= `True;
				wPcData_o <= imm + i_id;
				clear     <= `True;
			end
			`JALR: begin
				wrData_o  <= i_id + 4;
				wPcIs_o   <= `True;
				wPcData_o <= (rd0 + imm) & (-1 ^ 1);
				clear     <= `True;
			end
			`BRANCH: begin
				case (opType)
				`BEQ:
					jumpFlag = (rd0 == rd1) ? 1'b1 : 1'b0;
				`BNE:
					jumpFlag = (rd0 != rd1) ? 1'b1 : 1'b0;
				`BLT:
					jumpFlag = ($signed(rd0) < $signed(rd1)) ? 1'b1 : 1'b0;
				`BGE:
					jumpFlag = ($signed(rd0) >= $signed(rd1)) ? 1'b1 : 1'b0;
				`BLTU:
					jumpFlag = ($unsigned(rd0) < $unsigned(rd1)) ? 1'b1 : 1'b0;
				`BGEU:
					jumpFlag = ($unsigned(rd0) >= $unsigned(rd1)) ? 1'b1 : 1'b0;
				default:
					jumpFlag = 1'b0;
				endcase
				if(`DEBUG == 1'b1)	$display("select jump? %d %d", rd0, rd1);
				if (jumpFlag == 1'b1) begin
					wPcIs_o   <= `True;
					wPcData_o <= i_id + imm;
					clear     <= `True;
				end else begin
					if(`DEBUG == 1'b1)	$display("no jump!");
					wPcIs_o   <= `False;
					wPcData_o <= i_id + 4;
					clear     <= `False;
				end
			end

			`LOAD: begin
				wPcIs_o   <= 1'b0;
				wPcData_o <= 32'b0;
				clear     <= `False;
				wrData_o  <= rd0 + imm;
				if(`DEBUG == 1'b1)	$display("[MEM]LOAD Addr:%d %d", rd0, imm);
			end
			`STORE: begin
				wPcIs_o   <= 1'b0;
				wPcData_o <= 32'b0;
				clear     <= `False;
				wrData_o  <= rd0 + imm;
			end
			`OP_IMM: begin
				wPcIs_o   <= 1'b0;
				wPcData_o <= 32'b0;
				clear     <= `False;
				case (opType)
				`ADDI: begin
					wrData_o <= rd0 + rd1;
				end
				`SLTI: begin
					wrData_o <= $signed(rd0) < $signed(rd1) ? 32'b1 : 32'b0;
				end
				`SLTIU: begin// ????
					wrData_o <= $unsigned(rd0) < $unsigned(rd1) ? 32'b1 : 32'b0;
				end
				`XORI: begin
					wrData_o <= rd0 ^ rd1;
				end
				`ORI: begin
					wrData_o <= rd0 | rd1;
				end
				`ANDI: begin
					wrData_o <= rd0 & rd1;
				end
				`SLLI: begin
					wrData_o <= rd0 << rd1[4:0];
				end
				`SRLI: begin //SRLI && SRAI
					if (imm[10] == 0)
						//SRLI
						wrData_o <= rd0 >> rd1[4:0];
					else
						//SRAI
						wrData_o <= (rd0 >> rd1[4:0]) | ({32{rd0[31]}} << (6'd32 - {1'b0, rd1[4:0]}));
				end
				default: ;
				endcase
			end
			`OP: begin
				wPcIs_o   <= 1'b0;
				wPcData_o <= 32'b0;
				clear <= `False;
				case (opType)
				`ADD: begin //ADD & SUB
					if (imm[5] == 0)
						//ADD
						wrData_o <= rd0 + rd1;
					else
						//SUB
						wrData_o <= rd0 - rd1;
				end
				`SLT: begin
					wrData_o <= $signed(rd0) < $signed(rd1) ? 32'b1 : 32'b0;
				end
				`SLTU: begin// ????
					wrData_o <= $unsigned(rd0) < $unsigned(rd1) ? 32'b1 : 32'b0;
				end
				`XOR: begin
					wrData_o <= rd0 ^ rd1;
				end
				`SLL: begin
					wrData_o <= rd0 << rd1[4:0];
				end
				`SRL: begin //SRL && SRA
					if (imm[5] == 0)
						//SRL
						wrData_o <= rd0 >> rd1[4:0];
					else
						//SRA
						wrData_o <= (rd0 >> rd1[4:0]) | ({32{rd0[31]}} << (6'd32 - {1'b0, rd1[4:0]}));
				end
				`OR: begin
					wrData_o <= rd0 | rd1;
				end
				`AND: begin
					wrData_o <= rd0 & rd1;
				end
				default: ;
				endcase
			end
			`MISC_MEM: begin
				wPcIs_o   <= 1'b0;
				wPcData_o <= 32'b0;
				clear <= `False;

			end
			default: ;
			endcase
			if (opCode != `LOAD)
				lk_o = `False;
			else
				lk_o = `True;
		end
	end

endmodule
