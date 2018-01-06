#! /bin/bash
export LD_LIBRARY_PATH=/tmp/usr/local/lib
../tools/uart/cpu-judge --com-port COM4 --memory ./insts.bin
