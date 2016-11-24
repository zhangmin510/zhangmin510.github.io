title: Ubuntu 13.04 自定义Grub
tags:
  - Linux
  - 技术
id: 1885
categories:
  - linux
date: 2013-09-01 10:35:26
---

在windows直接安装ubuntu后，windows的启动项会变成最后一项，为了将windows设为默认启动项，可以尝试以下几种方法：

1.安装启动管理器

[shell]sudo apt-get install startupmanager[/shell]

安装好后打开应用程序将windows设置为默认启动项就可以了。

2.更改grub配置文件（也是最基本的方法)

在/etc/grub.d目录下有几个文件。默认情况下win7对应的文件名是30_os-prober，第一个linux系统对应的是10-linux，00是header，05是debian-theme，可见10是第一个启动项，只需要更改win7的文件名(06-09均可)即可改变启动顺序。

[shell]
sudo mv /etc/grub.d/30_os-prober /etc/grub.d/08_os-prober
sudo update-grub（这个命令会重新生成/boot/grub/grub.cfg）
[/shell]

3.安装GRUB Customizer

Ubuntu 13.04下通过PPA安装，打开终端，输入命令：

[shell]
sudo add-apt-repository ppa:danielrichter2007/grub-customizer
sudo apt-get update
sudo apt-get install grub-customizer
[/shell]

安装好后打开软件设置即可。

参考文章:
1.http://www.linuxidc.com/Linux/2013-05/84109.htm
2.http://www.th7.cn/system/win/201305/39122.shtml 