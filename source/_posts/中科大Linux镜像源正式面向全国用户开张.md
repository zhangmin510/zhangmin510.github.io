title: 中科大Linux镜像源正式面向全国用户开张
tags:
  - Ubuntu
id: 365
categories:
  - linux
date: 2011-05-09 22:34:13
---

新闻来源:中国科技大学

经过大半个星期的迁移和新脚本的测试，现在mirrors.ustc.edu.cn已经基本稳定了。

新机器的域名：

IPv4/v6: mirrors.ustc.edu.cn  （能解析出教育网/电信/v6地址）

v4only:  mirrors4.ustc.edu.cn （能解析出教育网/电信地址）

v6only:  mirrors6.ustc.edu.cn

有些地方（比如我测试的合肥长宽），DNS会解析出电信地址，但使用教育网地址访问更快，这时可以通过修改hosts指定强制使用教育网地址访问。

教育网ip：202.38.95.110

电信ip：202.141.160.110

v6地址：2001:da8:d800:95::110

支持的访问方式：

http/ftp/rsync

提供的服务：

原debian.ustc.edu.cn和oss.ustc.edu.cn提供的镜像服务基本上都迁移过来了，除fedora/ubuntu-partner外。fedora正在进行同步，ubuntu-partner也会在近几天同步过来。

原centos.ustc.edu.cn提供的centos/epel/linux-2.6.git也已经迁移过来了。

需要注意的修改：

debian.ustc.edu.cn
和oss.ustc.edu.cn两个域名已经设置为mirrors.ustc.edu.cn的别名，大多数镜像的相对地址没有改变，所以大家基本上不需
要对原有设置进行修改（如sources.list），可以继续正常使用。但是以下镜像用户请注意：

1\. gentoo用户，原portage地址：

[rsync://oss.ustc.edu.cn/pub/gentoo-portage](rsync://oss.ustc.edu.cn/pub/gentoo-portage) 已经调整为：

[rsync://mirrors.ustc.edu.cn/gentoo-portage](rsync://mirrors.ustc.edu.cn/gentoo-portage)

2\. cygwin用户，原cygwin源地址：

[http://oss.ustc.edu.cn/cygwin/cygwin/](http://oss.ustc.edu.cn/cygwin/cygwin/) 已经调整为：

[http://mirrors.ustc.edu.cn/cygwin/](http://mirrors.ustc.edu.cn/cygwin/)

3\. 原ubuntu cdimage地址：

[http://debian.ustc.edu.cn/ubuntu-cd](http://debian.ustc.edu.cn/ubuntu-cd) 已经调整为：

[http://mirrors.ustc.edu.cn/ubuntu-releases](http://mirrors.ustc.edu.cn/ubuntu-releases)

4\. 原fedora linux地址：

[http://oss.ustc.edu.cn/fedora/](http://oss.ustc.edu.cn/fedora/) 已经调整为：

[http://mirrors.ustc.edu.cn/fedora/linux/](http://mirrors.ustc.edu.cn/fedora/linux/)

5\. centos.ustc用户，请修改自己的CentOS-Base.repo和epel.repo，将文件中的域名

centos.ustc.edu.cn 修改为 mirrors.ustc.edu.cn

6\. linux-2.6.git用户，请修改origin地址：

git remote --set-url origin [http://mirrors.ustc.edu.cn/linux-2.6.git](http://mirrors.ustc.edu.cn/linux-2.6.git)

使用帮助：

大多数镜像的使用帮助已经完成，大家在对应的目录下，如：

[http://mirrors.ustc.edu.cn/ubuntu/](http://mirrors.ustc.edu.cn/ubuntu/)

点击页面上方（标题下方）的使用说明链接，可以打开其对应的帮助信息，如如何设置sources.list文件。或者也可以直接打开

[http://mirrors.ustc.edu.cn/mirror-help/](http://mirrors.ustc.edu.cn/mirror-help/)&lt;archive-name&gt;.html

在首页上点击使用说明链接，点击其中对应的源的链接，也可以跳转查看相应的帮助。由于人手不够，有些源还没有使用帮助信息，也欢迎大家帮忙写了，发送给我们。

状态监控：

在首页点击页面上方的同步状态链接，可以查看当前各镜像的同步状态，包括成功与否/上游源/镜像体积等。

大家如果知道更好（更新、更快）的上游源，请联系我们。近期我们会申请成为debian和ubuntu等镜像的官方镜像，这样我们可以获得更好的上游源来同步。

如果同步出现故障，服务器的管理员会收到邮件通知，以尽快处理，所以大家看到状态监控页面中有显示同步失败的条目时，无需联系我们。

如果同步状态上显示同步正常，但实际使用过程中发现镜像有问题，请联系我们。

联系方式：

我们的邮箱： [lug@ustc.edu.cn](mailto:lug@ustc.edu.cn)

鸣谢：

感谢中国科学技术大学、网络信息中心的支持，特别感谢jameszhang老师为我们提供服务器！

PS，我们下一步打算将pxe.ustc.edu.cn也对校外开放，对外提供一些网络启动服务，类似于boot.kernel.org这种。但是由于国内网络速度不行，所以对校外只能提供一些比较小的Live工具，大家可以给我们推荐一些实用的东西。