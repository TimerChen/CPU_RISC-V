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
module CPU_MEM(
	clk, rst, state, stall

	i_id, i_id_o,

	wrIs, wr,
	opCode, opType,
	rd0, rd1, imm,

	memIs, memType,
	memData_o, memAdd,
	memData_i,

	wrIs_o, wr_o, wrData

	);

	input wire clk, rst, state, stall;

	input wire [ 4:0] i_id;
	output reg [ 4:0] i_id_o;

	input wire        wrIs;
	input wire [ 4:0] wr;
	input wire [ 6:0] opCode;
	input wire [ 2:0] opType;
	input wire [31:0] rd0, rd1, imm;

	output reg 		  memIs, memType;
	output reg [31:0] memData_o, memAdd;

	input wire [31:0] memData_i;

	output reg 		  wrIs_o;
	output reg [ 4:0] wr_o;
	output reg [31:0] wrData;



	always @(posedge clk) begin
		if (rst == `True) begin
			i_id_o <= 5'b0;
			wrIs_o <= `False;
			wr_o <= 4'b0;
			wrData <= 32'b0;
			opCode_o <= 7'b0;
			opType_o <= 3'b0;
		end	else if (stall != `True) begin
			case (opCode)
				`LOAD: begin
					memIs <= `True;
					memType <= {1'b0, opType};
					memAdd <= rd0;
					memData_o <= 32'b0;
				end
				`STORE: begin
					memIs <= `True;
					memType <= {1'b1, opType};
					memAdd <= rd0;
					memData_o <= rd1;
				end
				default: begin
					memIs <= `False;
					memType <= 4'b0;
					memAdd <= 32'b0;
					memData_o <= 32'b0;
				end
			endcase
		end
	end


	always @ ( * ) begin
		if (rst == `True) begin
			wr_o <= 1'b0;
			wrData <= 32'b0;
		end	else if (stall != `True) begin
			if (opCode == `LOAD) begin
				wrIs_o <= `True;
				wr_o <= wr;
				wrData <= memData_i;
			end else begin
				wrIs_o <= `False;
				wr_o <= 5'b0;
				wrData <= 32'b0;
			end
		end
	end
endmodule
