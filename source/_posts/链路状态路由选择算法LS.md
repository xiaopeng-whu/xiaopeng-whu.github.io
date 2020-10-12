---
title: 链路状态路由选择算法LS
date: 2019-5-10 09:36:20
tags: 路由算法
categories: 计算机网络
---
---
一个主机通常与一台路由器相连接，该路由器即为主机的默认路由器。
源主机的默认路由器称作源路由器，目的主机的默认路由器称作目的路由器。
一个分组从源主机到目的主机的路由选择问题即从源路由器到目的路由器的路由选择问题。
<!--more-->
路由选择算法可分为：
- 全局式路由选择算法：所有路由器掌握完整的网络拓扑和链路费用信息，例如链路状态（LS）路由算法
- 分散式路由选择算法：路由器只掌握物理相连的邻居以及链路费用，例如距离向量（DV）路由算法

下面主要介绍链路状态路由算法（Link-stage）中的一种典型算法OSPF算法。

#一、OSPF是什么
Open Shortest Path First, 开放最短路径优先协议，是一种开源的使用最短路径优先（SPF）算法的内部网关协议（IGP）。常用于路由器的动态选路。

#二、OSPF常见的几个概念
1. 邻居（Neighbor）：宣告OSPF的路由器（也可能是通过quagga软件配置的普通服务器）从所有启动OSPF协议的接口上发出Hello数据包。如果两台路由器位于同一条数据链路上，并且它们根据互相的hello消息中指定的某些信息（比如id等）协商成功，那么它们就成为了邻居（Neighbor）。
2. 邻接关系（Adjacency）：两台邻居路由器之间构成的一条点到点的虚链路，邻接关系的建立是由交换hello信息的路由器类型和网络类型决定的。
3. 链路状态通告（Link State Advertisement，LSA）：每一台路由器都会在所有形成邻接关系的邻居之间发送链路状态通告LSA。LSA描述了路由器所有的链路、接口、邻居等信息。ospf定义了许多不同的LSA类型。
4. 链路状态数据库（LSDB）：每一台收到来自邻居路由器发出的LSA的路由器都会把这些LSA信息记录在它的LSDB中，并且发送一份LSA的拷贝给该路由器的其他所有邻居。这样当LSA传播到整个区域后，区域内所有的路由器都会形成同样的LSDB。

#三、OSPF的基本原理
OSPF算法是让每个路由器中的数据库储存整个网络的拓扑图，即每个路由器掌握了全局的信息，此时这个网络趋于稳定，便可以使用单源最短路径（Dijkstra）来选择路由。

每个路由器与其邻居的通信行为有以下几种：
1.保持联系
整个自治系统中，每个路由器都有唯一标识RouterID(32-bit). 与其每个邻居间隔30s，发送一次Hello 报文，意思就是你还活着吗？
二者相互通信发送Hello，并收到对方回应Hello。双方会周期性将自己的路由数据摘要发送给对方，一般30min，平时， 
双方只是联系感情，直到对方没有挂。
2.告知现今情况
![](https://upload-images.jianshu.io/upload_images/16845916-40717fbbfc3b07a7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如图，R1会周期性地将自己的路由摘要发送给所有邻居。比如对R6路由器，R1会发送 
称为DD报文的包，里面会说自己认识R6,R2,R4,R5,R6对比自己的信息库发现 
除了自己R1的朋友它一个都不认识，于是就发送请求报文，请求告知这些不认识的 
路由详情。这个请求报文称为LSR(链路状态请求报文)报文。 
R1收到之后，直到R6还不认识自己另外三个朋友，于是发送LSU报文（链路状态更新）告知R6详情。R6收到之后，给R1个确认-LSAck报文。两个人现在认识的路由器一样多了，此时两个人是好基友了-全毗邻关系。

#四、Dijkstra算法
Dijkstra算法是典型的LS路由算法，可计算在网络中从一个节点到所有其他节点的最短路径。
之前在数据结构课上已经初步学习过这个算法，代码直接给出。
```
#include "stdio.h"   
#include"stdlib.h"   
#define MAX 30000
int n;
int Arraya[100][100];       

int BeginningPath()//说明初始化的路由连接信息
{          
	int i,j,t;
	printf("请输入节点的个数：");
	scanf("%d",&n);//一共有n个节点
	
	for(i=0;i<n;i++)
	{
		for(j=i+1;j<n;j++)
		{
			printf("从第%d个节点到第%d个节点的费用：",i,j);
			scanf("%d",&t);	
			if(t==-1) t=40000;	//-1表示 ∞
			Arraya[j][i]=t;
		    Arraya[i][j]=t;
		} 
		Arraya[i][i]=0;
	}
    printf("\n\n在交换路由之前 : \n");
	for(i=0;i<n;i++)//显示初始化的数据
	{         
			printf("\t");
			for(j=0;j<n;j++)
			{
				if(Arraya[i][j]==40000)
					printf("∞ ");
				else	
					printf("%d  ",Arraya[i][j]);
			}
			printf("\n");
	}
	return 0;
}

void Dijkstra(int s)	//求以s为源点到各点的最小路径及花费 
{
	int flag[100],d[100]={0},next[100]={0};	//已知节点集合，距离矢量，下一跳 
	int i,j;
	for(i=0;i<n;i++)//初始化
	{
		d[i]=Arraya[s][i];
		flag[i]=0;
		next[i]=i;
	}
	flag[s]=1;	//把源节点加入已知最短路径距离节点的集合 
	int k=s,min;
	for(i=0;i<n;i++)
	{
		min=MAX;
		for(j=0;j<n;j++)//找出最小值d[k]
			if(d[j]<min&&flag[j]==0)
			{
				min=d[j];	//寻找节点i的邻居中最近的节点，记录最小值及节点序号 
				k=j;
			}
		if(k==s)	return ;	//k值没有改变说明没有邻居 
		flag[k]=1;//标志是否放入集合
		for(j=0;j<=n;j++)//松弛邻边（以新的已知集合构造新的与未知集合节点的距离） 
		    if(d[j]>Arraya[k][j]+d[k]&&flag[j]==0)
			{
				d[j]=Arraya[k][j]+d[k];
				next[j]=next[k];	//到j节点的路径下一跳为中间点k，即到k的路径的下一跳 
			}
	}
	printf("r%d  next  cost\n",s);
	for(i=0;i<n;i++)
	{
		if(i==s)
			continue;
		printf("%d : %d  %d\n",i,next[i],d[i]);
	}
}

int main()
{
	int i;
	BeginningPath();
	for(i=0;i<n;i++)
		Dijkstra(i);
	return 0;
}

```
假如我通过OSPF形成的网络拓扑图如下图，则可通过Dijkstra算法计算结果。
![](https://upload-images.jianshu.io/upload_images/16845916-6c881b2ba82ecc74.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

运行结果如图
![](https://upload-images.jianshu.io/upload_images/16845916-fb22469440a5addd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![](https://upload-images.jianshu.io/upload_images/16845916-9336824df06cf17f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

参考链接：
[OSPF的基本原理](https://www.jianshu.com/p/332d866c41ed)
[OSPF路由算法-Zoom in](https://blog.csdn.net/qq_33745102/article/details/82016413)
[LS链路状态路由算法](https://blog.csdn.net/qq_33361432/article/details/79464886)
[路由选择算法 LS DV](https://blog.csdn.net/qq_22238021/article/details/80496138)