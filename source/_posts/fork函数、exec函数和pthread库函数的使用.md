---
title: fork函数、exec函数和pthread库函数的使用
date: 2019-04-09 09:17:54
tags: 进程
categories: 操作系统
---
---
抽时间整理一下操作系统布置过的大作业。第一次大作业是编译linux内核，这部分在之前的blog里写过了，这篇记录的是第二次大作业的内容。
<!--more-->
首先，我们以大作业的要求来作导入。

![要求.png](/fork函数、exec函数和pthread库函数的使用/1.png)

整个任务的要求大概就是，第一个进程A创建一个子进程B，再在进程B中创建两个线程，分别完成不同的工作。

在具体分析问题之前，我们需要了解学习一下几个函数。这里我就丢几个链接了，讲的十分详细，很有帮助。

[fork函数&子进程与父进程&守护进程]([https://blog.csdn.net/nan_lei/article/details/81636473](https://blog.csdn.net/nan_lei/article/details/81636473)
)
[linux c语言 fork() 和 exec 函数的简介和用法]([https://www.cnblogs.com/dongguolei/p/8098181.html](https://www.cnblogs.com/dongguolei/p/8098181.html)
)
[linux创建线程之pthread_create]([https://www.cnblogs.com/amanlikethis/p/5537175.html](https://www.cnblogs.com/amanlikethis/p/5537175.html)
)

下面就开始代码的编写。

首先是第一个主模块，即进程A创建进程B部分。这里父进程A通过调用fork()创建子进程B，通过wait()等待子进程B结束，而B通过exec()函数调用另一个文件作为它的“替身”而自己被替身所替代，从而便于在另一个文件编写有关创建线程的部分。
```
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <sys/types.h>
#include <wait.h>

int main()
{
    pid_t pid;
    pid=fork();

    if(pid<0){
		printf("Fork failed");
		exit(-1);
    }
    else if(pid==0){
		printf("Child process start,child pid is %d.\n",getpid());
		//exec..
		char *buf[]={"/home/wzp/charpter2/procedure2","procedure2",NULL};
		execve("/home/wzp/charpter2/procedure2",buf,NULL);
    }
    else{
		printf("Hello world,father pid is %d.\n",getpid());
		wait(NULL);
		exit(0);
    }
}
```
然后是子进程B变身后的新文件部分，即产生线程部分。

这里程序又分为三个模块，main作为主函数，即子进程B的替身，它又通过pthread_create()函数生成两个线程完成监视输入和计算的工作，故共三个线程。

主线程通过pthread_join()函数等待一个thread结束，但这里实际运行时并不会运行到这一步，因为在线程内部会通过exit()结束进程的运行。这里只是为了使pthread_join()和pthread_create()对应。

这一部分遇到了不少问题...

为了保证两个功能实现线程的信息交流，使用了几个全局变量，在注释中也有标注。当时进行编写的时候，考虑到互斥的问题，故使用了互斥锁进行保护，但测试时候对于互斥区的保护总是出现问题，导致对于功能实现总是有一个功能无法实现，改进一个功能又会导致另一个功能出现问题。最终“一气之下”把互斥锁删去，结果竟然能够正常运行了...我也是有些懵逼，遂放弃使用互斥锁，选择在恰当的地方使用条件变量conditions和sleep()进行二者互斥和部分提示信息的顺序排序。

还遇到的问题就是对于输入信息不确定为符号还是数字的问题，询问同学后才知道如何解决，即使用union联合，再通过scanf()的返回值来进行分类处理。这里就吃了当初c后半部分没学好的亏...很少用到union等知识导致编写程序根本想不到...以后多积累经验吧。

还有就是缓冲区问题。当输入一个未定义符号时，等待下一次重新输入，需要情况缓冲区，而windows的fflush（stdin）不能在linux环境下运行，故采用set（stdin，NULL）函数来清除缓冲区。这也是这次实验学到的。

```
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
//#include <sys/types.h>
//#include <wait.h>

//pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;/*初始化互斥锁*/
//pthread_cond_t  cond = PTHREAD_COND_INITIALIZER;//init cond

void *Input(void* arg);
void *Sum(void* arg);

union member{
	int a;
	char b;
}x;
int sum=0;    //全局变量sum,x
int m; //m is an variate to store x.a.
char n; //n is an variate to store x.b. 
_Bool flag,conditions; //flag distinguishes int(1) and char(0);conditions functions like "pthread_cond_signal(&cond)" from Input to Sum but also from Sum to Sum.

void *Input(void* arg)
{
    printf("Please input an integer or a character:\n");
    //printf("**pthread 1 starts.\n");
while(1)
 {  
    if(scanf("%d",&x.a))
    {
		m=x.a;
		flag=1;
				
		conditions=1;
		//printf("**pthread 1 signal conditions to 2.\n");
    }
    else 
    {
		scanf("%c",&x.b);
		n=x.b;
		flag=0;
	
		conditions=1;
		//printf("**pthread 1 signal conditions to 2.\n");	
    }

    //printf("**pthread 1 releases lock.\n");

    sleep(2);
 }
}

void *Sum(void* arg)
{
while(1)
 {
    //printf("**pthread 2 starts.\n");
    int i;
    
    sleep(1);

    while(!conditions)	sleep(1);

    sleep(2);

    //printf("**pthread 2 gets conditions.\n");

    //printf("**flag in pthread2 is %d\n",flag);
    if(flag)
    {
	
        for(i=0,sum=0;i<=m;i++)
		{
		  sum=sum+i;
		}
        
		printf("the sum from 0 to %d is %d\n",m,sum);
	        
		conditions=0;
		sleep(1);
        printf("Please input an integer or a character:\n");
    }
    else
    { 
	
	//printf("**judging the type of character.\n");
        switch(n)
		{
		  case 'p':	
			{
			    printf("Please input an integer or a character:\n");
			    while((!flag)&&(n=='p'))	
			    { 
				sleep(1);
			    }
							    
			    //conditions=1;
			    break;
			};//stop Sum, use loop
		  case 'e':	
			{
			    printf("exit.\n");	
			    exit(0);
			    break;
			};//exit sum.exe
		  default:	
			{
			    printf("error.\n");
			    printf("Please input an integer or a character:\n");
			    setbuf(stdin, NULL);
			    break;	
			};//child process continue.
		}
	
	//printf("**pthread 2 ends.\n");
    }
   
 }   
}



int main()
{
    printf("exec success.\n");

    pthread_t id1,id2;

    pthread_create(&id1,NULL,Input,(void*)NULL);
    pthread_create(&id2,NULL,Sum,(void*)NULL);

    pthread_join(id1,NULL);//wait thread end
    pthread_join(id2,NULL);

    //pthread_mutex_destroy(&mutex);
    //pthread_cond_destroy(&cond);
    exit(0);

    return 0;
}
```
最后就是编译运行了，这里注意因为使用了线程，故编译命令后面要加上-lpthread，否则会出错。

贴一张运行截图。

![运行.png](/fork函数、exec函数和pthread库函数的使用/2.png)


大概就是这样了，总之就是一开始看到问题一脸懵逼，各种函数都不会用。后来查了些资料了解了用法，再把问题分成几个模块，一步一步做就做成功了。调试阶段耗精力较多，但最终成功后还是比较开心。