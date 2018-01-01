#Test for op & op_imm
.org 0x0
 	.global _start
_start:
	addi x1, x0, 0x1 #0x0
	addi x2, x0, 0x2
	addi x3, x0, 255
	sw	 x3, 0(x1)
	sb	 x3, 2(x1)
	lh	 x4, 0(x2)
	add	 x5, x4, x0
	lhu	 x4, 0(x2)
	add	 x6, x4, x0
	sh	 x3, 1(x1)
#final loop
loop:
	nop
	j loop
