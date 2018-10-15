title: Hyperledger-Fabric的交易处理流程
tags: [Hyperledger Fabric, 区块链]
date: 2018-10-11 19:09:05
updated: 2018-10-11 19:09:05
---

# 开篇

Hyperledger Fabric各个组件模块是如何交互的。

交易是如何处理的，即账本数据是如何达成共识并修改的？


# 账本数据结构

![账本包括世界状态快照和区块链](https://hyperledger-fabric.readthedocs.io/en/latest/_images/ledger.diagram.1.png)


![世界状态快照](https://hyperledger-fabric.readthedocs.io/en/latest/_images/ledger.diagram.3.png)



![区块链](https://hyperledger-fabric.readthedocs.io/en/latest/_images/ledger.diagram.2.png)



![区块](https://hyperledger-fabric.readthedocs.io/en/latest/_images/ledger.diagram.4.png)


![区块中的交易](https://hyperledger-fabric.readthedocs.io/en/latest/_images/ledger.diagram.5.png)

每笔交易包括以下关键字段：
1. Header。包括交易的元信息，如链码及其版本。
2. Signature。应用使用私钥对交易数据签名，可以验证数据有没有被修改。
3. Proposal。调用智能合约的参数。
4. Response。背书模拟执行交易后生成的读写集合。
5. Endorsements。背书策略规定的，每个背书节点的对当前交易的背书信息。


![示例的账本数据](https://hyperledger-fabric.readthedocs.io/en/latest/_images/ledger.diagram.6.png)


LevelDB默认世界状态数据存储引擎，简单的键值对。嵌入到Peer的进程中运行。

CouchDB可选数据引擎，适用于有结构的JSON数据，提供复杂查询。运行在额外的进程中，

# 读写集

在背书过程中，会模拟执行交易，会生成一个读写集。

读集合包括交易执行时需要读取的键值及其版本。当前的版本是基于已经提交的区块高度就是最新的版本。
写集合包括交易执行时需要更新的键值。如果是删除会设置删除标记。

多次写只保留最后一次的结果。不支持读取当前交易修改后的值，即只返回已经提交的值，而不是模拟执行修改后的值。

一个读写集合示例：

为了简单版本使用的是自增值。

```
<TxReadWriteSet>
  <NsReadWriteSet name="chaincode1">
    <read-set>
      <read key="K1", version="1">
      <read key="K2", version="1">
    </read-set>
    <write-set>
      <write key="K1", value="V1"
      <write key="K3", value="V2"
      <write key="K4", isDelete="true"
    </write-set>
  </NsReadWriteSet>
<TxReadWriteSet>
```

账本更新：


```
World state: (k1,1,v1), (k2,1,v2), (k3,1,v3), (k4,1,v4), (k5,1,v5)
T1 -> Write(k1, v1'), Write(k2, v2') 有效交易
T2 -> Read(k1), Write(k3, v3') 无效交易，因为k1被T1修改了
T3 -> Write(k2, v2'') 有效交易
T4 -> Write(k2, v2'''), read(k2) 无效交易，k2被T3修改了
T5 -> Write(k6, v6'), read(k5) 有效交易
World state: (k1,2,v1'), (k2,3,v2''), (k3,1,v3), (k4,1,v4), (k5,1,v5)，(k6, v6')
```

目前只支持一个交易一个读写集合。


# 交易处理流程

## 交易即将要发生的网络环境

两个组织要发生交易，通过Fabirc网络完成。

两个组织R1和R2，每个组织有Peer，P1和P2以及应用A1和A2。证书管理CA1和CA2
以及相应的MSP1和MSP2。


两个Peer加入了通道C。每个Peer都安装了智能合约S，智能合约在通道C上初始化完毕。智能合约中包含了交易逻辑：如报价，确认等操作。

通道C的账本是L。

智能合约的背书策略：P1和P2必须同时背书交易。

排序服务O1.

应用A1和A2分别获取了CA1和CA2颁发的证书和私钥信息。

假设A1是买方，A2是卖方。


![Fabirc区块链网络中的节点，账本和智能合约](https://hyperledger-fabric.readthedocs.io/en/latest/_images/peers.diagram.1.png)

一个节点可以加入多个通道，因而维护多个账本，每个通道一个账本。
可以安装多个智能合约，


## 交易流程

1. 发起交易。A1发送请求到P1和P2，由智能合约S的背书策略决定。
2. 背书交易。背书节点P1和P2验证交易请求格式，是否重复，签名合法性（使用节点的MSP），写权限检查（使用通道配置）。验证通过后，将交易请求作为参数，调用智能合约S，智能合约在当前账本状态上执行，生成交易结果（读写集），但并不修改账本状态。将生成的交易结果作为背书响应发送给A1。
3. 验证背书。验证背书响应的签名，并比响应内容是否相等。如果是查询请求，交易就此结束。如果是写请求，验证背书策略是否满足，将交易请求和背书响应发送到排序服务O1.交易信息包括读写集，背书节点的签名，通道信息。
4. 排序交易。排序服务O1将所有收到的交易，按照通道名称和时间进行排序，创建区块。验证交易，标记交易是否有效。并将区块广播发送到所有加入通道的节点。
5. 账本更新。每个节点收到区块后，将该区块追加到当前通道区块链的尾部，对于有效的交易，根据读写集合更新账本数据。发送事件告知客户端交易已经提交到账本，处理完毕。

![交互图](https://hyperledger-fabric.readthedocs.io/en/latest/_images/flow-4.png)

# 应用与Fabric的交互流程

节点在区块链网络中非常重要，最基本的元素。因为节点上维护通道的账本数据，安装了智能合约。其他元素Other elements of the blockchain network are of course important: ledgers and smart contracts, orderers, policies, channels, applications, organizations, identities, and membership。

账本不可变的记录了所有由智能合约生成更新。

> 账本和智能合约分别封装了共享的信息和共享的流程。

是理解Fabric网络绝佳的起点。应用必须先和节点通信才能调用智能合约，进而访问账本数据。




![应用和节点，智能合约，账本，排序服务的交互图](https://hyperledger-fabric.readthedocs.io/en/latest/_images/peers.diagram.6.png)


![节点和通道的关系](https://hyperledger-fabric.readthedocs.io/en/latest/_images/peers.diagram.5.png)

通道是逻辑上的，由物理的多个节点组成。节点提供管理和访问通道的起点。


![节点和组织的关系](https://hyperledger-fabric.readthedocs.io/en/latest/_images/peers.diagram.8.png)

多个组织，贡献节点资源，组成网络，进行交易。是分布式的。非中心化的。每个组织的应用可以不同，来访问自己维护节点上的账本数据。

读操作可以只连接本组织的节点，但是更新，需要连接多个节点，以满足背书策略。


![节点和数字证书的关系](https://hyperledger-fabric.readthedocs.io/en/latest/_images/peers.diagram.9.png)

节点连接到通道，通道的配置中有对应数字证书及其颁发CA和组织的关系，即ORG1.MSP。

通道配置策略判断证书是否有权限访问。MSP完成证书和组织的对应关系。

在区块链网络中交互，需要有证书和关联的MSP才能进行。证书的办法者决定了当前节点是属于哪一个组织，
而不是其实际部署的物理位置。

# 写交易更新流程

节点和排序服务一起，保证每个节点的数据是一致的。

## 执行阶段


![节点和排序服务关系-发起交易](https://hyperledger-fabric.readthedocs.io/en/latest/_images/peers.diagram.10.png)

发起交易，并签名请求（包含目标链码，参数，nonce去重，交易ID——客户端id和nonce生成），发送到需要背书的节点。链码初始化时指定背书策略。

每个节点独立模拟执行交易，使用本地的账本数据，生成背书响应，并签名，返回给应用。每个链码操作的状态是隔离的，不能被其他链码访问。链码不能维护状态缓存，必须使用GetState，PutState，DelState操作账本数据。
生成写集合以及依赖的读集合。

客户端收集所有的别墅响应。如果返回的结果不同，应用需要重试，来获取最新的状态。并比较每个背书的结果是否一致。应用必须收集到满足背书策略的所有背书响应。如果结果不一致，应用可以直接丢弃，提前终止，否则，更新账本时也会失败，无效的交易。

### 为什么这么设计

背书模拟执行时没有同步，可能使用不同的账本数据状态，产生不同的输出。如果对同一个键值有并发竞争访问，
那么将无法满足背书策略。

这里就是一个与经典的主从复制系统的不同之处，不同的节点不可信，可能产生不同的结果。

之所以采用这个架构是由于简单，而且可以满足典型区块链应用的需求。执行时需要去掉对相同键值的竞争访问。

在排序阶段之前就模拟执行交易，是能够容忍链码非确定性的关键。链码中存在不确定性交易的只能危害
自己的操作，而且客户端不能收集到满足背书策略的响应。

这个比order-execute中非确定性的操作导致节点的不一致状态情况更容易接受。

容忍非确定性执行也避免了不可信链码的DoS攻击。背书节点可以直接根据本地的策略丢弃。不会影响整个系统。
但是对于order-execute架构中这样的丢弃是不允许的。


## 排序阶段

客户端收集到满足背书策略的响应后，就可以将交易和背书结果发送到排序服务进行排序。


![节点和排序服务关系-打包](https://hyperledger-fabric.readthedocs.io/en/latest/_images/peers.diagram.11.png)

区块中交易的顺序可能和发生交易的顺序不同。区块中的顺序才是最终执行的顺序。

Fabric的区块中不会有重复的交易，一个交易也不能出现在多个区块中。排序后，交易在区块中的顺序就确定了。
不能再被改变。

批量处理提升性能。

### 为什么这么设计

排序服务不维护任何区块链的状态，不验证，也不执行任何交易。这个特性使得fabric可以分离共识和执行以及验证。

使得共识可以可插拔。

## 验证阶段

排序后的节点被发送到连接到通道的每个节点。

![节点和排序服务关系-验证](https://hyperledger-fabric.readthedocs.io/en/latest/_images/peers.diagram.12.png)

收到新的区块后，验证步骤，按照顺序执行：
1. 并行验证背书策略是否满足。通过Validation System chaincode（VSCC），如果不满足，交易被标记为无效，将不会更新账本数据。
2. 顺序检查读写集合是否冲突。如果读版本不符合，交易标记为无效，不会更新账本数据。
3. 更新本地账本。链接到本地的区块链。


验证交易的背书策略是否满足，标记交易是否有效（与从排序服务收到的唯一的不同之处），无效交易也被加入区块用于审计。按照区块中交易的顺序执行对账本的更新。

智能合约只需要安装到需要背书的节点，而不需要再所有节点，满足保密性。

### 为什么这么设计

账本的区块链中可能包含无效的交易，因为排序服务对链码状态，区块，验证都是无知的。验证时在共识后进行的。非法交易用于审计。

# 参考资料

1. [Transaction Flow](https://hyperledger-fabric.readthedocs.io/en/latest/txflow.html)
2. [Ledger](https://hyperledger-fabric.readthedocs.io/en/latest/ledger/ledger.html)
2. [Read-Write Set](https://hyperledger-fabric.readthedocs.io/en/latest/readwrite.html)
3. [Peers](https://hyperledger-fabric.readthedocs.io/en/latest/peers/peers.html)
4. [Hyperledger Fabric: A Distributed Operating System
for Permissioned Blockchains](https://arxiv.org/abs/1801.10228v1)