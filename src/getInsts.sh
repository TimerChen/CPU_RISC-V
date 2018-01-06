#! /bin/sh
rm insts.mem
if [ $# -lt 2 ]; then
	file="insts"
else
	file=$2
fi
if [ $1 = "1" ]; then
	echo "Getting from cpp code[${file}.S]..."
	cp ${file}.c ../tools/code_gener/cppcode/insts.c
	cd ../tools/code_gener/cppcode
	./build-c.sh insts.c
	cd ../../../src
	cp ../tools/code_gener/cppcode/memory.mem ./insts.mem
	cp ../tools/code_gener/cppcode/ram.S ./cpp_insts.S
	cp ../tools/code_gener/cppcode/memory.bin ./insts.bin
	cp ./insts.mem ./CPU.srcs/sources/insts.mem
else
	if [ $1 = "2" ]; then
	echo "Getting from cpp code[${file}.S]..."
	cp ${file}.c ../tools/code_gener/cppcode/insts.c
	cd ../tools/code_gener/cppcode
	./build-c-o2.sh insts.c
	cd ../../../src
	cp ../tools/code_gener/cppcode/memory.mem ./insts.mem
	cp ../tools/code_gener/cppcode/ram.S ./cpp_insts.S
	cp ../tools/code_gener/cppcode/memory.bin ./insts.bin
	cp ./insts.mem ./CPU.srcs/sources/insts.mem
	else
		echo "Getting from S code[${file}.S]..."
		cp ${file}.S ../tools/code_gener/assembler/insts.S
		cd ../tools/code_gener/assembler
		make insts.bin
		make insts.mem
		cd ../../../src
		cp ../tools/code_gener/assembler/insts.bin ./insts.bin
		cp ../tools/code_gener/assembler/insts.mem ./insts.mem
		cp ./insts.mem ./CPU.srcs/sources/insts.mem
	fi
fi
