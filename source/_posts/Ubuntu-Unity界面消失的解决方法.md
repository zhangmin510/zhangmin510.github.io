title: Ubuntu Unity界面消失的解决方法
tags:
  - Linux
  - Ubuntu
id: 624
categories:
  - linux
date: 2012-04-14 16:21:58
---

![ubuntu_logo](http://www.zhangmin.name/blog/wp-content/uploads/ubuntu_logo_black-orange-300x67.png)

在Ubuntu 11.10中，修改Compizconfig-settings- 时，由于禁止了某些必要的插件，使得Unity界面消失了，没有了Lancher，标题栏也消失了，在网上看了很多的资料，解决方法如下：

重新设置Unity，打开Terminal(ctr+alt+f1 或是alt+f2,输入gnome-terminal)输入：

`sudo apt-get install compizconfig-settings-manager`

`sudo unity --reset`

一般情况下需要一分钟的时间重置unity，在运行过程中可能会出现控制台没有任何反馈输入，保险起见，两到三分钟后再按ctr+c终止程序。

然后重新启动GDM 或是 LightDM(如果termianl 不好使可以进入tty1，ctrl+alt+f1)，命令如下：

`sudo service gdm restart`

或是

`sudo service lightdm restart`

如果上述方法不成功，你可以重新按转compiz和unity，命令如下：

`sudo apt-get update

	sudo apt-get install compiz

	sudo apt-get install compizconfig-settings-manager

	sudo apt-get install unity`

然后再重启GDM或是LightDM。

如果你的窗口标题栏消失了，可以用一下的命令：

`gtk-window-decorator --replace`