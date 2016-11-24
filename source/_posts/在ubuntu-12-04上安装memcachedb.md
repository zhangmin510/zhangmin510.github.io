title: 在ubuntu 12.04上安装memcachedb
tags:
  - Ubuntu
  - 技术
id: 1479
categories:
  - 学习笔记
date: 2013-05-05 23:59:53
---

在Ubuntu上安装memcachedb非常简单:
[java]
sudo apt-get install memcachedb
[/java]
**测试memcachedb**
[java]
telnet 127.0.0.1 21201
Trying 127.0.0.1...
Connected to 127.0.0.1.
Escape character is ’^]’.
set test 0 0 4
1234
STORED
get test
VALUE test 0 4
1234
END
[/java]
**php测试**
[java]
&lt;?php
$mem = new Memcache;
$mem-&gt;connect(&quot;127.0.0.1&quot;, 21201);
$mem-&gt;set('key1', 'This is a memcachedb test!', 0, 60);
$val = $mem-&gt;get('key1');
echo $val;
echo $mem-&gt;get('test');
?&gt;
[/java]
以上测试输出结果为：

This is a memcachedb test!

1234

**启动关闭memcachedb**

[java]
sudo /etc/init.d/memcachedb stop
sudo /etc/init.d/memcachedb start
[/java]