title: Storm Topology的生命周期
tags:
  - storm
id: 1005
categories:
  - MSE
date: 2013-03-29 10:44:53
---

本文将详细介绍topology的生命周期，从运行 storm jar命令把topology上传到Nimbus，到Supervisor启动和停止worker，再到worker和task的设置和运行。另外，本文还将介绍Nimbus如何监控topology及topology是如何被杀死的。

首先，关于topology需要注意一下两点：

1.实际运行的topology与用户提交的topology是不同的。实际运行的topology中包含隐式的流及一个acker bolt用于实现和管理storm的确认框架（保证消息处理）。隐式的topology是由system_topology!函数实现的。

2.System_topology！在两处使用：1）当Nimbus为topology创建任务时。2）当worker中需要知道如何路由消息时。

**启动topology**

1.storm jar设置特定参数并运行提交的类，storm jar将设置storm jar的环境变量，以便StormSubmitter使用。

2.当你的代码使用StormSubmitter.submitTopology，StormSubmitter执行以下步骤：

*   首先，如果还没有上传jar，则上传。
*   Jar文件的上传通过Nimbus的Thrift接口。
*   beginFileUpload返回Nimbus接受的路径。
*   uploadChunk一次上传15kb的数据。
*   完成上传将调用finishUpload。
*   然后，StormSubmitter会调用submitTopology方法。
*   Topology的设置将通过JSON进行序列化（JSON可以使使用其他语言开发更容易）。以Thrift调用submitTopology将以Nimbus的接收路径为参数。
3.Nimbus收到topology的提交。

4.Nimbus标准化topology的配置（标准化的目的是使每一个单独的实例都有相同的序列化注册接口，这对序列化正确运行很重要）。

5.Nimbus设置topology的静止状态。

*   因为jar和配置太大，不能存入ZooKeeper，将保存在本地文件系统中。Jar和Config将被复制到{nimbus local dir}/stormdist/{topology id}。
*   Setup-storm-static 将task-&gt;component写入ZK
*   Setup-heartbeats 在ZK中创建ZK路径使task可以正常心跳。
6.Nimbus调用mk-assignment 分配任务到机器。任务分配包括：

*   master-code-dir：supervisor从Nimbus下载正确的jars/config
*   task-&gt;node+port:Map从taskid到worker（worker有node+port标示）。
*   Node-&gt;host:Map&lt;nodeid,hostname&gt;worker获取需要的通信的其他worker的信息。Nodeid用于标示supervisor。所以一台机器可以运行多个supervisor，设置supervisor的工作由集成的Mesos完成。
*   Task-&gt;start-time-secs：包括Nimbus开始启动task Map&lt;taskid,timestamp&gt;用于Nimbus对topology的监控。当初次启动任务时，任务会有一个较长的超时值（改时间通过nimbus.task.launch.secs设置）。
7.topology分配后，其状态是deactivated模式。Start-storm将向Zookeeper写入数据使集群知道topology是active并且可以发送元组。

8.TODO cluster-state diagram

9.Supervisor在后台运行一下两个函数：

*   synchronize-supervisor每10s调用一次：当Zookeeper中assignment改变时从Nimbus下载代码，向本地写数据。该节点将开始运行。写的数据Map&lt;port-&gt;localAssignment&gt;LocalAssignment包含topology id及worker的taskid list。
*   sync-process 从LFS读取synchronize-supervisor写的数据，比较正在节点上运行的信息，可以启动和停止worker进程使之同步。
10.通过mk-worker启动worker进程。

*   Worker连接到其他worker并启动一个线程监控变化。所以当worker陪重新分配，worker会重新连接到新的worker地址。
*   监控worker的active状态，并将状态写入storm-active-atom变量，该变量有task使用，以决定是否在spout上调用nextTuple.worker启动task线程。
11.Mk-task设置任务。Task设置路由函数，参数为输入流，输出元组，返回发送元组的taskid列表。Task设置spout和bolt的特定配置。

**Topology的监控**

Nimbus在topology的整个生命周期执行监控，在timer线程计划运行重复的task以检查topology。

Nimbus的行为用FSM描述。

每nimbus.monitor.freq.secs 出发monitor事件，通过reassign-transitions调用reassigntopology.reassign-topology

调用mk-assignment 与topology第一次分配及更新topology调用的函数mk-assignment一样。

Mk-assignment检查心跳信息，如果必要重新分配worker。在ZK中任何分配状态信息的修改将触发supervisor铜鼓及启动或停止worker。

**杀死Topology**

Storm kill与Nimbus的Thrift接口的功能相同。

Nimbus接收到命令，应用kill transition（该transition改变topology的状态为killed，并计划移除事件。通过在未来运行等待时间后进行清理。

等待时间默认为topology的消息超时时间，但可以通过storm kill -w 标志覆盖。这将使得topology在等待时间后状态变为deactivated。这可以是worker在关闭前继续完成正在进行的工作。

改变topology的状态保证kill协议是容错的（防止Nimbus崩溃）如果topology在启动时状态就为killed，Nimbus会安排remove事件在等待时间后执行。

移除ZK中topology的分配信息及静止信息。

单独的消息管理命令do-cleanup执行，该命令将清除心跳目录及本地保存的jar/config目录。

_本文翻译自https://github.com/nathanmarz/storm/wiki/Lifecycle-of-a-topology_