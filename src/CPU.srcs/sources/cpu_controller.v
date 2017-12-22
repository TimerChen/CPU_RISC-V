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
module CPU_Controller(
		clk, rst,
		stall_i,
		rst_i,
		stall_o, rst_o
	);
	input wire clk, rst;
	input wire [3:0] stall_i, rst_i;
	output reg [3:0] stall_o, rst_o;

	always @ ( * ) begin
		//$display("Control %d %d %d", rst, stall_i, rst_i);
		if(rst == `True) begin
			stall_o <= 4'b0000;
			rst_o   <= 4'b1111;
		end else begin
			stall_o = 	 stall_i |
						(stall_i >> 1) |
						(stall_i >> 2) |
						(stall_i >> 3);

			rst_o <= 	/*((-stall_o) >> 1) |*/
						(
						 rst_i |
						(rst_i >> 1) |
						(rst_i >> 2) |
						(rst_i >> 3)
						);
		end
	end
endmodule
