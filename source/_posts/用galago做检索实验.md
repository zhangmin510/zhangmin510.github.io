title: 用galago做检索实验
tags:
  - 技术
id: 1331
categories:
  - MSE
date: 2013-04-20 22:14:54
---

Galago 是一个开源的搜索引擎工具箱，用于学习和测试新的搜索引擎技术。Galago 包含一个类似于 MapReduce 的分布式计算框架。
可以使用的数据集 Wiki Small 和 Wiki Large。Wiki small 和 Wiki Large 来自维基百科。所有的页面包括只包含文本内容，且被处理为 corpus 格式，这种格式易于随机读写且容易被 galago 处理。Wiki Large 数据集包含 5%的维基百科英文版数据（2008 年）。Wiki Small 包含 Wiki Large 的 5%的内容。两个数据集大小分别为 36MB 和 715MB。下载地址为：http://www.search-engines-book.com/collections/。
首先对于大小两个数据集分别建立索引
./galago build wsindex ./wiki-small.corpus
./galago build wlindex ./wiki-large.corpus
其次，设置不同的并发数及检索个数对系统进行检索。并发检索的脚本如下：
#!/bin/bash
for ((i=0;i<$1;i++));do
{
./galago batch-search --index=w$2index ./query$3 && echo "done"
}&
done wait
参数一为并发数，参数二为大小数据集选择，参数三为query数。
其中query的格式是
[java]
&lt;parameters&gt;
&lt;query&gt;
  &lt;number&gt;1&lt;/number&gt;
  &lt;text&gt;  what articles exist which deal with tss  time sharing system   an operating system for ibm computers   &lt;/text&gt;
&lt;/query&gt;
&lt;/parameters&gt;
[/java]
最后，利用 linux shell 的 time 命令记录时间，收集完数据后制图。