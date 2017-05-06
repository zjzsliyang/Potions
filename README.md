# Potions
42002403 Spring2017 Operating Systems Project by Dongqing WANG @ SSE, TJU

## Lift

a destination dispatch iOS app for multi-elevator

![](https://img.shields.io/badge/iOS-10.3-brightgreen.svg) ![](https://img.shields.io/badge/iPad%20Pro-12.9%20inch-orange.svg) ![](https://img.shields.io/badge/Swift-3-blue.svg)

**DDL: May 7th, 2017**

### Requirements

某一层楼20层，有5部互联的电梯。基于线程思想， 编写一个电梯调度程序。并通过控制电梯调度，实现操作系统调度过程；学习特定环境下多线程编程方法；学习调度算法。

- 电梯应有一些按键
- 有数码显示器指示当前电梯状态
- 每层楼、每部电梯门口，有上行、下行按钮、数码显示
- 5部电梯相互联结

### Introduction

这是一个运行于iPad的模拟电梯调度系统，由于有20层5部电梯，为了保证用户体验，暂时只适配了12.9寸。

启动App后，您可以选择在左侧的每层楼中给出上楼和下楼的指令，电梯会根据SCAN调度算法响应，并随机生成一个更高／更低楼层作为您的目的地。您也可以手动点击电梯，在弹出来的``popoverView``中选择目的楼层。

基于粒子群优化算法的实时调度和自动生成指令等功能仍在编写中。

### Algorithms

#### Naïve Algorithms

朴素的非实时电梯调度算法有很多种，如下：

1. First Come First Serve(FCFS)

   先来先服务算法，这是一种最为简单的电梯调度算法，根据乘客发出指令的先后次序进行调度，实现简单无需操作队列且较为公平，但可能因为某个元素处理时间过长而出现等待超时。

2. Shortest Seek Time First(SSTF)

   最短寻找楼层时间优先算法，注重电梯寻找楼层的优化，即根据最短楼层进行响应，具有平均响应时间较短但方差较大的特点，并可能出现有些指令因距离过远长时间得不到响应。

3. SCAN

   扫描算法，即按照楼层顺序依次服务，使电梯在最底层和最高层间往返运行时，响应各个指令。具有较高的效率，但作为非实时的算法，仍具有无法较好适用变化的特点。

4. LOOK

   即在本项目中使用的朴素算法(Naïve Algorithms)。

   通过对SCAN算法中的最底层和最高层进行优化，在到达要求队列的最大值和最小值时即开始往返。

5. Shortest Access Time First(SAFT)

   最短访问时间优先算法，即注重最快的到达时间，有较之SSTF算法更好的一般性的优点和同样的出现长时间无响应的缺点。

#### PSO Algorithms

对于实时优化的调度算法，这里主要介绍粒子群优化算法(Particle Swarm Optimization, PSO)。

本项目原计划仅使用PSO算法，但由于iOS对大量数据的处理较差，仅有[Accelerate Framework](https://developer.apple.com/reference/accelerate)提供部分底层API，故拖延了进度，现记录目前成果如下。

##### 粒子编码

作为随机启发式优化算法，编码方法十分重要，而正是iOS只提供少量简单的数据处理API使我对大量的粒子编码操作产生了困难。

目前我是根据一个粒子对应一个调度方案，每个粒子有``liftRequestQueue.count``的维度，即等于电梯群控系统中所有指令个数。每个维度上有``liftCount = 5``个离散值，对应着5部电梯进行响应。

##### 符号说明

|      |      |      |
| ---- | ---- | ---- |
|      |      |      |
|      |      |      |
|      |      |      |

##### 约束条件

- 避免长时间候梯

  $0 \leq T_w(i) \leq limit(AWT)$

- 避免长时间乘梯

  $0 \leq T_r(i) \leq limit(ART)$

- 避免电梯超载

  $0 \leq Q_i \leq limit(CallCount)$

##### 适应度函数

- Average Waiting Time($AWT$, 平均候梯时间)

  $AWT = $

- Average Riding Time($ART$, 平均乘梯时间)

  ​

- Per Run Consumption($PRC$, 系统运行能耗)

  ​

- Fitness Function(适应度函数)

  $S_i = w_1S_{AWTi}+w_2S_{ARTi}+w_3S_{RPCi}$

##### 应用

至此，我们可以根据不同模式给予三个指标不同的权重来达到不同情景下进一步优化分配的目的。

| 交通模式 | w~1~ | $w_2$ | $w_3$ |
| :--: | :--: | :---: | :---: |
| 上行高峰 | 0.6  |  0.2  |  0.2  |
|  层间  | 0.5  |  0.2  |  0.3  |
|  空闲  | 0.4  |  0.2  |  0.2  |
| 下行高峰 | 0.55 |  0.2  | 0.25  |

w~1~

### Architecture



### Video

[YouTube]() or local

### Screenshot

Static:

![Screenshot](Res/Screenshot1.PNG)

Dynamic:

![Screenshot](Res/Screenshot2.PNG)

### Under Construction

- [ ] PSO Algorithms
- [ ] Auto Generation

###  License

- Created by Yang LI(1452669) under MIT LICENSE
- Open Sourced on [GitHub](https://github.com/zjzsliyang/Potions)
- Fork & Issues are both welcomed

### Reference

[1] James Kennedy, Russell Eberhart: [Particle Swarm Optimization](https://www.cs.tufts.edu/comp/150GA/homeworks/hw3/_reading6%201995%20particle%20swarming.pdf), Purdue School of Engineering and Technology Indianapolis, 1995.

[2] Zhenshan Yang, Cheng Shao, Guizhi Li: [Multi-Objective Optimization for EGCS Using Improved PSO Algorithm](http://ieeexplore.ieee.org/document/4282871/), American Control Conference, 2007.

[3] Hesam Izakian, Behrouz Tork Ladani, Ajith Abraham, Vaclav Snasel: [A DISCRETE PARTICLE SWARM OPTIMIZATION APPROACH FOR GRID JOB SCHEDULING](http://www.softcomputing.net/ijicic20101.pdf), International Journal of Innovative Computing, Information and Control, 2010.

[4] Parsopoulos KE, Vragatis MN: [Recent approaches to global optimization problems through Particle Swarm Optimization](https://link.springer.com/article/10.1023/A:1016568309421), Natural Computing, 2002.

[5] 郭文忠, 陈国龙: 离散粒子群优化算法及其应用, 清华大学出版社, 2012.