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
	clk, rst,

	memIs, memType,
	memData_o, memAdd,
	memData_i,

	miss, ready

	);

	input wire clk, rst;

	input wire 		  memIs;
	input wire [ 3:0] memType;
	input wire [31:0] memData_o, memAdd;

	output reg [31:0] memData_i;

	output reg miss, ready;


	reg [7:0] mem[0:1023];


	always @ ( * ) begin
		if (rst == `True) begin
			memData_i <= 32'd0;
			miss      <= 1'b0;
			ready     <= 1'b1;
		end	else if (memIs == `True) begin
			miss  <= 1'b0;
			ready <= 1'b1;
			if (memType[3] == 0) begin
				//LOAD
				case (memType[2:0])
					3'b000: begin
						//8-bit
						memData_i <= {{24{mem[memAdd][3]}}, mem[memAdd]};
					end
					3'b001: begin
						//16-bit
						memData_i <= {{16{mem[memAdd+1][3]}}, mem[memAdd+1], mem[memAdd]};
					end
					3'b010: begin
						//32-bit
						memData_i <= 	{mem[memAdd+3], mem[memAdd+2],
						 				 mem[memAdd+1], mem[memAdd  ]};
					end
					3'b100: begin
						//8-bit unsigned
						memData_i <= {24'd0, mem[memAdd]};
					end
					3'b101: begin
						//16-bit unsigned
						memData_i <= {16'd0, mem[memAdd+1], mem[memAdd]};
					end
					default: ;
				endcase

			end else begin
				//STORE
				case (memType[2:0])
					3'b000: begin
						//8-bit
						mem[memAdd] <= memData_o[7:0];
					end
					3'b001: begin
						//16-bit
						{mem[memAdd+1],mem[memAdd]} <= memData_o[15:0];
					end
					3'b010: begin
						//32-bit
						{mem[memAdd+3], mem[memAdd+2],
						 mem[memAdd+1], mem[memAdd  ]} <= memData_o;
					end
					default: ;
				endcase
			end

		end
	end
endmodule
