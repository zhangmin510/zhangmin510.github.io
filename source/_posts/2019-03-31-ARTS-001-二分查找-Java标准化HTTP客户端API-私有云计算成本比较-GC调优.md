title: ARTS-001-二分查找-Java标准化HTTP客户端API-私有云计算成本比较-GC调优
tags: ARTS
categories: ARTS
date: 2019-03-31 17:24:39
updated: 2019-03-31 17:24:39
---
# Algorithm

详见博文[二分查找](/blog/2019/03/31/二分查找/)。

# Review

本周review的文章是[JEP 321: HTTP Client (Standard)](https://openjdk.java.net/jeps/321)，相关的是[JEP 110: HTTP/2 Client (Incubator)](https://openjdk.java.net/jeps/110)。定义了Java语言中的标准的HTTP客户端API。

这个HTTP客户端在JDK 9中孵化，在JDK 10中更新。新版本的API在包`java.net.http`中实现。

## 概要

定义了全新的HTTP客户端API，实现了HTTP/2和WebSocket。可以替代HttpURLConnection的API。在JDK 9中孵化。孵化的类库不是Java SE的一部分，在jdk.incubtor命名空间下，在编译和运行时不会默认解析。

## 动机

**现有的类库存在的问题**

现有的HttpURLConnection API及其实现存在很多问题：
1. URLConnection面向多种协议而设计，现如今很多协议已经不存在了，如ftp，gopher等。
1. 这个API早于HTTP/1.1，并且过于抽象。
1. 难以使用，存在很多未进行文档化的行为结果。
1. 只能工作在阻塞模式。每个请求/响应一个线程。
1. 很难维护。

## 目标

**设计标准的HTTP客户端API需要考虑考虑的内容：API的易用性，支持的功能，对新语言特性的友好程度，性能，内存占用，同已有类库的比较**

1. 在通用场景下简单易用，包括简单的阻塞模式。
1. 提供通知事件机制，如收到消息头，收到消息响应等。不一定适用回调函数实现，可以使用异步机制如CompletableFuture。
1. 简单简洁的API，只暴露必要的能力，满足80-90%的应用需求。
1. 暴露整个HTTP协议的流程。
1. 支持标准和常见的认证机制。
1. 支持WebSocket握手机制。
1. 支持HTTP/2。支持协议协商，从HTTP/1.1到HTTP/2或者，直接使用HTTP/2。必须支持服务端推送。
1. 支持安全检查，使用已有的网络API。
1. 对新语言特性友好，如lambda表达式。
1. 对嵌入式设备友好，避免持久运行计时器线程。
1. 必须支持HTTPS/TLS。
1. HTTP/1.1的性能要求：
  - HttpURLConnection的实现性能一致
  - Apache HttpClient类库和Netty以及Jetty的客户端API。
  - 内存消耗要小于HttpURLConnection，Apache HttpClient以及Netty和Jetty的客户端API。
1. HTTP/2的性能要求：
  - 必须比HTTP/1.1性能高，如可扩展性，延迟等，不受平台的限制，如TCP分段，ACK窗口。
  - 必须和Netty和Jetty的HTTP/2客户端API的性能相近
  - 内存使用必须少于或者持平HttpURLConnection, Apache HttpClient, and Netty and Jetty的HTTP/2客户端
1. 性能比较必须是在可比较的使用模式下。毕竟新的API抢到简单和易于使用。
1. 在JDK 9中实现。代码可能在Serverlet 4.0 API复用，所以只能使用JDK 8的语言特性。
1. 可能在JDK 10中放到java.net命名空间下

## 非目标

一些其他的需求如请求响应过滤，可插拔的连接缓存，通用的升级机制。

## 描述

原型版本的实现基于NIO SocketChannel，异步模式是基于`Selectors`和外部提供的`ExecutorServices`。

标准化的HTTP客户端API提供非阻塞的请求和响应语义，通过`CompletableFuture`实现。通过`java.util.concurrent.Flow` 提供背压和流控制。可以方便的追踪整个流程：从请求到相应，到底层的`socket`。

最新的类库文档是：[HTTP Client javadoc](https://cr.openjdk.java.net/~chegar/httpclient/02/javadoc/api/java.net.http/java/net/http/package-summary.html)


## 其他选择

其他选择比较重量级，如Apache HttpClient以及Jetty。没有使用新语言特性，如lambda表达式。

## 参考资料

1. [HTTP Client](https://openjdk.java.net/groups/net/httpclient/)

# Tips

本周的Tips分享的是Java 8的垃圾回收器调优技巧[Java Platform, Standard Edition HotSpot Virtual Machine Garbage Collection Tuning Guide](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/toc.html)

详见博文[JDK8 GC性能调优指南](/blog/2019/03/31/JDK8-GC性能调优指南/)

# Share

本周分享的文章是[The Cloud Is Just Someone Else's Computer](https://blog.codinghorror.com/the-cloud-is-just-someone-elses-computer/)

使用mini-pc作为服务器来使用和使用云计算服务，哪一个成本更低？

作者评估托管的个人mini-pc和云计算的成本比较。估算mini-pc在cpu满负荷下的寿命， 一般5年，但保守以3年进行计算：

```
Let's break this down and see what the actual costs of colocating a Mini-PC are versus the cloud. Given the plateauing of CPU speeds, I think five years of useful life for these boxes is realistic, but let's assume a conservative three year lifespan to be safe.

$880 mini-pc 32GB RAM, 6 CPUs, 500GB SSD
$120 taxes / shipping / misc
$29 × 12 × 3 = $1,044

That's $2,044 for three years of hosting. How can we do on Digital Ocean? Per their current pricing page:

32GB RAM, 8 vCPUs, 640GB SSD
$160/month
$160 × 12 × 3 = $5,760

```

云环境提供不可比拟的灵活性和冗余。如果使用时间很长，而不是简单的测试或者试验，使用完全属于自己的机器组成的`云计算`，是云计算三分之一的成本。而且在云环境中，CPU和内存是多租户共享的。

也许对于创业公司，使用自己搭建的`私有云`成本反而是最低的。但这里没有考虑其他的成本，如云环境管理，各种PaaS服务的便利性等。创业公司可以综合评估应用场景，选择云计算还是选择私有云。