# Potions
42002403 Spring2017 Operating Systems Project by Dongqing WANG @ SSE, TJU

## Lift

a destination dispatch iOS app for multi-elevator

![](https://img.shields.io/badge/iOS-10.3-brightgreen.svg) ![](https://img.shields.io/badge/iPad%20Pro-12.9%20inch-orange.svg)

**DDL: May 7th, 2017**

- 项目目的
  - 通过控制电梯调度，实现操作系统调度过程
  - 学习特定环境下多线程编程方法
  - 学习调度算法


- 基本需求
  - 某一层楼20层，有五部互联的电梯。基于线程思想， 编写一个电梯调度程序
  - 电梯应有一些按键，如：数字键、关门键、开门键、上行键、下行键、报警键等
  - 有数码显示器指示当前电梯状态
  - 每层楼、每部电梯门口，有上行、下行按钮、数码显示
  - 五部电梯相互联结，即当一个电梯按钮按下去时，其它电梯相应按钮同时点亮
  - 电梯调度算法
    - 所有电梯初始状态都在第一层
    - 每个电梯没有相应请求情况下，则应该在原地保持不动
    - 电梯调度算法自行设计
- 项目提交
  - 设计方案
  - 源代码
  - 执行程序
- 评核方式
  - 实现
  - 界面
  - 算法
  - 可行性
