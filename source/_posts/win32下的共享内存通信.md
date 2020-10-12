---
title: win32下的共享内存通信
date: 2019-04-29 09:12:57
tags: 共享内存
categories: 操作系统
---
---
操作系统第四次大作业是有关Win32下的共享内存使用，因为有了之前linux下共享内存使用的经验，对于原理理解也容易了许多。
<!--more-->
windows下共享内存的使用，大致分为几个流程：
- CreateFile()创建或打开文件，返回文件句柄；
- CreateFileMapping()创建文件映射对象，在物理内存中申请一块内存区域；
- MapViewOfFile()将映射对象映射到本进程的地址空间中；
- 进行相关的读写操作；
- UpmapViewOfFile()解除文件映射；
- CloseHandle()关闭映射句柄。

先查阅一些资料，掌握了这几个函数的用法，对大致流程有一个了解，然后运行一下书上示例中的代码，发现有不少错误...（毕竟是几年前的教材了..）比如文件映射低位大小不能为0。于是在网上找了一些例子进行比对找出了一些错误并修正了过来。

一些可供参考的教程示例：
- [Windows进程间通信--共享内存映射文件（FileMapping）--VS2012下发送和接收](https://www.cnblogs.com/Lalafengchui/p/4223584.html)
- [CreateFile函数详解（确实很详细）](https://www.cnblogs.com/findumars/p/5636108.html)
- [MapViewOfFile](https://www.jianshu.com/p/f8394bc9b6bf)
- [CreateFileMapping 、MapViewOfFile、UnmapViewOfFile函数用法及示例](https://blog.csdn.net/educast/article/details/8477294)

其实原理流程挺清晰的，只要掌握了各个函数里面参数的用途，共享内存区的建立就不是问题了。
然后就是在共享内存区中进行题目要求的操作——生成Catalan序列并写入文件中及在另一个进程中读取序列。
这就完全是c语言算法的问题了，这个问题有两个关键点：
①如何连续计算下一个Catalan数并写入文件；
②如何存储生成的Catalan数。

我一开始使用教材中使用的sprintf()函数，但发现每次写入的新数据会覆盖之前的数据，观察后发现教材中使用的 ```sprintf(lpMapAddress,"Shared memory message");```是将字符串写入指定的地址，即文件映射的首地址，我们如果仍使用这种形式，就会导致每次都会在文件映射的首地址处写数据，形成了重复替换已写数据的情况。所以我们必须要将这个指针随着写入数据进行移动。

对于如何存储生成的Catalan数，一开始我就是用一个int类型数组进行存储，但我发现当计算到12！时候就计算出错，即只能正确计算到第6个Catalan数，而将类型声明改为long long和unsigned long long类型（windows 64位下int和long占4字节，long long和unsigned long long占8字节），也只能计算到20！，故最多执行计算到第10个Catalan数，如果再大的话就会出错。所以，如何处理大整数阶乘又是一个问题。网上搜了一下资料大概是使用数组进行存储，但由于这次作业主要是关于共享内存，就没有在这方面进行优化了...（有时间再填坑）

其他注意事项比如：在读进程运行时，要保证文件映射句柄始终打开，若提前关闭，则读进程会读NULL。
还有什么问题想到再补充吧。