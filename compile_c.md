# 如何编译c代码

* 这篇文章将告诉你如何编译将c语言程序编译成RISCV可以使用的二进制文件

* 这也是[cpu-judge](https://github.com/sxtyzhangzk/cpu-judge)测试项目的使用教程，教程中所有提到的未经特殊说明的文件，都在此项目中。

* 这篇教程基于win10内嵌的Ubuntu子系统，其它环境可能不适用。


## 准备

* RISCV工具链
	- 安装与使用[教程](http://blog.evensgn.com/riscv-gnu-toolchain/)
	- 可以使用已经编译好的RISCV工具链([到这找](https://github.com/sxtyzhangzk/cpu-judge/blob/master/README.md))

## 如何编译
你的RISCV工具链应该被安装到/opt/risv/目录中

在cpu-judge项目的/test下，代码example.c，使用
```bash
	build-c.sh example.c
```
进行编译，编译结束后会在目录下生成
* memroy.bin 二进制文件
* memory.mem 文本十六进制文件（用于模拟时初始化内存）
* ram.S 	c代码翻译的汇编代码

**注意**：build-c.sh在编译时未开O2优化，生成的代码比较复杂，想进行优化可以使用 build-c-o2.sh

##有关编译过程的介绍
rom.s的功能是在程序开始时赋值栈寄存器sp，并在程序结束后让其进入一个死循环（防止访问非法位置）

你的c代码会被编译成ram.o后和rom部分一起链接

memory.ld负责设定rom和ram两部分代码的起始位置和长度
（ram部分从0x108开始）

你的程序只需要从0开始执行指令即可
## 有关memory.mem十六进制文本文件

这个文件格式与你内存的定义格式有关，如果定义位宽是8
```verilog
	reg [7:0] mem [0:xxx];
```
导入的文本文件应该是一行2个字符

如果位宽是32
```verilog
	reg [31:0] mem [0:xxx];
```
导入的文本文件应该是一行8个字符
只需将bin2ascii.py文件的13~14行改为

```python
	for i in range(0, len(s), 8):
		f.write(s[i:i+8])
```
## 有关io.h
这个文件定义了在模拟时的读写操作，所有向内存0x104位置store的指令被视为输出，所有从0x100位置load的指令被视为读入。

你可以通过在时序电路中检测相关指令实现模拟的输入/输出

## 一些测试代码

除了cpu-judge项目提供的测试文件，你可以[在这里](https://github.com/TimerChen/CPU_RISC-V/tree/dev/src/instSet_cpp)找到我编写的一些简单的测试代码

## 注意事项
* 测试时请调整栈指针大小，以免超出内存或太小导致爆栈
