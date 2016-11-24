title: 手机共享Windows 7无线网络连接上网
id: 820
categories:
  - 分享
date: 2012-10-18 21:33:51
tags:
---

利用Windows 7 提供网络共享功能，可以将笔记本电脑变成WiFi热点，建立无线局域网。这样你的手机就可以在不买无线路由器的情况下享受宽带的网速了。

下面介绍如何开启Windows 7隐藏的虚拟WiFi和SoftAP功能来实现共享上网。

1）用管理员权限打开cmd，运行命令：netsh wlan set hostednetwork mode=allow ssid=yourid key=yourpwd。命令用法: set hostednetwork [mode=]allow|disallow [ssid=]&lt;ssid&gt;[key=]&lt;passphrase&gt; [keyUsage=]persistent|temporary

参数:

mode 指定允许还是禁止托管网络。
ssid 托管网络的 SSID。
key 托管网络使用的用户安全密钥。
keyUsage 指定用户密钥密钥是永久性的还是临时的。

备注:此命令更改托管网络的属性，包括: 托管网络的 SSID、允许或禁止系统中的托管网络、以及托管网络所使用的用户安全密钥。用户安全密钥应为 8 到 63 个 ASCII 字符组成的字符串，例如，密码，或 64 个十六进制的数字(代表 32 个二进制字节)。

2）命令运行成功之后，网络连接中会多出一个网卡为“Microsoft Virtual WIFI Miniport Adapter”的“无线网络连接 2”

3）然后打开当前你的网络连接的适配器属性——共享，勾选共享Internet连接共享的选项。确定之后，刚才的网络连接会显示“共享的”字样。

4）然后在cmd窗口再输入：netsh wlan start hostednetwork。至此你就可以通过手机的wlan连接共享的无线网络进行上网了。

5）另外，利用命令：netsh wlan show hostednetwork查看共享连接的相关信息。

**相关问题及解决方案：**

出现“Internet连接共享时出现问题。。。”

解决方法：在cmd中输入service.msc，检查windows firewall和Internet Connection sharing(ICS)服务是否开启，如未启动，则启动之。