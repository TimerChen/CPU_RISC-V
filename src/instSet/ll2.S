  .org 0x0
   .global _start
_start:
   ori  x3,x0,16 #x3 = 16
   sb x3, 0x3(x0) # data[3] = 16
   
   srl x3, x3, 8 #x3 = 0
   sb x3, 0x2(x0)
   
   ori x3, x0, 16 #x3 = 16 
   sb x3, 0x1(x0) #data[1] = 16
   
   srl x3, x3, 4 #x3 = 1
   sb x3, 0x0(x0)#data[0] = 1
   
   lb x1, 0x3(x0)
   lbu x1, 0x2(x0)
   
   ori x3, x0, 2
   sh x3, 0x4(x0)
   
   lhu x1, 0x4(x0)
   lh x1, 0x4(x0)
   
   ori x3, x0, 3
   sll x3, x3, 0x10
   ori x3, x3, 6
   sw x3, 0x8(x0)
   
   lw x1, 0x8(x0)
   
   nop
    
_loop:
   j _loop
   nop