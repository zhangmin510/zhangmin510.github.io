title: 利用Java Service Wrapper将Java应用程序发布为Service
tags:
  - Java
  - 技术
id: 2003
categories:
  - Java
date: 2013-10-25 16:23:54
---

[Java Service Wrapper](http://wrapper.tanukisoftware.com/doc/english/download.jsp) 主要用于包装其他java服务器端程序（比如tomcat，或者自己开发的java服务器程序），提供如下特性：

*   作为windows服务或者unix守护进程运行；*   增强程序的可靠性，程序崩溃后的自动重启，比如内存溢出，虚拟机崩溃等造成JVM退出的监控和恢复运行（重新启动）；*   标准的，可独立使用的配置JVM参数的脚本；*   支持java应用程序重启JVM，比如应用程序修改了配置文件，或者重启系统避免内存溢出等问题；*   灵活的配置；*   简化应用程序的安装；*   记录日志。

本文将以Java Service Wrapper的第四种集成方法WrapperJarApp。利用WrapperJarApp helper类来启动应用程序。该方法用于配置和运行可执行jar文件。

### 将所需文件放到应用目录下

下载windows平台下的Java Service Wrapper，将src/bin中的App.bat.in，InstallApp-NT.bat.in，和UninstallApp-NT.bat.in拷贝到你的AppDir目录的bin中，去掉这些文件的.in后缀。然后将src/conf下的wrapper.conf.in几conf下的wrapper-license.conf复制到AppDir的conf目录中。将你lib下的wrapper.dll，wrapper.jar及你自己的应用程序的jar包放到AppDir的lib目录下。最终的目录结构如下所示：
[java]
AppDir/bin
--------App.bat
--------InstallApp-NT.bat
--------UninstallApp-NT.bat
--------wrapper.exe
------/conf
--------wrapper.conf
--------wrapper-license.conf
------/lib
--------App.jar
--------wrapper.dll
--------wrapper.jar
------/logs
[/java]

### 修改配置文件wrapper.conf

[java]
wrapper.java.command=javaw
wrapper.java.mainclass=org.tanukisoftware.wrapper.WrapperJarApp
wrapper.java.classpath.1=../lib/wrapper.jar
wrapper.java.classpath.2=../lib/*
wrapper.app.parameter.1=../lib/App.jar
wrapper.name=App
wrapper.displayname=MyAppService
wrapper.description=MyAppService
[/java]

### 启动App和安装，卸载App Service

点击App.bat启动App。点击InstallApp-NT.bat 安装到windows service，UninstallApp-NT.bat 删除windows service。