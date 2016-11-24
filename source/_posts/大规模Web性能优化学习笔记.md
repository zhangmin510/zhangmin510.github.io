title: 大规模Web性能优化学习笔记
tags:
  - 技术
id: 1506
categories:
  - 学习笔记
date: 2013-05-08 18:32:11
---

在进行大规模web性能优化时，首先应该理解为什么大规模web性能优化如此的重要。可以从以下几点考虑：

*   随着互联网的额发展大规模数据处理和实时任务处理越来越重要。
*   大部分客户端应用或手机应用需要强大的服务端的支持。
*   增强数据中心的服务能力可以通过优化完成。

获得高性能的方法有：复制，分区，负载均衡，数据压缩，最终一致性（较低的一致性要求）。

获得高可用性的方法：复制，分区，健康检查和watchdog timers，一致性检查，最终一致性。

**CAP理论**

Consistency,Availability,Tolerance to Network Partition.You can have at most two of these invariants for any shared-data system.

Consisitence:all nodes see the same  data at the same time.

Availability:a guarantee that every request receives a response about whether it was successful or failed.

Partition tolerance:the system continues to operate despite arbitrary message loss or failure of part of the system.

An important observation is that in larger distributed scale systems, network partitions are a given; therefore, consistency and availability cannot be achieved at the same time.This means there are two choices on what to drop:

1\. relaxing consistency will allow the system to remain highly available under the partition conditions.

2\. making consistency a priority means that under certain conditions the system will not be available.

**负载分析**

负载可以认为是在给定时间内一个系统的所有输入。负载分析的一般方法如下：

1.  确定负载分析的观察点。
2.  识别要分析的组件（事务，交互式命令，HTTP请求等）。
3.  选择相关参数（如到达率，连接数，思考时间，并发数，服务需求等）。
4.  数据收集（在一定的时间段内观测）。
5.  对负载进行分类（如按照资源使用，应用，地理位置，功能，组织单元等）。

**寻找瓶颈**

*   查看平均负载。
*   确认 CPU、I/O有无瓶颈。

**一个典型应用包括**

*   用户登录和用户档案
*   事件（通知，社交网络的活动，点击）
*   应用程序数据（博文，消息，图片等）

**AKF Scale Cube**
[![AKF](http://www.zhangmin.name/blog/wp-content/uploads/2013/05/AKF.jpg)](http://www.zhangmin.name/blog/wp-content/uploads/2013/05/AKF.jpg)

**一个高性能，高可用性系统的基本架构图**

[![参考模型](http://www.zhangmin.name/blog/wp-content/uploads/2013/05/参考模型.jpg)](http://www.zhangmin.name/blog/wp-content/uploads/2013/05/参考模型.jpg)

_以上内容改编自罗铁坚的大规模web性能优化课程PPT_