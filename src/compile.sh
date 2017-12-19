#! /bin/sh
rm a.out
iverilog -c filelists.txt -I ./CPU.srcs/sources/ -s test0
