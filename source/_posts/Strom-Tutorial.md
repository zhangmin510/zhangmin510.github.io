title: Strom Tutorial
tags:
  - storm
id: 1148
categories:
  - MSE
date: 2013-03-30 15:57:39
---

本教程你将学到如何创建storm topology及如何将topology部署到storm集群。Java将是主要使用的语言，但有一些示例使用Python，用以说明storm的多语言特性。
**预备内容**
本教程将使用[storm-starter](https://github.com/nathanmarz/storm-starter "storm starter")项目，建议克隆该项目并了解该项目的最新情况。阅读[如何配置开发环境和创建新的storm项目](http://www.zhangmin.name/blog/?p=997 "配置storm环境")正确配置你的开发环境。

**Storm集群的组成**
一个storm集群与hadoop集群在表面上相似，然而在hadoop上运行MapReduce jobs，在storm上运行topology。Jobs和topology是不同的。一个关键的不同之处就是一个MapReduce job最终会结束，而一个topology会不停地处理消息（直到你主动的停止它）。
Storm集群中有两种类型的节点：master节点和worker节点。Master节点运行一个叫守护进程叫Nimbus，该进程与hadoop的JobTracker相似.Nimbus 负责在集群分发代码，分配任务到机器，监控任务的执行。

每一个worker节点运行一个守护进程叫Supervisor,监控Nimbus分配给本机worker的任务，按照需要开始和停止worker进程。每一个worker进程执行topology的一个子集，一个运行的topology包括多个worker进程且分布在多个机器上。

所有Nimbus和Supervisor之间的协作通过ZooKeeper集群完成。另外，Nimbus和Supervisor守护进程能够快速重启且是无状态的。所有的状态信息保存在ZooKeeper中或本地磁盘上。这意味着你可以kill -9杀死Nimbus和Supervisor进程，但是它们很快重启就像什么都没发生一样。这一设计使得storm非常稳定。

[![storm-cluster](http://www.zhangmin.name/blog/wp-content/uploads/2013/03/storm-cluster.png)](http://www.zhangmin.name/blog/wp-content/uploads/2013/03/storm-cluster.png)

**Topology **

在storm上进行实时计算，你需要创建topology。一个topology是计算的表示方式。Topology中每一个节点包含处理逻辑，节点之间的连接表示数据将如何传输。运行一个topology的非常简单。首先，将所有的代码及依赖的库打包为一个jar文件，然后运行以下命令：

[java]storm jar all-my-code.jar backtype.storm.MyTopology arg1 arg2[/java]

该命令运行类backtype.storm.MyTopology，参数是arg1,arg2。该类的函数定义了topology。Storm jar命令负责连接到Nimbus，并上传jar文件。

因为topology定义是Thrift结构，Nimbus是Thrift服务，你可以利用任意语言创建和提交topology，以上的命令用于部署基于JVM的语言。参考 在集群上运行topology 获取更多信息。

**流**

Storm的核心抽象是流。流是无限的元组序列。Storm提供操作原语，以一种分布式的方式处理和变换流。例如，将twitter流转换为话题流。Storm提供基本的流变换原语包括spout和bolt。可以实现spout和bolt提供接口实现应用逻辑。

Spout和bolt打包为一个topology，一种更高层次的抽象。用于在storm集群上执行。一个topology是流变换或处理的一张图。图中每个节点代表spout或bolt，边代表bolt订阅了那些流。当一个spout或bolt将元组转换为流后，它将产生的流发送到所有订阅了该流的bolt。节点之间的边表示数据的传递路线。例如如果spoutA和boltB之间有一个连接，同样，spoutA和boltC之间也有一个连接，boltB和boltC之间有一个连接。然后，每一次spoutA发送一个元组，它将发送该元组到boltB和boltC。所有boltB的输出都将发送到boltC。

Storm topology的每个节点都是并行执行的，可以在你的代码中设置并行度。然后storm将产生相应数量的线程在整个集群中执行。

一个topology将永远运行，或者你可以停止它。Storm将自动分配执行失败的任务。另外，storm确保没有数据丢失，即使是机器宕机或消息被放弃。

[![topology](http://www.zhangmin.name/blog/wp-content/uploads/2013/03/topology.png)](http://www.zhangmin.name/blog/wp-content/uploads/2013/03/topology.png)

**数据模型**

Storm的数据模型就是元组（Tuple），一个元组就是一系列命名的值，每一个值可以是任何类型的对象。Storm创造性的支持原始数据类型，字符串，字节数组作为元组的值。如果使用其他类型的数据对象，只需要实现相应类型的Serializer.

每一个节点必须声明要输出的元组的字段（域），例如下面的bolt声明发送2个含有域double和triple的元组。

[java]public class DoubleAndTripleBolt extends BaseRichBolt {
    private OutputCollectorBase _collector;
   @Override
    public void prepare(Map conf, TopologyContext context, OutputCollectorBase collector) {
       _collector = collector;
    }
    @Override
    public void execute(Tuple input) {
        int val = input.getInteger(0);
        _collector.emit(input, new Values(val*2, val*3));
        _collector.ack(input);
    }
   @Override
    public void declareOutputFields(OutputFieldsDeclarer declarer) {
        declarer.declare(new Fields(&quot;double&quot;, &quot;triple&quot;));
    }
}[/java]

declareOutputFields 函数声明输出域包含[“double”,“triple”]。其余的部分将在后面介绍。

**一个简单的Topology**

让我们先来看一个简单的topology来理解这一概念及如何使用代码进行表示。我们来看一个来自storm-starter项目的ExclamationTopology的定义。

[java]TopologyBuilder builder = new TopologyBuilder();
builder.setSpout(&quot;words&quot;, new TestWordSpout(), 10);
builder.setBolt(&quot;exclaim1&quot;, new ExclamationBolt(), 3)
        .shuffleGrouping(&quot;words&quot;);
builder.setBolt(&quot;exclaim2&quot;, new ExclamationBolt(), 2)
        .shuffleGrouping(&quot;exclaim1&quot;);
builder.setBolt(&quot;exclaim2&quot;, new ExclamationBolt(), 5)
            .shuffleGrouping(&quot;words&quot;)
            .shuffleGrouping(&quot;exclaim1&quot;);
[/java]

这个topology包含一个spout和两个bolt。Spout发送单词words。每个bolt追加字符串”!!!”。节点被排成一列。Spout发送到第一个bolt，然后再由第一个bolt发送到第二个bolt。如果spout发送元素[“bob”]和[“john”]，那么第二个bolt将发送words [“bob!!!!!”]和[“john!!!!!”]。

这段代码用setSpout和setBolt方法定义节点。这些方法将用户指定的id，一个包含处理逻辑的对象，代码处理的并行度作为参数。在这个示例中，spout的参数id是words，bolt的用户指定id是exclaim1和exclaim2.

包含处理逻辑的对象实现了spout的IRichSpout接口及bolt的接口IRichBolt。最后一个参数是代码执行的并行度，是可选的。并行度表示在集群上有多少线程执行该任务。如果你忽略它，storm的默认值为每个节点一个线程。

setBolt返回一个InputDeclarer对象用于定义bolt的输入。这里组件“exclaim”声明它将以随机分组的方式读取所有exclaim1发送到元组。

随机分组的意思是元组将从输入任务随机分发到bolt任务。有很多的方法在组件之间对数据流进行分组。后面将会进一步阐释。

如果你想组件exclaim2读取由组件words和exclaim1发送的所有元组，你可以这样定义exclaim2：

[java]builder.setBolt(&quot;exclaim2&quot;, new ExclamationBolt(), 5)
            .shuffleGrouping(&quot;words&quot;)
            .shuffleGrouping(&quot;exclaim1&quot;);[/java]

由此可见，输入声明可以以链式的方式指定bolt的多个数据源。

让我们深入spout和bolt来看一下它们的实现。Spout负责向topology发送新消息，TestWordSpout随机的每100ms从字符串元组["nathan", "mike", "jackson", "golda", "bertels"]选择一个元素作为一个元组进行发送。nextTuple的实现如下：

[java]public void nextTuple() {
    Utils.sleep(100);
    final String[] words = new String[] {&quot;nathan&quot;, &quot;mike&quot;, &quot;jackson&quot;, &quot;golda&quot;, &quot;bertels&quot;};
    final Random rand = new Random();
    final String word = words[rand.nextInt(words.length)];
    _collector.emit(new Values(word));
}[/java]

ExclamationBolt向输入追加字符串“!!!”，下面我们看一下ExclamationBolt的实现 ：

[java]public static class ExclamationBolt implements IRichBolt {
    OutputCollector _collector;
    public void prepare(Map conf, TopologyContext context, OutputCollector collector) {
        _collector = collector;
    }
    public void execute(Tuple tuple) {
        _collector.emit(tuple, new Values(tuple.getString(0) + &quot;!!!&quot;));
        _collector.ack(tuple);
    }
   public void cleanup() {
    }
   public void declareOutputFields(OutputFieldsDeclarer declarer) {
        declarer.declare(new Fields(&quot;word&quot;));
    }
    public Map getComponentConfiguration() {
        return null;
    }
}[/java]

Prepare函数给bolt提供一个OutputCollector用于从Bolt发送元组。元组可以在任何时候发送。在prepare，execute，或者cleanup方法中，甚至在其他异步线程中。该prepare函数简单的保存OutputCollector实例，以便在随后的execute方法中使用。

Execute方法接受从一个bolt发送来的元组。ExclamationBolt获取元组的第一个域的值，并发送另一个元组，该元组的域的值是被添加“!!!”后的新值。

如果一个bolt的实现订阅了多个输入流，可以利用Tuple.getSourceConponent方法获得该Tuple的源。

另外，输入元组被当做第一个参数传送给emit。最后要对输入元组进行确认。这是storm保证没有数据丢失的可靠性API中的一部分，后面讲详细介绍。

当bolt被关闭时，需要清理打开的资源时会调用cleanup方法。在集群上能保证该方法会被调用。例如，如果一台机器正在运行，就没有办法调用该方法。一般情况下，会在本地模式运行topology时才会调用cleanup方法。你可以运行或停止任何topology而且没有资源的泄漏。

declareOutputFields方法声明ExclamationBolt发送一个名称为word的一元元组。

getComponentConfiguration方法允许你配置该模块将如何运行。将在[配置](http://www.zhangmin.name/blog/?p=1003 "storm配置")一节中详细介绍。

像cleanup和getComponentConfiguration一般不在bolt的实现中，你可以更简便地利用基类定义bolt。ExclamationBolt可以通过继承BaseRichBolt方便地实现，如：

[java]public static class ExclamationBolt extends BaseRichBolt {
    OutputCollector _collector;
    public void prepare(Map conf, TopologyContext context, OutputCollector collector) {
        _collector = collector;
    }
    public void execute(Tuple tuple) {
        _collector.emit(tuple, new Values(tuple.getString(0) + &quot;!!!&quot;));
        _collector.ack(tuple);
    }
    public void declareOutputFields(OutputFieldsDeclarer declarer) {
        declarer.declare(new Fields(&quot;word&quot;));
    }
}[/java]

**在本地运行ExclamationTopology**

Storm中有两种模式：本地模式和分布式模式。在本地模式下，storm完全在进程中模拟执行，用线程模拟工作节点。本地模式用于测试和开发topology。当你运行storm-starter项目里的一个topology时，它们将在本地模式下运行。你可以监控每个模块发送的消息。在本地模式一节将详细介绍。

在分布式模式下，storm在集群上运行。当你把一个topology提交到主节点master，你还需要提交所有相关的代码，master将会负责在集群上分发代码及分配worker执行topology。如果worker失败，master会重新分配该topology。在生产集群上运行topology一节有详细的介绍。

在本地模式下运行topology的代码如下：

[java]Config conf = new Config();
conf.setDebug(true);
conf.setNumWorkers(2);

LocalCluster cluster = new LocalCluster();
cluster.submitTopology(&quot;test&quot;, conf, builder.createTopology());
Utils.sleep(10000);
cluster.killTopology(&quot;test&quot;);
cluster.shutdown();[/java]

首先，上述代码通过创建LocalCluster定义进程内的集群，向该虚拟集群提交topology与向分布式集群提交相同。用方法submitTopology向LocalCluster提交topology，参数是要运行的topology的id，topology的配置信息等。

配置类用于配置topology运行的各个方面。这里有两个配置信息：

TOPOLOGY_WORKERS（用setNumberWorkers指定）。在集群上分配多少进程运行topology。Topology中的每一个模块将在线程中执行。指定模块的线程数量通过setBolt和setSpout设定。这些线程存在于worker进程中，每个worker进程中有若干线程执行topology的各个模块。例如，在你的模块中配置了300个线程，配置50个worker进程。每个worker进程中将执行6个线程。每一个线程可能输入不同的模块。可以通过设置storm topology的每个模块的并行度来调整性能，包括每个进程中有多少线程及多少进程。

TOPOLOGY_DEBUGE （通过setDebug设定）。当设置为真时，storm将记录每个模块每一条发送消息的日志。在本地模式下测试topology将会非常有用。当然，在真实集群上，你需要关闭它。

当然，还有很多的配置方面配置topology，可以查看Javadoc的Config获得更多配置信息。

**流分组**

流分组告诉topology如何在两个模块之间发送元组。注意，spout和bolt在集群上以多任务的方式并行执行。如果想了解一个topology在任务级如何运行，可以看下面的例子。

[![topology-tasks](http://www.zhangmin.name/blog/wp-content/uploads/2013/03/topology-tasks.png)](http://www.zhangmin.name/blog/wp-content/uploads/2013/03/topology-tasks.png)

Bolt A的一个任务发送一个元组到Bolt B的那个任务呢？

流分组回答了这一问题。通过告诉storm如何在任务集合之间发送元组。在深入流分组之前，我们先来研究一下storm-starter的另一个topology。WordCountTopology从流和spout读取语句，然后经过WordCountBolt处理后，输出所有的单词及每个单词的计数。

[java]TopologyBuilder builder = new TopologyBuilder();
builder.setSpout(&quot;sentences&quot;, new RandomSentenceSpout(), 5);
builder.setBolt(&quot;split&quot;, new SplitSentence(), 8)
        .shuffleGrouping(&quot;sentences&quot;);
builder.setBolt(&quot;count&quot;, new WordCount(), 12)
        .fieldsGrouping(&quot;split&quot;, new Fields(&quot;word&quot;));[/java]

SplitSentence将它接受的句子里的每一个单词生成一个元组，WordCount在内存中保存一个Map&lt;Word,Count&gt;。当WordCount收到一个单词更新单词的计数，并生成一个新的&lt;Word,Count&gt;。这里有不同种类的流分组。

最简单的流分组就是随机分组，将元组随机地发送到一个任务。在WordCountTopology中，随机分组将元组从一个RandomSentenceSpout发送到SplitSentence bolt，它将在所有的SplitSentence bolt中均匀分发元组。

一个更有意思的分组就是域分组，该分组方式用于从SplitSentence bolt到一个WordCount bolt。必须严格保证WordCout bolt相同的单词又如同一个任务进行处理。否则，多于一个任务处理该单词，每个将生成错误的计数。因为每一个都没有完整的信息。域分组将域相同的额元组交由一个相同的任务进行处理。

由于WordCount利用域分组订阅了SplitSentence的输出流，相同的单词将有同一个任务处理，最后改该bolt将输出正确的结果。

域分组是完全流合并和流聚集的基础，同样也是其他应用的基础。域分组是用模哈希实现的，还有其他类型的分组，详见 [概念](http://www.zhangmin.name/blog/?p=1001 "storm 概念") 一节。

**用其他语言定义bolt**

Bolt可以用任意的语言进行定义，通过使用其他语言定义bolt将以子进程的方式执行，storm通过基于JSON的标准输入输出协议与之通信。通信协议只需要100行的适配器库，storm已经提供了的库包括Ruby，Python和Fancy。这里是WordCountTopology里的SplitSentence bolt的定义：

[java]public static class SplitSentence extends ShellBolt implements IRichBolt {
    public SplitSentence() {
        super(&quot;python&quot;, &quot;splitsentence.py&quot;);
    }
    public void declareOutputFields(OutputFieldsDeclarer declarer) {
        declarer.declare(new Fields(&quot;word&quot;));
    }
}[/java]

SplitSentence覆盖了ShellBolt并声明了用Python编写的处理类。下面是splitsentence.py的是实现：

[java]import storm
class SplitSentenceBolt(storm.BasicBolt):
    def process(self, tup):
        words = tup.values[0].split(&quot; &quot;)
        for word in words:
          storm.emit([word])
SplitSentenceBolt().run()[/java]

关于如何用其他语言编写Spout和Bolt及如何创建topology详见如何在storm中定义非JVM语言。

**保证消息处理**

详见 保证消息处理一节。

**事务Topology**

Storm保证消息在topology至少被处理一次，一个明显的问题就是storm是如何计数的，会不会过度计数。Storm的一个特性就是事务topology，可以确保精确一次的消息语义。详见[原理](http://www.zhangmin.name/blog/?p=1001 "storm 原理")一节。

**分布式RPC**

详见具体的章节

**总结**

本教程宏观的介绍了storm的开发，测试，部署storm topology的方法，其余的文档将详细介绍storm的各个方面。

_本文翻译自https://github.com/nathanmarz/storm/wiki/Tutorial_