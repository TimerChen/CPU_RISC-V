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
module DataCache(
	clk, rst, state, stall,

	memIs, memType,
	memData_o, memAdd,
	memData_i,

	);

	input wire clk, rst, state, stall;

	input wire 		  memIs;
	input wire [ 3:0] memType;
	input wire [31:0] memData_o, memAdd;

	output reg [31:0] memData_i;


	reg [7:0] mem[1023:0];


	always @ ( * ) begin
		if (rst == `True) begin

		end	else if (stall != `True && memIs == `True) begin
			if (memType[3] == 0) begin
				//LOAD
				case (memType[2:0])
					3'b000: begin
						//8-bit
						mem[memAdd] <= memData_o[7:0];
					end
					3'b001: begin
						//16-bit
						mem[memAdd] <= memData_o[15:0];
					end
					3'b010: begin
						//32-bit
						mem[memAdd] <= memData_o[31:0];
					end
					default: ;
				endcase
				memData <= mem[memAdd];
			end else begin
				//STORE
				case (memType[2:0])
					3'b000: begin
						//8-bit
						mem[memAdd] <= {{24{mem[memAdd]}}, mem[memAdd +: 8]};
					end
					3'b001: begin
						//16-bit
						mem[memAdd] <= {{16{mem[memAdd]}}, mem[memAdd +: 16]};
					end
					3'b010: begin
						//32-bit
						mem[memAdd] <= memData_o[31:0];
					end
					3'b100: begin
						//8-bit unsigned
						mem[memAdd] <= {24'd0, mem[memAdd +: 8]};
					end
					3'b101: begin
						//16-bit unsigned
						mem[memAdd] <= {16'd0, mem[memAdd +: 16]};
					end
					default: ;
				endcase
			end

		end
	end
endmodule
