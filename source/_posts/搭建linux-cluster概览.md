title: 搭建linux cluster概览
tags:
  - 技术
id: 1492
categories:
  - linux
date: 2013-05-07 21:44:35
---

作为云计算和大数据处理的基础，cluster技术至关重要。本文将简略地介绍如何构建一个linux cluster。首先介绍一下如何构建高可用的服务器组。

构建高可用服务器组（server pair）需要哪些工具或软件：

*   当系统启动时使用init脚本启动守护服务进程。
*   使用netfilter过滤数据包和操作数据包，也可以利用iptables或ipchains。
*   编译内核，这样你可以自定义需要的功能或模块。
*   使用rsync同步两个服务器的数据，利用cron计划任务。
*   使用systemimager克隆系统。
*   使用heartbeat技术转移故障。

下面介绍构建一个高可用的linux cluster的基本步骤：

1.  决定使用什么样的网络连接存储服务器。2.  理解内核netfilter和数据包路由技术。
3.  学会如何克隆一个linux服务器。
4.  决定cluster中机器的命名方式。
5.  学会如何在整个cluster上同步系统配置的变化。
6.  构建一个linux虚拟服务器（LVS）。
7.  建立linux虚拟服务器的请求路由机制（负载均衡）。
8.  安装可以自动移除失效节点的软件。
9.  安装监控cluster的软件。
10.  学会如何监控cluster的性能。
11.  学会如何使用自动化工具更行cluster中安装的软件或工具。
12.  决定使用什么策略集中管理用户账户。
13.  安装一个高可用的批处理作业处理系统。
14.  安装打印系统用于支撑cluster。
15.  购买cluster节点。

_以上内容摘自《Linux Enterprise Cluster》_