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


module CPU_Core(
	clk, rst
    );

	input wire clk, rst;

	wire 		pc_writeIs;
	wire [31:0]	pc_writeData;

	reg state;
	wire 		ce;
	wire [31:0] pc;

	reg [ 4:0]	regReadReg0,regReadReg1,
				regWriteReg0, regWriteReg1;
	reg [31:0]	regReadData0, reaReadData1,
				regWriteData0, regWriteData1;
	wire [31:0]	if_inst, id_inst,
				id_instID, ex_instID;
	wire 		ex_rst_o;
	wire [3:0]	cStall_i, cRst_i, cStall_o, cRst_o;

	wire 		watingdCache, dCacheMiss, dCacheReady;
	wire 		watingiCache, iCacheMiss, iCacheReady;
	wire  		watingReg;
	wire [ 3:0] dCache_type;
	wire [31:0] dCache_writeData,
				dCache_writeAddr, dCache_readData;
	wire		dCache_is;


	assign cStall_i = {watingdCache, 1'b0, watingReg, watingiCache};
	assign cRst_i 	= {1'b0, ex_rst_o, 1'b0, 1'b0};

	CPU_Controller controller(
		.clk(clk), .rst(rst),
		.stall_i(cStall_i), .rst_i(cRst_i),
		.stall_o(cStall_o), .rst_o(cRst_o)
		);
	Reg_PC regpc(
		.clk(clk), .rst(rst), .stall(cStall_o[0]),
		.wIs(pc_writeIs),
		.pcIn(pc_writeData),
		.pc(pc),
		.ce(ce)
		);
	wire [ 4:0] rf_readReg0, rf_readReg1,
				mem_writeReg, out_writeReg;
	wire [31:0] id_regData0, id_regData1,
				mem_writeData, out_writeData;
	wire	   rf_readReg0Is, rf_readReg1Is,
				mem_writeRegIs, out_writeRegIs;
	wire 		ex_lk, id_lkd0, id_lkd1;

	wire [ 4:0] ex_WriteReg;
	wire [31:0] out_instID;
	RegFile regFile(
		.clk(clk),
		.rst(rst),
		.we(1'b1),

		.rr0(rf_readReg0), .rr1(rf_readReg1),
		.rd0(id_regData0), .rd1(id_regData1),

		//change lock info at start of next clock
		//.lr0(mem_writeReg),
		.lk0(ex_lk),

		.lkd0(id_lkd0), .lkd1(id_lkd1),

		.wr0Is(mem_writeRegIs),
		.wr0(mem_writeReg), .wd0(mem_writeData),
		.wr1Is(out_writeRegIs),
		.wr1(out_writeReg), .wd1(out_writeData)
		);
	InstCache iCache(
		.clk(clk), .rst(rst), .ce(ce), .stall(cStall_o[0]),
		.pc(pc),
		.instOut(if_inst),
		.stall_o(watingiCache)
		);

	DataCache dCache(
		.clk(clk), .rst(rst),

		.memIs(dCache_is), .memType(dCache_type),
		.memData_o(dCache_writeData), .memAdd(dCache_writeAddr),
		.memData_i(dCache_readData),

		.miss(dCacheMiss), .ready(dCacheReady)
		);
	CPU_IF IF(
		.clk(clk), .rst(rst), .stall(cStall_o[0]),
		.pc(pc),
		.i_datain(if_inst),
		.i_id(id_instID),
		.opCode(id_inst)
		);
	wire [ 6:0] ex_inst;
	wire [ 2:0] ex_instType;
	wire [31:0] ex_regData0, ex_regData1,
				ex_imm;
	wire		   ex_writeRegIs;

	wire [31:0]	id0_inst, id0_instID;
	CPU_IDTrans idTrans(
		.clk(clk), .rst(rst | cRst_o[1]), .stall(cStall_o),

		.i_id(id_instID), .opCode(id_inst),
		.i_id_o(id0_instID), .opCode_o(id0_inst)
		);

	CPU_ID ID(
		.clk(clk), .rst(rst), .stall(cStall_o[1]),

		.i_id(id0_instID), .opCode_i(id0_inst),
		.i_id_o(ex_instID),

		//

		.r0(rf_readReg0), .r1(rf_readReg1),
		.r0_is(rf_readReg0Is), .r1_is(rf_readReg1Is),

		.opCode(ex_inst), .opType(ex_instType),
		.wrIs(ex_writeRegIs), .wr(ex_WriteReg),

		//

		.rd0_i(id_regData0), .rd1_i(id_regData1),

		.rd0(ex_regData0), .rd1(ex_regData1), .imm(ex_imm),

		.lkd0(id_lkd0), .lkd1(id_lkd1),
		.stall_o(watingReg)
		);

	wire [ 6:0] mem_inst;
	wire [ 2:0] mem_instType;
	wire [31:0] mem_instID,
				mem_regData0, mem_regData1,
				mem_imm;

	wire [ 6:0] ex0_inst;
	wire [31:0] ex0_instID;
	wire [ 2:0] ex0_instType;
	wire [ 4:0] ex0_WriteReg;
	wire [31:0] ex0_regData0, ex0_regData1,
				ex0_imm;
	wire		ex0_writeRegIs;

	CPU_EXTrans exTrans(
		.clk(clk), .rst(rst | cRst_o[2]), .stall(cStall_o),

		.i_id(ex_instID), .i_id_o(ex0_instID),

		.wrIs(ex_writeRegIs), .wr(ex_WriteReg),
		.opCode(ex_inst), .opType(ex_instType),
		.rd0(ex_regData0), .rd1(ex_regData1), .imm(ex_imm),

		.wrIs_o(ex0_writeRegIs), .wr_o(ex0_WriteReg),
		.opCode_o(ex0_inst), .opType_o(ex0_instType),
		.rd0_o(ex0_regData0), .rd1_o(ex0_regData1), .imm_o(ex0_imm)
		);
	CPU_EX EX(
		.clk(clk), .rst(rst), .state(state), .stall(cStall_o[2]),

		.i_id(ex0_instID), .i_id_o(mem_instID),

		.wrIs(ex0_writeRegIs), .wr(ex0_WriteReg),
		.opCode(ex0_inst), .opType(ex0_instType),
		.rd0(ex0_regData0), .rd1(ex0_regData1), .imm(ex0_imm),

		.wrIs_o(mem_writeRegIs), .wr_o(mem_writeReg), .wrData_o(mem_writeData),
		.wPcIs_o(pc_writeIs), .wPcData_o(pc_writeData),
		.opCode_o(mem_inst), .opType_o(mem_instType),
		.rd0_o(mem_regData0), .rd1_o(mem_regData1), .imm_o(mem_imm),

		.clear(ex_rst_o), .lk_o(ex_lk)
		);



	wire [ 6:0] mem0_inst;
	wire [ 2:0] mem0_instType;
	wire [ 4:0] mem0_writeReg;
	wire [31:0] mem0_instID,
				mem0_regData0, mem0_regData1,
				mem0_imm,
				mem0_writeData;
	CPU_MEMTrans memTrans(
		.clk(clk), .rst(rst | cRst_o[3]), .stall(cStall_o),

		.i_id(mem_instID), .i_id_o(mem0_instID),

		.opCode(mem_inst), .opType(mem_instType),
		.wrIs(mem_writeRegIs), .wr(mem_writeReg), .wrData(mem_writeData),
		.rd0(mem_regData0), .rd1(mem_regData1), .imm(mem_imm),

		.opCode_o(mem0_inst), .opType_o(mem0_instType),
		.wrIs_o(mem0_writeRegIs), .wr_o(mem0_writeReg), .wrData_o(mem0_writeData),
		.rd0_o(mem0_regData0), .rd1_o(mem0_regData1), .imm_o(mem0_imm)
		);
	CPU_MEM MEM(
		.clk(clk), .rst(rst), .state(state), .stall(cStall_o[3]),

		.i_id(mem0_instID), .i_id_o(out_instID),

		.wrIs(mem0_writeRegIs), .wr(mem0_writeReg), .wrData(mem0_writeData),
		.opCode(mem0_inst), .opType(mem0_instType),
		.rd0(mem0_regData0), .rd1(mem0_regData1), .imm(mem0_imm),

		.memIs(dCache_is), .memType(dCache_type),
		.memData_o(dCache_writeData), .memAdd(dCache_writeAddr),
		.memData_i(dCache_readData),

		.wrIs_o(out_writeRegIs), .wr_o(out_writeReg), .wrData_o(out_writeData),

		.stall_o(watingdCache),
		.cacheMiss(dCacheMiss), .cacheReady(dCacheReady)

		);



endmodule
