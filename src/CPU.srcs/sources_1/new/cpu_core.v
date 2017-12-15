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


module CPU_Core(clk, enable, rst, i_datain, d_datain, i_addr, d_addr, d_dataout
    );

	input clk,
	input enable,
	input rst,
    input [XLEN-1:0] i_datain,
    input [XLEN-1:0] d_datain,
    output [XLEN-1:0] i_addr,
    output [XLEN-1:0] d_addr,
    output [XLEN-1:0] d_dataout

	reg state;
	reg [XLEN-1:0] rf[31:0];
	reg [XLEN-1:0] pc;

	CPU_IF IF(rst,  );
	CPU_ID ID(rst,);
	CPU_EX EX(rst,);
	CPU_MEM MEM(rst,);
	CPU_WB WB(rst,);



	/*CPU Control*/
	always @(posedge clk) begin
		if (!rst)
			state <= `idle;
		else
			state <= next_state;
	end
	always @(*) begin
		case (state)
			`idle :
				if ((enable == 1'b1)
						&& (start == 1'b1))
					next_state <= `exec;
				else
					next_state <= `idle;
			`exec :
				if ((enable == 1'b0)
						|| (wb_ir[15:11] == `HALT))
					next_state <= `idle;
				else
					next_state <= `exec;
		endcase
	end



endmodule
