title: 配置storm开发环境
tags:
  - storm
id: 997
categories:
  - MSE
date: 2013-03-16 23:20:47
---

本文介绍如何配置storm开发环境。总体来说有以下两个步骤：
下载storm发布版本，解压，将bin/目录添加到当前环境变量中。
为了能够在远程集群启动和停止topology，将storm集群信息写到~/.storm/storm.yaml中。

**什么是开发环境**

Storm有两种模式：本地模式和远程模式。
Storm开发环境就是将所有storm相关的软件安装完毕，可以在storm本地模式下测试storm topology。将一个打包的topology上传到远程集群上，运行或杀死topology。

**在本地安装storm发布版本**

为了能够将storm topology从本地提交到远程storm集群，你需要在本地安装storm发布版本。安装后会有一个storm客户端是你能够和远程storm集群通信及交互。如果只是在本地进行开发和测试topology，建议你使用maven将storm开发依赖包含到你的项目中。

**在集群上启动和停止topology**

安装storm客户端后，你就可以与远程storm集群交互了。首先你需要告诉storm将要和那个集群通信。为了实现这一目的你需要将主机地址添加到~/.storm/storm.yaml文件中。如下所示：
Nimbus.host: “123.45.43.56”
另外，如果使用storm-deploy项目在AWS上部署storm，将会自动设置。可以使用attach命令连接到一个storm集群。
Lein run:deploy --attach --name mystormcluster

_注：以上内容翻译自https://github.com/nathanmarz/storm/wiki/Setting-up-development-environment_