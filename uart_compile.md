# 有关Uart通信cpp文件的编译

* 仅Ubuntu

## 准备
* Boost(使用apt-get即可)
* 编译安装Serial
* 如果使用apt-get安装，还需要
```bash
sudo apt-get install libboost-program-options-dev
```


## 编译指令
编译（可以直接使用build.sh）
```bash
g++ *.cpp -c -std=c++14 -I /tmp/usr/local/include/
g++ *.o -o cpu-judge -L /tmp/usr/local/lib/ -lboost_program_options -lserial
```

运行时前需要先运行
```bash
export LD_LIBRARY_PATH=/tmp/usr/local/lib
```
