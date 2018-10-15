---
title: 为什么要有Hyperledger-Fabric.md
date: 2018-10-11 09:19:24
tags: [Hyperledger Fabric, 区块链]
---
# 1 区块链是什么

一句话给区块链下一个定义：
> 区块链就是一个存储着一系列不可变交易的账本，这个账本由网络中对等的节点共同维护，每个节点维护一个账本的副本；通过共识协议，将修改账本的交易进行验证后，打包成一个新的区块，这个新的区块指向前一个区块。

# 2 区块链技术的关键组成部分

## 2.1 分布式的账本（共享的信息）

账本保存了所有在网络中发生的交易信息，是区块链的核心。之所以是分布式的，是由于账本会在参与的成员节点上进行复制，这些成员之间需要进行协作，对应真实现实中不同企业的商品和服务交易。

区块链上的信息是只可以追加，并且使用密码学技术来保证交易一旦追加到区块链中，就不会被篡改，从而保证账本的不可变性。不可变性是证明所有权或者溯源的关键特性，因为每个参与者都可以确认账本没有被恶意的修改，这也是为什么区块链被称为是证据系统(System of Proof)。

![分布式账本技术（来源：https://hyperledger-fabric.readthedocs.io/en/latest/_images/basic_network.png）](http://upload-images.jianshu.io/upload_images/4000-984ad411fd493a01.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## 2.2 智能合约（共享的操作）

智能合约在区块链中可以提供一种一致性的对共享账本的数据更新。如交易，查询。

![智能合约（来源：https://hyperledger-fabric.readthedocs.io/en/latest/_images/Smart_Contract.png）](http://upload-images.jianshu.io/upload_images/4000-a9523dfe9daaec19.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

智能合约不仅包装了访问和修改共享账本的机制，还可以执行自动化的交易，如执行合约。比如可以根据快递的送达时间来自动计算快递的费用。只要双方关于这个合约达成一致，当快递签收，费用会自动计算。

## 2.3 共识协议（共享的保障）

在整个区块链网络中同步账本数据的过程，保证账本的更新是由整个网络的参与者同意。账本以相同的交易数据、相同的更新顺序更新账本，这个过程就叫做共识。共识协议负责在参与成员之间保证账本数据的复制和更新的一致性。

![共识（来源：https://hyperledger-fabric.readthedocs.io/en/latest/_images/consensus.png）](http://upload-images.jianshu.io/upload_images/4000-498391a8e558e7fa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# 3 为什么比特币和以太坊等公链不适合企业服务

首先企业级服务需要更高的性能，当前公链的性能难以满足，如以太坊的`25TPS`。

其次企业级服务参与成员的身份是必须的，特别是在金融交易中需要KYC（Know Your Customer）和AML（Anti-Money Laundering）法规。

对于企业级服务中的区块链技术，需要满足以下几个方面的需求：
1. 参与成员不能是匿名的，必须有身份，可以被识别。
1. 网络的参与权限需要控制。
1. 高吞吐率。
1. 低延迟。
1. 隐私保护和加密交易数据。

# 4 为企业服务而生的Hyperledger Fabirc

Linux基金会在2015年建立Hyperledger项目，为了推进跨行业的区块链技术应用。该项目不是提出一套区块链标准，而是通过社区合作开发，版权开放，采用关键标准和技术。

Hyperledger Fabric是模块化、可插拔的设计。企业可以根据具体的应用场景实现选择具体的实现。如可插拔的账本数据存储，可插拔的共识模块和可插拔的成员服务等。

Hyperledger Fabric由以下几个模块组成，来满足企业级服务需求：
1. 成员服务Member Service Provider）。管理参与节点的身份信息，将加密数字证书和成员身份关联。
1. 共享的账本。账本包括世界状态（world state）和交易日志。世界状态是交易日志的快照数据，可以通过重放所有交易日志来构建。
1. 支持通用语言的智能合约。即链码(chaincode)，可以被外部应用调用，应用只能通过链码和账本进行交互，一般链码只和世界状态进行交互，而不是交易日志。链码可以使用多种编程语言编写，当前支持go和node。
1. 可插拔的共识协议。区块链服务中的交易必须按照发生的顺序写入的账本中。在多方参与的情况下，必须要确定交易的顺序，拒绝不合法的交易，将合法的交易追加的账本中。共识是可插拔的，选择不同的共识算法，最适合应用场景。如隐私保护，网络的结构。当前只有SOLO和kafka的共识机制。
1. 隐私保护。可以创建通道channel，允许一部分参与者之间独立的账本数据通信。比如厂家，分销商，零售商之间。报价是私密的，两两之间保密。

# 5 参考资料
1. https://hyperledger-fabric.readthedocs.io/en/latest/blockchain.html
1. https://hyperledger-fabric.readthedocs.io/en/latest/functionalities.html