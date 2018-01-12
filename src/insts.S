#Test for op & op_imm
.org 0x0
 	.global _start
_start:
	ori x1, x0, 0x210 # x1 = h210
	ori x2, x1, 0x021 # x2 = h231
	xori x3, x0, 2 # x3 = 2
	add x4, x2, x1 # x4 = x2 + x1
	sub x5, x2, x1 # x5 = x2 - x1
	add x6, x4, x5 # x6 = x4 + x5
	srli x6, x6, 1 # x6 = x6 / 2
	sub x7, x5, x4 # x7 = x5 - x4
	add x7, x7, x7 # x7 = x7 + x7
	sra x7, x7, x3 # x7 = x7 / 4
	add x7, x7, x1 # x7 = x7 + x1 = 0
