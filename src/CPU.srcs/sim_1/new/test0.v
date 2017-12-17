`timescale 1ns / 1ps
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
	
	Top top(
	    	.clk(clk), 
	    	.rst(rst));
    initial begin
    	clk = 1'b0;
    	forever #50 clk = ~clk;
    end
    
    initial begin
    	rst = 1'b1;
    	#195 rst = 1'b0;
    	#200 $stop;
    end
endmodule
