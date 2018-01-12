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

	wrIs_o, wr_o, wrData_o,

	stall_o,
	cacheMiss, cacheReady,


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

	output reg [ 1:0] memIs;
	output reg [ 3:0] memType;
	output reg [31:0] memData_o, memAdd;

	input wire [31:0] memData_i;

	output reg 		  wrIs_o;
	output reg [ 4:0] wr_o;
	output reg [31:0] wrData_o;

	input wire cacheMiss, cacheReady;
	output reg stall_o;

	always @( * ) begin
		wrIs_o   = `False;
		wr_o     = 1'b0;
		wrData_o = 32'b0;

		memIs     = 2'b0;
		memType   = 4'b0;
		memAdd    = 32'b0;
		memData_o = 32'b0;

		i_id_o = i_id;
		opCode_o = opCode;
		opType_o = opType;
		if (rst == `True) begin
			i_id_o   = 5'b0;
			wrIs_o   = `False;
			wr_o     = 4'b0;
			wrData_o = 32'b0;
			opCode_o = 7'b0;
			opType_o = 3'b0;
			stall_o = 1'b0;
		end	else if ( cacheReady == 1'b1 ) begin
			stall_o = 1'b0;
			case (opCode)
				`LOAD: begin
				wrIs_o   = `True;
				wr_o = wr;
				case (memType[2:0])
					3'b000: begin
						//8-bit
						case(wrData[1:0])
							0:
								wrData_o = {{24{memData_i[7]}}, memData_i[7:0]};
							1:
								wrData_o = {{24{memData_i[15]}}, memData_i[15:8]};
							2:
								wrData_o = {{24{memData_i[23]}}, memData_i[23:16]};
							3:
								wrData_o = {{24{memData_i[31]}}, memData_i[31:24]};
							default:
								wrData_o = 32'd0;
						endcase
					end
					3'b001: begin
						//16-bit
						case(wrData[1:0])
							0:
								wrData_o = {{16{memData_i[15]}}, memData_i[15:0]};
							1:
								wrData_o = {{16{memData_i[23]}}, memData_i[23:8]};
							2:
								wrData_o = {{16{memData_i[31]}}, memData_i[31:16]};
							default:
								wrData_o = 32'd0;
						endcase
					end
					3'b010: begin
						//32-bit
						wrData_o = memData_i;
					end
					3'b100: begin
						//8-bit unsigned
						wrData_o = (memData_i >> (wrData[1:0]*8)) & 32'h000000ff;

					end
					3'b101: begin
						//16-bit unsigned
						wrData_o = (memData_i >> (wrData[1:0]*8)) & 32'h0000ffff;
					end
					default:
						wrData_o = 32'd0;
				endcase
				end
				default: begin//STORE
					;
				end
			endcase
		end else if( cacheMiss == 1'b0 ) begin //!busy
			case (opCode)
				`LOAD: begin
					if(`DEBUG == 1'b1)	$display("[MEM]load");
					memIs     = 2'b1;
					memType   = 4'b1111;
					memAdd    = {wrData[31:2],2'b0};
					memData_o = 32'b0;
					stall_o   = 1'b1;
				end
				`STORE: begin
					if(`DEBUG == 1'b1)	$display("[MEM]store");
					memIs	= 2'b10;
					case (memType[2:0])
						3'b000: begin
							//8-bit
							memType = (4'b0001 << wrData[1:0]);
						end
						3'b001: begin
							//16-bit
							memType = (4'b0011 << wrData[1:0]);
						end
						3'b010: begin
							//32-bit
							memType = 4'b1111;
						end
						default:
							memType = 4'b0000;
					endcase
					memAdd    = wrData;
					memData_o = rd1;
					stall_o   = 1'b1;
				end
				default: begin
					//$display("[MEM]default");

					wrIs_o   = `True;
					wr_o     = wr;
					wrData_o = wrData;
					stall_o  = 1'b0;
				end
			endcase
		end else begin
			stall_o = 1'b1;
		end

	end

endmodule
