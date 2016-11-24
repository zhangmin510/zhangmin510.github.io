title: Storm配置
tags:
  - storm
id: 1003
categories:
  - MSE
date: 2013-03-15 23:23:47
---

每一个配置默认值保存在default.ymal中，可以通过覆盖这些配置文件来修改配置信息。在Nimbus和Supervisor的classpath中。最后，你可以定义特定topology的配置，使用StormSubmitter与你的代码一起提交。然而，特定topology的配置只能覆盖有TOPOLOGY前缀的配置属性。
Storm 0.7.0及以后的版本支持单个bolt和spout的配置，可以覆盖的配置有：

"topology.debug"
"topology.max.spout.pending"
"topology.max.task.parallelism"
"topology.kryo.register": 这一个与其他的略有不同，因为序列化在topology中的所有模块都是可用的。

Java API提供两种配置方法：
内部的：覆盖getComponentConfiguration。在任意spout或bolt返回特定模块的配置Map。
外部的：TopologyBuilder的setSpout返回的对象有方法addConfiguration及addConfigurations配置特定的配置项。
配置的优先级如下:
Default.ymal &lt; storm.ymal &lt; topology specific config &lt; internal &lt; external component config.

注：以上内容翻译自https://github.com/nathanmarz/storm/wiki/Configuration