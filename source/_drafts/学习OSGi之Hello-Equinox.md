title: 学习OSGi之Hello Equinox
tags:
  - OSGi
id: 1831
categories:
  - MSE
---

Equinox是Eclipse中的项目，并作为OSGi R4 RI 而知名，由于Equinox有Eclipse IDE这个成功案例，反映出了Equinox作为OSGi框架的优势。Equinox目前是随着Eclipse版本发布的。同时也提供独立的版本下载。

1.  开发环境的准备

        现在的eclipse都已经包含了Equinox，无需单独下载。

2.  开发OSGi的HelloWorld应用程序

    在这一节，我们将开发一个OSGi bundle，演示如何利用Equinox进行OSGi bundle的开发、运行及调试，为之后的示例做准备。
   首先，新建一个Plug-in工程，如下图所示：
有过eclipse插件开发经验的人应该很快就能明白，这就是该工程——实际上就是上一篇文章中所称的bundle在Equinox平台中的启动入口，相当于我们的熟悉的main函数，如果将该bundle运行到Equinox中，首先进入该bundle的是Activator的start方法，你可以将相关的服务、资源在该方法内完成向bundleContex

    在弹出的对话框中，新建一个OSGi Framework运行环境（双击OSGi Framework即可，这里为其取名Equinox），选中helloworld(1.0.0)，然后点击右边的Add Required Bundles按钮，eclipse将自动选中运行helloworld的依赖bundle，如果有必要，可以点击右下的Validate Bundles验证按钮，验证程序正常运行所需的bundle是否都被选中，最后点击运行，回到控制台：
osgi> Hello World!
    可以看到，之前在Activator的start方法中的输出语句已经被输出到控制台，我们可以通过命令ss查看Equinox的运行情况，可以看到一共运行了两个bundle，如下：
ss`Framework is launched.</p>

<p>id State       Bundle
0 ACTIVE      org.eclipse.osgi_3.4.3.R34x_v20081215-1030
1 ACTIVE      helloworld_1.0.0`

_参考：http://www.blogjava.net/benniaolk/articles/316755.html_

**出现问题的解决方法**

在用ECLIPSE调试OSGI时出现异常错误无法开打OSGI>

[html][/html] view plaincopy
!SESSION 2013-05-13 22:50:24.171 -----------------------------------------------

eclipse.buildId=unknown

java.version=1.7.0_21

java.vendor=Oracle Corporation

BootLoader constants: OS=win32, ARCH=x86, WS=win32, NL=zh_CN

Command-line arguments:  -dev file:C:/Documents and Settings/Administrator/Documents/workspace-sts-3.2.0.RELEASE/.metadata/.plugins/org.eclipse.pde.core/New_configuration/dev.properties -os win32 -ws win32 -arch x86 -consoleLog -console

!ENTRY org.eclipse.osgi 4 0 2013-05-13 22:50:25.000

!MESSAGE Could not find bundle: org.eclipse.equinox.console

!STACK 0

org.osgi.framework.BundleException: Could not find bundle: org.eclipse.equinox.console

    at org.eclipse.osgi.framework.internal.core.ConsoleManager.checkForConsoleBundle(ConsoleManager.java:211)

    at org.eclipse.core.runtime.adaptor.EclipseStarter.startup(EclipseStarter.java:297)

    at org.eclipse.core.runtime.adaptor.EclipseStarter.run(EclipseStarter.java:176)

    at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)

    at sun.reflect.NativeMethodAccessorImpl.invoke(Unknown Source)

    at sun.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source)

    at java.lang.reflect.Method.invoke(Unknown Source)

    at org.eclipse.equinox.launcher.Main.invokeFramework(Main.java:629)

    at org.eclipse.equinox.launcher.Main.basicRun(Main.java:584)

    at org.eclipse.equinox.launcher.Main.run(Main.java:1438)

    at org.eclipse.equinox.launcher.Main.main(Main.java:1414)

但是选种org.eclipse.equinox.console时还是会报错,那时因为OSGI组建之间存在依赖关系,要使用org.eclipse.equinox.console必须要有它需要依赖的OSGI组建,因此在调试时,除了选择自己编写的OSGI组建还要选择

[html][/html] view plaincopy
org.apache.felix.gogo.command

org.apache.felix.gogo.runtime

org.apache.felix.gogo.shell

org.eclipse.equinox.console

问题解决成功出现OSGI>
[html][/html] view plaincopy
osgi> ss

"Framework is launched."

id  State       Bundle

0   ACTIVE      org.eclipse.osgi_3.8.2.v20130124-134944

1   ACTIVE      BundleBase_1.0.0.qualifier

2   ACTIVE      BundleCnService_1.0.0.qualifier

3   ACTIVE      BundleEnService_1.0.0.qualifier

8   ACTIVE      org.apache.felix.gogo.runtime_0.8.0.v201108120515

9   ACTIVE      org.apache.felix.gogo.shell_0.8.0.v201110170705

10  ACTIVE      org.apache.felix.gogo.command_0.8.0.v201108120515

11  ACTIVE      org.eclipse.equinox.console_1.0.0.v20120522-1841

osgi>

_参考：http://blog.csdn.net/reaganjava/article/details/8923054_