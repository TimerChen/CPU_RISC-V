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

	wrIs_o, wr_o, wrData,
	opCode_o, opType_o,
	rd0_o, rd1_o, imm_o

	);
	input wire clk, rst, state, stall;

	input wire [ 31:0] i_id;
	output reg [ 31:0] i_id_o;

	input wire        wrIs;
	input wire [ 4:0] wr;
	input wire [ 6:0] opCode;
	input wire [ 2:0] opType;
	input wire [31:0] rd0, rd1, imm;

	output reg 		  wrIs_o;
	output reg [ 4:0] wr_o;
	output reg [31:0] wrData;
	output reg [ 6:0] opCode_o;
	output reg [ 2:0] opType_o;
	output reg [31:0] rd0_o, rd1_o, imm_o;

	reg tmp0, tmp1, tmpOut;



	always @(posedge clk) begin
		if (rst == `True) begin
			i_id_o <= 5'b0;

			wrIs_o <= `False;
			wr_o <= 4'b0;
			wrData <= 32'b0;
			opCode_o <= 7'b0;
			opType_o <= 3'b0;
			rd0_o <= 32'b0;
			rd1_o <= 32'b0;
			imm_o <= 32'b0;
		end	else if (stall != `True) begin
			opCode_o <= opCode;
			opType_o <= opType;
			wrIs_o	 <= wrIs;
			wr_o	 <= wr;
			rd0_o	 <= rd0;
			rd1_o	 <= rd1;
			imm_o	 <= imm;

			case (opCode)
			`LUI: begin

			end
			`AUIPC: begin


			end
			`JAL: begin

			end
			`JALR: begin


			end
			`BRANCH: begin

			end

			`LOAD: begin

			end
			`STORE: begin

			end
			`OP_IMM: begin

				case (opType)
					`ADDI: begin
						wrData <= rd0 + rd1;
					end
					`SLTI: begin
						wrData <= rd0 < rd1 ? 32'b1 : 32'b0;
					end
					`SLTIU: begin// ????
						wrData <= {1'b0, rd0} < {1'b0, rd1} ? 32'b1 : 32'b0;
					end
					`XORI: begin
						wrData <= rd0 ^ rd1;
					end
					`ORI: begin
						wrData <= rd0 | rd1;
					end
					`ANDI: begin
						wrData <= rd0 & rd1;
					end
					`SLLI: begin
						wrData <= rd0 << rd1[4:0];
					end
					`SRLI: begin //SRLI && SRAI
						if (imm[10] == 0)
							//SRLI
							wrData <= rd0 >> rd1[4:0];
						else
							//SRAI
							wrData <= (rd0 >> rd1[4:0]) | ({32{rd0[31]}} << (6'd32 - {1'b0, rd1[4:0]}));
					end
					default: ;
				endcase
			end
			`OP: begin
				case (opType)
					`ADD: begin //ADD & SUB
						if (imm[10] == 0)
							//ADD
							wrData <= rd0 + rd1;
						else
							//SUB
							wrData <= rd0 - rd1;
					end
					`SLT: begin
						wrData <= rd0 < rd1 ? 32'b1 : 32'b0;
					end
					`SLTU: begin// ????
						wrData <= {1'b0, rd0} < {1'b0, rd1} ? 32'b1 : 32'b0;
					end
					`XOR: begin
						wrData <= rd0 ^ rd1;
					end
					`SLL: begin
						wrData <= rd0 << rd1[4:0];
					end
					`SRL: begin //SRL && SRA
						if (imm[10] == 0)
							//SRL
							wrData <= rd0 >> rd1[4:0];
						else
							//SRA
							wrData <= (rd0 >> rd1[4:0]) | ({32{rd0[31]}} << (6'd32 - {1'b0, rd1[4:0]}));
					end
					`OR: begin
						wrData <= rd0 | rd1;
					end
					`AND: begin
						wrData <= rd0 & rd1;
					end
					default: ;
				endcase
			end
			`MISC_MEM: begin

			end
			default: ;
			endcase
		end
	end

	always @ ( * ) begin

	end
endmodule
