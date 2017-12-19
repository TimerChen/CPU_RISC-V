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
	clk, rst, state, stall,

	i_id, i_id_o,

	wrIs, wr, wrData,
	opCode, opType,
	rd0, rd1, imm,

	opCode_o, opType_o,

	memIs, memType,
	memData_o, memAdd,
	memData_i,

	wrIs_o, wr_o, wrData_o

	);

	input wire clk, rst, state, stall;

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

	output reg 		  memIs;
	output reg [ 3:0] memType;
	output reg [31:0] memData_o, memAdd;

	input wire [31:0] memData_i;

	output reg 		  wrIs_o;
	output reg [ 4:0] wr_o;
	output reg [31:0] wrData_o;



	always @(posedge clk) begin
		if (rst == `True) begin
			i_id_o   <= 5'b0;
			wrIs_o   <= `False;
			wr_o     <= 4'b0;
			wrData_o <= 32'b0;
			opCode_o <= 7'b0;
			opType_o <= 3'b0;
		end	else if (stall != `True) begin
			$display("[MEM]0");
			opCode_o <= opCode;
			opType_o <= opType;
			case (opCode)
				`LOAD: begin
					$display("[MEM]load");
					memIs     <= `True;
					memType   <= {1'b0, opType};
					memAdd    <= rd0;
					memData_o <= 32'b0;
				end
				`STORE: begin
					$display("[MEM]store");
					memIs     <= `True;
					memType   <= {1'b1, opType};
					memAdd    <= rd0;
					memData_o <= rd1;
				end
				default: begin
					$display("[MEM]default");
					memIs     <= `False;
					memType   <= 4'b0;
					memAdd    <= 32'b0;
					memData_o <= 32'b0;
					wrIs_o    <= wrIs;
					wr_o      <= wr;
					wrData_o  <= wrData;
				end
			endcase
		end
	end


	always @ ( * ) begin
		if (rst == `True) begin
			wr_o     <= 1'b0;
			wrData_o <= 32'b0;
		end	else if (stall != `True) begin
			if (opCode == `LOAD) begin
				wrIs_o   <= `True;
				wr_o     <= wr;
				wrData_o <= memData_i;
			end
		end
	end
endmodule
