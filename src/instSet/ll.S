  .org 0x0
   .global _start
_start:
   ori  x3,x0,8
   addi  x3, x0, 16               # x3 = 16
   ori  x1,x0,1        # x1 = 1
   j    s1
   ori  x1,x0,2        # x1 = 2
1:
   ori  x1,x0,111
   ori  x1,x0,110

   .org 0x20
s1:
   ori  x1,x0,3        # x1 = 3
   jal  s2				#x1 = 0x28
   ##div  x0,x31,x1        # x31 = 0x2c, x1 =0x3
      # HI = 0x2, LO = 0xe
   ori  x1,x0,110
   ori  x1,x0,110
   ori  x1,x0,111
   bne  x1,x0,s3
   nop
   ori  x1,x0,110
   ori  x1,x0,111

   .org 0x50
s2:
   ori  x1,x0,4      # x1 = 4
   beq  x3,x3,s3
   or   x1,x31,x0         # x1 = 0
   ori  x1,x0,111
   ori  x1,x0,110
b2:
   ori  x1,x0,7      # x1 = 7
   ori  x1,x0,8      # x1 = 8
   bgt x1,x0,s4
   ori  x1,x0,9      # x1 = 9
   ori  x1,x0,111
   ori  x1,x0,110

   .org 0x80
s3:
   ori  x1,x0,5      # x1 = 5
   bge  x1,x0,b2
   ori  x1,x0,6      # x1 = 6
   ori  x1,x0,111  #x1 = 111
   ori  x1,x0,110  #x1 = 110

   .org 0x100
s4:
   ori  x1,x0,11      # x1 = 11
   ori  x1,x0,11
   or   x1,x0,x31         # x1 = 0
   ori  x1,x0,12      # x1 = 12
   ori  x1,x0,13      # x1 = 13
   ori  x1,x0,14      # x1 = 14
   ori  x1,x0,15      # x1 = 15
   blt x3,x0,s5
   ori  x1,x0,16      # x1 = 16
   ori  x1,x0,110   # x1 = 110

   .org 0x130
s5:
   ori  x1,x0,10      # x1 = 10
   bge x0,x1,b2
   ori  x1,x0,11      # x1 = 11
   ori  x1,x0,12      # x1 = 12
   ori  x1,x0,13      # x1 = 13
   blt x3,x0,s6
   or   x1,x0,x31         # x1 = 0
   ori  x1,x0,110


   .org 0x160
s6:
   ori x1,x0,14       # x1 = 14
   nop



_loop:
   j _loop
   nop
