---
title: 从零构建Hyperledger-Fabric区块链网络
date: 2018-10-11 09:19:24
tags: [Hyperledger Fabric, 区块链]
---
# 1 Hyperledger Fabric网络的组成要件

一个Fabric区块链网络，在技术上包含以下要件：
1. 账本 Ledger。包含交易数据的区块链。
1. 智能合约Chaincode。与账本交互的接口。
1. 节点 Peer。维护账本数据，安装智能合约。
1. 排序服务 Ordering Service。对交易进行排序，打包区块，分发区块。
1. 通道 Channel。通信机制。
1. 证书机构 Certificate Authority。身份证书颁发。

# 2 从0到n创建一个示例网络

我们将要创建如下图所示的Hyperledger Fabric网络N。在图中有四个组织：R1-4，四个组织达成一致构建Hyperledger Fabric网络。每个组织都有相应的证书结构CA1-4，管理每个组织的数字证书。

![Hyperledger Fabric区块链网络](http://upload-images.jianshu.io/upload_images/4000-ef5ce7b5f1e3eb34.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

R4被指定为网络的发起者，设置网络的初始版本。R1和R2以及R2和R3之间需要秘密通信。

R1拥有一个应用A1在通道C1上进行业务操作。
R2拥有一个应用A2在通道C1和C2上进行业务操作。
R3拥有一个应用A3在通道C2上进行业务操作。

节点P1维护了通道C1上的账本L1.
节点P2维护了通道C1的账本L1以及通道C2的账本L2。
节点P3维护通道C2的账本L2。

整个网络的配置是NC4，由网络发起者R4进行初始设置，这个网络由R1和R4控制。

通道C1的配置是CC1，由R1和R2控制。
通道C2的配置是CC2，由R2和R3控制。

整个网络的排序服务是O4，作为网络的N的管理节点，使用系统通道。这个排序服务支持通道C1和C2。

## 2.1 R4进行初始网络创建：从0-1

![初始网络](http://upload-images.jianshu.io/upload_images/4000-29ccee6275119ddc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如果定义一个Hyperledger Fabric网络N，首先需要有排序服务O4，排序服务是整个网络的管理起点。上文中说，R4被大家选举为网络的发起者，所以网络在R4内配置和运行。此时的网络配置NC4中有如下信息：
```
管理者——R4
```
CA4 用于颁发或者吊销R4内的各种数字证书，用于标识属于R4的软件组件。使用证书对业务操作进行签名和验证，表示业务操作由R4 发起。Fabric中的MSP（Membership Services Provider）负责将证书和组织成员关联起来。

## 2.2 加入新的管理者R1

![加入管理者R1](http://upload-images.jianshu.io/upload_images/4000-9165139eece132cf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

网络配置NC4包含：
```
管理者——R4,R1
```

## 2.3 创建联盟X1

![联盟](http://upload-images.jianshu.io/upload_images/4000-9214a06c814f0e6a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

联盟定义了网络中需要相互交互的组织，如R1和R2。将具有相同目标的组织进行分组。联盟X1包含两个成员：R1和R2。当前的网络配置NC4中的内容：
```
管理者——R4，R1
联盟X1——R1,R2
```

## 2.4 关键步骤:创建联盟X1的通道C1

通道用于联盟中成员之间的通信。一个通道可以有多个组织。通道提供组织之间的私密通信机制。通道之间相互隔离。

![创建通道C1](http://upload-images.jianshu.io/upload_images/4000-0837c6e129075317.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

联盟X1中的成员R1和R2，通过通道配置CC1创建通道C1，通道中有R1和R2两个组织。CC1和NC4完全隔离，CC1由R1和R2管理，而NC4由R4和R1管理。

## 2.5 加入节点和账本

![加入节点](http://upload-images.jianshu.io/upload_images/4000-287d6d856659cf51.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

P1需要CA1颁发证书来标识是属于R1。P1创建后，节点P1加入通道C1，P1上维护了账本L1。当O4 收到P1的加入请求，O4会使用CC1来判断P1是否有权限，即CC1定义P1是否有权限读写L1的数据。

> L1物理上在P1，逻辑上在C1.

## 2.6 加入应用和智能合约

![应用和智能合约](http://upload-images.jianshu.io/upload_images/4000-e86c340f83e60478.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

智能合约S5定义了通用的访问L1的接口。S5开发完毕后，由R1的管理员安装到P1，R1的应用A1可以使用S5在P1上访问账本L1的数据。A1，P1和O4都加入到了通道C1.

A1 使用R1的CA1颁发的证书，A1可以连接到P1，O4，A1必须通过S5 来更新L1。

智能合约可以有每个组织创建，然后被分发到网络中的每个节点。智能合约必须先在节点安装，然后在通道初始化后才能使用。

S5开发完毕，R1的管理者必须先将S5 安装到P1，此时S5就可以访问P1的账本L1的数据了。但此时C1并不知道，所以需要在通道C1进行初始化。使用P1在C1初始化S5，初始化后，S5在C1上可见，所有连接到C1的组件都可以感知到S5。此时连接到C1的A1就可以调用S5了。

虽然C1可以使用S5，但是无法看到S5的代码逻辑。这是因为只有安装S5的P1可以看到。



> 初始化的是接口，安装的是实现。

初始化S5时需要指定背书策略：描述了哪些组织必须同意，才能最终更新账本状态。如可以指定S5的背书策略是：R1 OR R2。初始化将S5的背书策略保存到CC1中，可以被C1 中的其他组件读取到。只要R1活着R2中的一个背书后，更新就可以应用到账本L1中了。

智能合约初始化后，A1就可以向需要背书的节点发送交易请求，这将作为智能合约的输入。节点收到交易请求，生成背书的交易响应，返回给A1。如果合法且满足背书策略，将广播到整个网络。

智能合约安装可以进行多次，在多个节点进行，但是在同一个通道的初始化只需要一次。

现在，组织R1已经深度参与网络中，启动A1 —>通过S5访问L1，生成交易，由R1背书，最后更新L1。

## 2.7 R2加入P2

![加入R2的P2Peye.com](http://upload-images.jianshu.io/upload_images/4000-ad6e682c8f4d4714.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

同理，R2管理员创建P2，将P2加入C1，有应用A2。A1和A2 都可以在C1调用S5.

安装了S5的节点可以运行S5，没有安装的可以通过C1获取S5提供的接口。

安装了智能合约的节点可以生成交易和背书。没有安装的节点验证交易，然后接受或者拒绝应用交易到本地的账本。

Fabric中节点可以分为以下几种角色：
1. [Committing peer](https://hyperledger-fabric.readthedocs.io/en/latest/glossary.html#commitment)。每个加入通道的都是[Committing peer](https://hyperledger-fabric.readthedocs.io/en/latest/glossary.html#commitment)，接受交易区块，验证，应用到本地的账本副本。
1. [Endorsing peer](https://hyperledger-fabric.readthedocs.io/en/latest/glossary.html#endorsement)。安装了智能合约的节点，
1. [Leader peer](https://hyperledger-fabric.readthedocs.io/en/latest/glossary.html#leading-peer). 负责分发排序服务的数据，可以静态配置或者动态选举。提高弹性和扩展性，提高吞吐率。
1. [Anchor peer](https://hyperledger-fabric.readthedocs.io/en/latest/glossary.html#anchor-peer). 和其他组织中的节点通信。跨组织通信。

上述都只是角色，一个节点可以同时扮演。一个Fabric网络至少又一个leader peer和一个endorsing peer和一个commiting peer。


## 2.8 增加新的联盟

新建联盟X2，包含R2和R3，R2和R3使用独立的通道通信。

![创建新的联盟](http://upload-images.jianshu.io/upload_images/4000-874c822a0f9f65bb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

网络管理员R1或者R4增加新的联盟X2，包含R2和R3，用于创建新的通道C2。X2被加入到NC4中。

通道C2只能有网络管理员R1或者R4创建，分离管理网络层面的资源和管理通道层面的资源。分层的管理策略结构。

## 2.9 增加新的通道

![创建新的通道](http://upload-images.jianshu.io/upload_images/4000-c6adadde9d52b091.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

新的通道C2创建，用于X2中R2和R3的通信。通道配置是CC2，和NC4完全隔离。C2由R2和R3管理，由CC2定义权限。R1和R4没有定义CC2的权限。

CC1和CC2互相隔离，同时与NC4互相隔离。

## 2.10 网络和通道配置

> 网络配置或者通道配置的变化都是通过配置交易来实现，并生成配置区块。

配置中包含了经过组织成员达成一致的策略信心。控制网络资源的权限。

NC4控制了网络的权限。CC控制通道的权限。

每个网络有一个NC4，每个通道有一个CC。每个访问网络或者通道的组件必须遵循这些配置规定的权限策略。

逻辑上一份，但是会被复制到不同的组件。每个节点会有其加入的通道的CC，排序服务会有网络配置的副本。

使用区块链技术保证各个副本的一致性。改变配置，必须有管理员提交配置变更交易，必须遵循配置修改mod_policy。

排序服务使用系统通道分发配置交易，保证排序服务的每个节点中配置信息的一致性。同理是通道配置的同步，在应用通道中分发。

> 逻辑上一份，物理上多份。是Hyperledger Fabirc的通用设计模式。如配置，智能合约，账本等。

保证系统是分布式特性，同时保证易于管理。

## 2.11 增加节点

加入R3的节点。

![image](http://upload-images.jianshu.io/upload_images/4000-7cceb205ebccad50.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

现在N包括两个通道C1和C2。

A1和A2，P1和P2， O4加入C1，使用账本L1。
A3，P3和O4加入C2，使用账本L2。

S6在P3安装，在C2初始化，访问L2。A3可以调用S6

分布式系统，L1和L2隔离，控制和自治的权衡和妥协。通过通道和网络的配置来实现隔离性。

##  2.12 节点加入多个通道

![image](http://upload-images.jianshu.io/upload_images/4000-9e354f5f75ecdfd5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

网络N中有两个通道C1和C2。P2同时加入C1和C2。

A1可以通过C1月P1和P2通信，使用O4。
A2可以通过C1和P1和P2，以及通过C2与P2和P3-3通信，使用O4
A3可以通过C2与P3通信，使用O4。

O4同时和C1和C2通信。

通道提供通信隔离，也提供不同组织之间的通信。

P2的权限在C1是由CC1控制，在C2由CC2控制。
R1 和R2确定C1的权限策略。
R2和R3确定C2的权限策略。

A2可以同时在C1和C2上运行。

## 2.13 排序服务的扩容

O4 有R4在创建网络是添加。R1提供O1，R4提供O4.NC4确定了R1和R4的权限策略。

![排序服务扩容](http://upload-images.jianshu.io/upload_images/4000-8bdcf8768d3ee914.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

排序服务除了是网络的管理起点之外，还提供排序后交易的分发。收集背书后的交易，加入到区块中，人后分发到通道的每个节点上，每个节点验证交易，如果有效应用交易到本地的账本上。

在通道层面，排序服务收集交易生成区块，分发区块，权限和策略由CC1确定。

在网络层面，排序服务提供对网络中资源的管理，权限和策略由NC4确定。

网络中的组件都是分布式的，如排序服务，无论是作为管理的起点，还是作为通道的交易分发。可以在联盟中的多个组织内部署排序服务。

## 2.14 修改策略
> Fabirc中的声明式策略配置。策略由联盟中的成员达成一致，同时控制了联盟成员的权限。

策略控制系统中组件的行为。

支持策略的修改。策略的变化是常态，如新成员加入，已有成员退出等。

修改策略，是第一等的策略，管理策略的变化，元策略。

网络初始时，在NC4中只有R4可以管理网络资源。如果R1想加入，R4将通道创建策略和联盟创建策略授予R1。

此时R1将拥有相应的权限。R1和R4具有对等的网络管理权限

R4可以将R1加入到mod_policy，这样R1也可以像R4一样管理网络策略的变化。

R1甚至可以移除R4，但一般R4会配置R4必须同意策略的变化，或者所有成员必须同意策略的变化。

mod_policy允许网络策略的修改和演化。定义了允许修改mod_policy的组织信息。

# 3 最终的网络

![最终的网络](http://upload-images.jianshu.io/upload_images/4000-cce30545ed3a9b36.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

Fabric区块链网络包含两个应用通道一个排序通道。

R1和R4管理排序通道。
R1和R2管理蓝色的应用通道。
R2和R3管理红色的应用通道。

A1属于R1，使用CA1获取证书。R2的P2可以同时和蓝色和红色的通道通信。

每个通道都有自己的通道配置。系统通道的配置在网络配置NC4中。

部署了两个智能合约，一个排序服务。

# 4 总结

本文介绍了如何在不同的组织之间构建Hyperledger Fabric的区块链网络。网络中的应用、节点，管理员，排序服务如何被识别和标识，以及策略的修改机制。

# 5 参考资料

1. https://hyperledger-fabric.readthedocs.io/en/latest/network/network.html