#Test for op & op_imm
.org 0x0
 	.global _start
_start:
	addi x1, x1, 1
	addi x2, x0, 3
	bne x1, x2, _start
	ori x3, x0, 0x210 # x1 = h210
	nop
	nop
	nop
	nop
