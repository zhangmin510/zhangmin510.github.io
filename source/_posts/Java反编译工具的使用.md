title: Java反编译工具的使用
tags:
  - Java
id: 664
categories:
  - Java
date: 2012-04-24 14:34:10
---

![java](http://www.zhangmin.name/blog/wp-content/uploads/java.jpg)在学习和开发Java程序工程中，我们经常会用到第三方的类库。为了更好的实用类库，我们可能需要研究类库的源代码，正所谓知其然，还要知其所以然。通常情况下，这些类库都提供源代码，但有的类库只提供jar包，此时，java反编译工具就可以大战拳脚了。

**常见的java反编译工具**

*   Java反编译器 Java Decompiler

&nbsp;这款反编译器叫 &quot;Java Decompiler&quot;, 由 Pavel Kouznetsov开发，目前最新版本为 0.2.5\. 它由 C++开发，并且官方可以下载 windows、linux和苹果Mac Os三个平台的可执行程序。

*   Java反编译工具 jad

jad 是一个使用非常广泛的 Java 反编译工具。

*   Java反编译插件 Jadclipse

Jadclipse 是一个集成Eclipse 的Java反编译插件

*   Java 反编译器 JD-GUI

JD-GUI 是一个用 C++ 开发的 Java 反编译工具，由 Pavel Kouznetsov开发，支持Windows、Linux和苹果Mac Os三个平台。

*   Java反编译器 jdec

jdec是一个Java反编译器。它能够把出现在一个.class文件中的字节码还原成Java源代码，反编译的结果几乎与原始Java文件相同。它还自带一个利用swing开发的用户操作界面。

*   dex2jar

dex2jar 是一个用来将 Android 的 Dalvik Executable (.dex) format 文件转成 Java 类文件的工具。

*   Java Class文件的反编译工具 uuDeJava

uuDeJava是Java Class文件的反编译工具。反编译的Java源程序被输出到Class的相同目录。内部使用jad.exe。 反编译Class文件时，可以直接点击Class文件(关联后)，或者选中文件或目录发送到uuDeJava的快捷方式。还可以拖动文件或目录到uuDeJava的主窗口。

	**Jad 的使用**

Jad是一个使用非常广泛的java反编译工具，跨平台。Jad支持内部类和匿名类的反编译。

jad下载地址：[http://www.varaneckas.com/jad](http://www.varaneckas.com/jad)

常用命令如下：

	反编译单个文件

`jad -sjava example.class`

默认情况下会生成.jad的文件，通过选项-sjava可以生成.java文件。

反编译多个文件

`jad -o -r -sjava -dsrc tree/**/*.class`

此命令的意思是将tree下的所有.class文件反编译，并按照tree下的层及目录组织，最后放到src目录下。

在下载jad压缩包的README文件中有详细地命令使用介绍。