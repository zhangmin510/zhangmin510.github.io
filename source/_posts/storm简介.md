title: storm简介
tags:
  - storm
id: 973
categories:
  - storm
date: 2013-02-28 23:45:06
---

Storm是一个开源分布式实时计算系统，storm可以实时可靠地处理流数据。而hadoop则用于数据的批处理。Storm是一个简单的，易于使用的实时处理系统，可以用任何编程语言进行编程。
Storm可以用于实时分析，在线机器学习，连续计算，分布式RPC,ETL等等。Storm性能很好，一项基准测试显示storm可以每秒每节点处理100万个元组的数据。Storm是可扩展的，容错的，可靠的，且易于配置。
Storm集成了队列技术和数据技术。一个storm topology处理流数据且可以以任意方式进行处理，在计算的各个阶段按需重新分割流数据。
使用storm的公司有groupon，taobao.com，twitter，alibaba等公司。

Storm集成了队列和数据库系统，storm的spout抽象使得集成其他队列系统非常容易。
集成队列系统有Kestrel，RabbitMQ，AMQP，Kafka JMS。
同样，storm集成了数据库也很容易，简单地打开一个数据库连接并像通常操作数据库的方式进行操作即可。
Storm将处理并行化，分割及错误处理。

Storm提供易于使用的API。当你在storm上编程时，你可以操纵和变换元组。元组就是已经命名的一串值，元组包含了任何类型的对象。如果有新的对象需要处理，只需注册一个序列器（Serialization）即可。

在storm中有三种抽象。Spout，bolt及topology。
Spout:流计算的数据源。一般情况下，spout从队列代理读取数据，但是spout也可以产生自己的数据流，或者从twitter的流API读取。Spout实现了很多队列系统。
Bolt：处理任意数据的输入流并产生任意数据的输出流。大多数逻辑计算都通过bolt进行处理。如函数过滤器，流合并，流聚集，数据库连接等。
Topology：是spout和bolt的网络。网络中的每条边代表一个bolt订阅了其他的bolt或spout的输出流。一个topology是任意复杂的多阶段流计算。部署后，就不能确定topology在那个节点运行。
Storm有本地模式，在该模式下storm cluster利用进程进行模拟。这种模式用于测试和开发。
Storm的命令行用于向真实集群提交topology。

Storm-stater项目包含了一个topology的示例。

Storm的可扩展性。Storm的topology并行的在各个集群的机器上运行。Topology的不同部分可以单独地扩展。Storm的rebalance命令可以重新调整正在运行的topology。
Storm内置的平行机制意味着它可以低延迟地处理高吞吐量的消息。

容错机制：当worker运行失败后，strom会自动重启它们。如果节点失败，worker会在另一个节点上重启。
Storm的daemon nimbus和supervisor 是无状态的，快速重启的。
如果运行失败，它们会快速重启，就像什么都没发生一样。这意味着你可以利用kill -9杀死storm daemon而不会影响集群上运行的topology的正确性。

可靠数据处理。Storm确保每一个元组tuple都被完整地处理。一个storm的核心机制是可以有效地在整个topology中追踪每一个元组。
Storm基本的抽象提供保证一次的处理，就同你使用队列系统的服务一样。消息只有在失败时才会被重新发送。使用trident，一个更高层次抽象的功能可以保证数据一次处理。

使用任意一种语言：storm提供从底向上的各种语言的编程接口。Storm的核心thrift definition定义和提交topology。因为thrift可以在任意语言下使用，所以topology可以用任意语言定义和提交。同样的，spout和bolt也可以用任意语言进行定义。非JVM的spout和bolt与storm的通信使用基于JSON协议的标准输入输出。已经实现了的适配器有Ruby，Python,Javascript，Perl，PHP等。

易于部署和操作：storm集群只要求很少的配置就可以运行。Storm创造性的配置管理非常适于实际的商业应用。
Storm-deploy项目可以在EC2一键安装storm集群。
另外，storm部署成功后非常易于操作。Storm被设计成高强建的，集群可以日复一日，年复一年的运行。

开源免费：storm基于Eclipse Public License发布。EPL允许利用storm进行开源项目开发或商业项目开发。Storm有强大的，正在成长的生态系统，拥有大量的库和工具。
Storm-contrib项目是一个中心存储仓库，存储社区的贡献，该项目也遵循EPL协议。
Strom-state使得在计算过程中管理大量状态变的容易，通过使用分布式文件系统和持久化。

Mail list : https://groups.google.com/forum/?fromgroups#!forum/storm-user