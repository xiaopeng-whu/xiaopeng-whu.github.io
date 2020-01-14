---
title: ubuntu18.04内核添加系统调用
date: 2019-03-03 18:47:20
tags: 系统调用
categories: 操作系统
---
---
操作系统布置了第一次大作业，让我们给linux内核加一个系统调用，并创建程序验证，还要用ptrace等工具进行监测。监测部分暂时还没有思路，先把前部分操作记录一下。

书上的教程已经太老了，基本没什么参考价值，只是能大概帮助理解一下系统调用的大致流程及原理。在老师没有讲过以及课本没有什么参考资料的时候，百度大概是最好的选择了，好在网上有很多这类的教程。

---

#尝试version1

一开始想着既然是在linux添加修改内核，不如直接在之前为了信安课而装的kali上进行，网上相关教程也不少，但不得不说，在系统调用方面，kali就是个弟弟...各种缺配置缺文件，甚至版本不同路径都可能不一样。你不知道你缺什么配置工具，只能做一步停一步慢慢开展，而大部分配置甚至不能直接用```sudo apt-get install```来进行安装，会提示各种错误，比如找不到所需安装包，这时又要去百度才知道还要更改source.list的源；在比如两个文件有依赖关系，就要先安一个提示的版本再重新安装...总之会遇到各种各样的问题，花了一上午加下午经历了无数大大小小错误甚至升级了VMware版本，最后好不容易能进行```sudo make -j4```编译操作了，结果运行了十分钟又报错，很奇怪的错。
![kali编译错误](/ubuntu18-04内核添加系统调用/kali编译错误.jpg)
网上甚至很少解决方法（我就找到一种明确的，还对我的系统不适用...)当时直接心态崩了..直接选择换linux系统用ubuntu来做。

---

#尝试version2

换ubuntu安装时甚至也出现了错误，最后的安装过程时间很长，我就先去买饭，回来就发现电脑蓝屏了..(此处心疼电脑1s...)开机又配置了下语言、VMware Tools工具等东西。

换了系统后再按照网上的ubuntu18.04系统调用教程一步一步做，基本没有出错，深觉一个好系统的重要性..

步骤记录在这里吧。

##1.准备操作（提前安装好后续可能用到的软件和工具）

	sudo apt-get update  //更新系统源码 
	sudo apt-get install vim //安装vim
	sudo apt-get install libncurses5-dev libssl-dev  //下载依赖包
	sudo apt-get install build-essential openssl  
	sudo apt-get install zlibc minizip  
	sudo apt-get install libidn11-dev libidn11
	sudo apt-get install flex bison //没有这个依赖包可能会在make menuconfig配置界面报错。
	***依赖包缺少系统一般会有提示，装好了错误也就解决了。

##2.内核的解压和添加自己的系统调用

###解压

先将在官网下好的内核直接拉到ubuntu里，然后将压缩包用指令移到/usr/src目录下面（过程需要root权限）。

###添加系统调用

（最好先将目录切换到解压后的内核里操作）

	sudo vim kernel/sys.c //添加自己的函数

![函数](/ubuntu18-04内核添加系统调用/函数.png)

	sudo vim arch/x86/include/asm/syscalls.h //声明

![头文件声明](/ubuntu18-04内核添加系统调用/头文件声明.png)

	sudo vim arch/x86/entry/syscalls/syscall_64.tbl  //添加调用号

![调用号](/ubuntu18-04内核添加系统调用/调用号.png)

这里注意声明函数以及调用名称要一致，否则后面编译会出错。

##3.删除一些无用的文件

    sudo make mrproper //会删除所有的编译生成文件、内核配置文件（.config文件）和各种备份文件，几乎只在第一次执行内核编译前采用这条命令

    sudo make clean //这命令则是用于删除大多数的编译生成文件，但会保留内核的配置文件.config，还有足够的编译支持扩展模块。所以若只想删除前一次编译过程的残留数据，只需执行make clean命令。

	//前一条命令删除的范围更大，事实上，make mrproper在具体执行时第一步就是调用make clean

    sudo make menuconfig //产生图形化界面，save后exit就行了

##4.编译新内核并安装

###编译
	sudo make -j4 //后面的-j4是采用四核来加速编译速度，若不使用则会很慢，取决于虚拟机处理器的内核总数的设置
经过漫长的等待..我是直接开了机器直接睡觉睡醒就好了..
###安装
	sudo make modules_install
	sudo make install
![内核安装配置完成](/ubuntu18-04内核添加系统调用/内核安装配置完成.jpg)

##5.重启

一开始我并不知道怎么选择新的内核，后来才知道ubuntu重启自动默认选择新内核，貌似要选择其他的要开机一直按ESC，反正不需要了先记录下。

利用```uname -a```可知前后版本不同，内核已经改变。

##6.测试

编写c文件编译进行测试，以及查看日志文件看结果。

依次执行

	touch hello.c
	gcc -o hello hello.c
	./hello

![创建程序](/ubuntu18-04内核添加系统调用/创建程序.png)

![编译成功](/ubuntu18-04内核添加系统调用/编译成功.jpg)

![日志查看](/ubuntu18-04内核添加系统调用/日志查看.png)

其中注意创建c函数时候要将输出作为long类型输出，因为系统调用默认要求使用long类型（？）。

---

添加系统调用的大致过程就是这样了，留几个参考链接便于查阅。

https://blog.csdn.net/qq_38898129/article/details/80398851

https://blog.csdn.net/qq_36290650/article/details/83184088

https://blog.csdn.net/weixin_42349518/article/details/80517197