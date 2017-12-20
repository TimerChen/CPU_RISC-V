`timescale 1ns / 1ps
`include "../sources/def.v"
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2017/12/16 20:53:06
// Design Name:
// Module Name: test0
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


module test0();

	reg clk,rst;
	reg stopFlag;
	Top top(
	    	.clk(clk),
	    	.rst(rst));
    initial begin
		/*
		{top.cpu.iCache.inst[ 0],
    	top.cpu.iCache.inst[ 1],
    	top.cpu.iCache.inst[ 2],
    	top.cpu.iCache.inst[ 3]} <=
    		//{12'd3, 5'd1, `ADDI, 5'd2, `OP_IMM };
			32'h93600021;*/
		$readmemh("insts.mem",	top.cpu.iCache.inst);
    	clk = 1'b0;
    	stopFlag = 1'b0;
    	forever begin
			if(stopFlag == `False) begin
				#50 clk = 1'b1;
	    		#50 clk = 1'b0;
			end else begin
				#50;
			end
    	end
    end
	reg [31:0] count;
	reg [31:0] i;
	always @( posedge clk ) begin
		if (rst == `True) begin
			count <= 0;
		end else begin
			if(count == 30) begin
				stopFlag = 1'b1;
				$display("end");
				#200;
				for(i=0;i<32;i=i+1) begin
					$display("regs[%d] = %d",i ,top.cpu.regFile.regs[i]);
				end
				$stop;
			end
			$display("[Clock]: %d",count );
			count <= count + 1;
		end
	end
    initial begin
    	rst = 1'b1;
    	#200 rst = 1'b0;

    end
endmodule
