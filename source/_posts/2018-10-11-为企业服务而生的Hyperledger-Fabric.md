---
title: 为企业服务而生的Hyperledger-Fabric
date: 2018-10-11 09:19:24
tags: [Hyperledger Fabric, 区块链]
---
# 1 为企业服务而生的Fabric

>  No one blockchain to rule them all

Fabric的的设计初心就是面向企业用户，为企业服务而生。Fabric是一个分布式的账本解决方案，提供高级别的数据隐私功能，具有高弹性、灵活性和可扩展性。为了满足各种复杂企业服务的需求，架构被设计为模块化的架构。这样，企业可以根据自身业务场景，定制化Fabric，从而满足自身服务的需求。

# 2 Fabric与公链和其他联盟链的区别

Fabric是在Linux基金会下建立的项目，基于开放的管理模式，社区维护和生态发展。Fabric由多样化的技术团队治理，目前有35+组织，200+开发人员。

Fabric是高度模块化和可配置的架构。灵活，便于创新，可以适用于广泛的应用场景，如银行，金融，保险，医疗，人力资源，供应链，甚至是电子音乐分发。

Fabric是第一个支持使用通用编程语言撰写智能合约（链码）的分布式账本平台，当前支持Java，Go和Node.js。而不是使用DSL（domain-specific language）。

Fabric是一个许可链，参与成员之互相识别身份。参与者之间不是完全信任彼此，但是可以再一个开放的管理模型下，在组织中建立信任和共识，通过法律手段解决冲突和分歧。

Fabric支持可插拔的共识模块。可以根据具体的使用场景和信任模型来选择更有效、更适合的共识算法。比如对于单个企业，或者有信任的机构运行，拜占庭容错共识可能不需要，因为其性能和吞吐率。可以使用 [Crash Fault-Tolerant](https://en.wikipedia.org/wiki/Fault_tolerance) (CFT) ；而在多方参与的网络中，传统的拜占庭容错共识更适合。

Fabric没有原生的数字货币。减少攻击和风险，没有密码学挖矿，意味着系统可以向其他分布式系统一样部署和运营。

Fabric支持交易和智能合约的隐私保护和数据机密性保护。

由于上述Fabric的特点，使得Fabric是一个在交易处理性能，交易确认延迟、交易意思保护方面更优秀。

# 3 Fabric的特点详解 

## 3.1 模块化的架构设计

为了满足企业服务多样化的需求，Fabirc设计为可插拔的架构。可插拔的模块有：
1. 可插拔的成员管理服务（Member Provider Service）。成员管理服务将区块链网络中密码学身份和参与方的现实中的身份关联起来。
1. 可插拔的排序服务（ordering service）。排序服务建立交易的顺序并将排序后的区块广播到加入到同一个通道channel的所有节点。
1. 可插拔的P2P协议，广播区块到节点。
1. 可插拔账本数据存储引擎。当前支持LevelDB和CouchDB。还可以支持DBMS。
1. 可插拔的背书和验证机制。每一个应用可以设置不同的背书和验证策略。

## 3.2  许可链Fabric

公有链每个人都可以参与，参与者之间是匿名的，互相不可信任。为了解决区块链中的信任和共识这个问题，大部分公链使用基于密码学的挖矿技术（如PoW）来达成共识，建立信任。

在许可链中，每个参与成员的身份是确定的。参与的成员有一定程度的信任基础，但是彼此之间不是完全信任对方，通过一个治理模型和共同的目标来达成共识，建立完全信任。因为身份可知，无论是提交交易，修给网络配置，部署智能合约都会被记录，并且有背书策略。另外，在不是完全匿名的情况下，作弊的成员很容易被识别，在共同的治理模型下受到惩罚。在这种场景下，可以使用传统的CFT或者拜占庭容错共识算法，而不需要成本高昂的挖矿。

## 3.3 智能合约的创新之处

智能合约是区块链应用的业务逻辑，通过基于其运行所在的区块链以及底层的共识机制来获取信任，可以安全的修改区块链账本的数据。智能合约有如下特点：
1. 并发运行。
1. 动态部署
1. 代码可能有害。

在大多数具有智能合约的去区块链平台上，如以太坊，[Tendermint](http://tendermint.com/), [Chain](http://chain.com/), and [Quorum](http://www.jpmorgan.com/global/Quorum)，智能合约的执行遵循`order-execute`架构：
1. `order`: 验证和对交易进行排序，然后传播到所有的节点。
1. `execute`: 每个节点顺序的执行交易

在`order-execute`的架构下，由于所有的交易在节点上都是顺序执行的，性能和可扩展性会受限。在每一个节点上执行智能合约需要额外的措施（如以太坊中的gas机制）来保护整个系统，以应对恶意的智能合约代码和保证整个系统的快速恢复能力。

Fabric采取的措施：`execute-order-validate`:

![execute-order-validate](https://upload-images.jianshu.io/upload_images/4000-6daa3b8c5880fb2a.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

1. `execute`: 执行交易，检查交易的正确性，因而背书。
1. `order`: 通过共识协议对交易进行排序，并广播。
1. `validate`: 在将最终的修改提交到账本时，需要验证应用的背书策略

在这种架构下，在执行交易时，此时共识可能还没有达成，是一种比较激进的改变。应用的背书策略可以指定部分节点（子集）来进行，智能合约只由背书的节点执行，从而满足背书策略。这就允许并行的执行，在整个系统中，提高性能和可扩展性。

Fabric的交易处理流程如下：
![Fabric交易处理流程](https://upload-images.jianshu.io/upload_images/4000-42ea562a5a3828c1.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 3.4 数据保护和机密性

在公有链中使用PoW共识机制，交易会在每个节点执行。这就使得智能合约和交易必须公开，对整个网络公开。即PoW共识机制通过牺牲智能合约的保密性来换取拜占庭容错共识。

而在企业应用场景下，如果没有数据隐私保护将是硬伤。如在一个供应链网络中，消费者可能会获得特殊的折扣，如商家的推销或者促销活动。如果每个参与者都知道每一个智能合约和交易，这就意味着商业关系完全透明，每个人都有特殊的折扣。

为了解决缺乏隐私和机密性，对于企业应用场景，可以采用不同策略，每种都有其权衡和妥协。如果加密数据，但是在PoW的共识算法下，加密数据会在每一个节点上，只要节点资源足够，就可能破解。这对于企业数据来说，这种容易泄露的妥协是无法接受的。

零知识证明是另外一种方法，这里的折中是，计算ZKP（zero knowledge proof）需要时间和计算资源。牺牲性能来换机密性。

在联盟链或者许可链，可以使用共识机制，一种方法是限制机密信息的传播，只传播到应该被授权的节点。

Fabric使用通道（channel）架构来实现。建立通道，通道之间隔离。就像覆盖网络（Overlay Network），只有加入到通道的节点可以访问智能合约和交易数据，保证隐私和机密性。

为了改善隐私保护能力，Fabric提供私有数据（Private Data），基于ZKP实现。

## 3.5 性能

影响区块链性能的要素有很多，如每个交易的大小，区块的大小，网络速度以及硬件限制等。Fabric已经有[衡量标准草稿](https://docs.google.com/document/d/1DQ6PqoeIH0pCNJSEYiw7JVbExDvWh_ZRVhWkuioG4k0/edit#heading=h.t3gztry2ja8i)和[基准性能测试工具Hyperledger Caliper](https://wiki.hyperledger.org/projects/caliper)来衡量Fabric的性能

在论文 [Hyperledger Fabric: A Distributed Operating System
for Permissioned Blockchains](https://arxiv.org/abs/1801.10228v1) 中，基于Fabric实现的Fabcoin的性能为：3500TPS，延迟在毫秒级。

# 4 总结

本文介绍了Fabric为满足企业服务开发而采取的架构决策，并详细介绍了Fabric的架构特点。

# 5 参考资料

1. https://hyperledger-fabric.readthedocs.io/en/latest/functionalities.html
1. [Hyperledger Fabric: A Distributed Operating System
for Permissioned Blockchains](https://arxiv.org/abs/1801.10228v1)