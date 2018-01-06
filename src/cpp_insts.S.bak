	.file	"insts.c"
	.option nopic
	.text
	.align	2
	.globl	xmuly
	.type	xmuly, @function
#sp:x2	s0/fp:x8	ra:x1	a0:x10	a5:x15

#x1 = ram(47)
#x10 = 0
#x11 = 2
#x8 = x2 + 32 = 512
#x2=512-32=480
xmuly:
	addi	sp,sp,-32#x2 = 480-32 = 448
	sw	ra,28(sp)	#m476[+4] = x1 = ram(47)
	sw	s0,24(sp)	#m472[+4] = x8 = 512
	addi	s0,sp,32	#x8 = 448 + 32 = 480
	sw	a0,-20(s0)	#m460[+4] = a0 = x10 = 0
	sw	a1,-24(s0)	#m456[+4] = a1 = x11 = 2
	lw	a5,-20(s0)	#a5 = x15 = m460[+4] = 0
	bnez	a5,.L2	#(not jump)if (a5 != 0) goto .L2
	li	a5,1	#a5=1
	j	.L3		#just jump
.L2:	#return xmuly
	lw	a5,-20(s0)
	addi	a5,a5,-1
	lw	a1,-24(s0)
	mv	a0,a5
	call	xmuly
	mv	a4,a0
	lw	a5,-24(s0)
	add	a5,a4,a5
.L3:	#[328]return 0
	mv	a0,a5	#x10 = x15 = 1
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	xmuly, .-xmuly
	.align	2
	.globl	main
	.type	main, @function
main:
#sp:x2	s0/fp:x8	ra:x1	a0:x10	a5:x15
	addi	sp,sp,-32#x2=512-32=480
	sw	ra,28(sp)#m508[+4] = x2 = 8
	sw	s0,24(sp)#m504[+4] = x8 = 0
	addi	s0,sp,32#x8 = x2 + 32 = 512
	li	a1,2	#x11 = 2
	li	a0,0	#x10 = 0
	call	xmuly#1 = ram(47)
	sw	a0,-20(s0)
	lw	a5,-20(s0)
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 7.2.0"
