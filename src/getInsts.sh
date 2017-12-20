#! /bin/sh
cp insts.S ../tools/code_gener/insts.S
cd ../tools/code_gener/
make insts.data
cd ../../src
cp ../tools/code_gener/insts.data ./insts.mem
cp ./insts.mem ./CPU.srcs/sources/insts.mem
