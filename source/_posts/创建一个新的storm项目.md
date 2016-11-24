title: 创建一个新的storm项目
tags:
  - storm
id: 999
categories:
  - MSE
date: 2013-03-12 23:46:02
---

**主要步骤包括：**

1.  将storm jars添加到classpath
2.  如果使用multilang，添加multilang目录到classpath
**添加storm jars 到classpath**

建议使用maven。Storm-starter使用Leinigen建立依赖。
如果在Eclipse中设置classpath，创建一个新的java项目，将src/jvm作为源文件路径，确保所有在lib中的jars和lib/dev中的jars文件都添加到了Reference Libraries.

**如果使用multilang，添加multilang目录到classpath**

如果使用其他语言来实现spout和bolt，这些实现安放到了项目的multilang/resources目录下，为了使storm在本地模式找到这些文件。Resources目录要添加到classpath中。在Eclipse中，你可以添加multilang作为一个源文件夹。你还需要添加multilang/resources作为源文件夹。
你可以通过运行WordCountTopology.java来检测是否配置成功。如果配置成功你将看到在控制台上不断地有消息在发送。

以上内容翻译自：https://github.com/nathanmarz/storm/wiki/Creating-a-new-Storm-project