title: Ubuntu下死机的处理方法总结
tags:
  - Ubuntu
id: 343
categories:
  - linux
date: 2011-04-05 17:17:26
---

<div id="_mcePaste">
<div id="_mcePaste">当电脑死机时，在windows下可以按ctrl+alt+delete,然后杀死相关进程，然后就一切OK。</div>
<div id="_mcePaste">但是在Ubuntu下，又该如何呢？你是选择强按电源键5秒关机，还是等待ubuntu恢复，还是愿意尝试一下下面的方法？</div>
<div id="_mcePaste">方法一：默认控制台</div>
<div id="_mcePaste">按Ctrl+Alt+F1~F6组合中的任意一组，切换到tty（ubuntu下默认的控制台），然后输入ubuntu的帐号及密码，查看进程 ps -ef，也可以用命令top,查看占用内存和cpu的最高的几个进程，然后杀死相应的进程sudo kill -9 pid，然后按Ctrl+Alt+F7返回到图形界面。特别邪恶的一个想法：按Ctrl+Alt+F8，电脑进入黑屏状态，只有一个光标在闪，不知者一定会认为是死机了或是更惨一点儿，被入侵了。其实，按Ctrl+Alt+F7就可以回到图形界面。（注：Ctrl+Alt+F8为未定义终端）</div>
<div id="_mcePaste">方法二：SysRq</div>
<div id="_mcePaste">1.SysRq的启用与关闭</div>
<div id="_mcePaste">要想启用SysRq,需要在配置内核时设置MagicSysRqkey(CONFIG_MAGIC_SYSRQ)为Y.对于支持SysRq的内核,/proc/sys/kernel/sysrq控制SysRq的启用与否.如果/proc/sys/kernel/sysrq内容为0,则SysRq被禁用;如果/proc/sys/kernel/sysrq内容为1,则SysRq被启用.关于/proc/sys/kernel/sysrq的更多描述,请参考/Documentation/sysrq.txt</div>
<div id="_mcePaste">可通过运行命令echo"0"&gt;/proc/sys/kernel/sysrq和echo"1"&gt;/proc/sys/kernel/sysrq暂时启用或禁用SysRq.如果需要永久启用或者禁用SysRqs,则可在/etc/sysctl.conf中设置kernel.sysrq=1(启用SsyRq)或kernel.sysrq=0(禁用SysRq)</div>
<div id="_mcePaste">2.SysRq的使用</div>
<div id="_mcePaste">sysrq功能被打开后，有几种sysrq事件能被触发。不同的内核版本可能会有些不同。但有一些是共用的:</div>
<div id="_mcePaste">　　* m - 导出关于内存分配的信息</div>
<div id="_mcePaste">　　* t - 导出线程状态信息</div>
<div id="_mcePaste">　　* p - 到处当前CPU寄存器信息和标志位的信息</div>
<div id="_mcePaste">　　* c - 故意让系统崩溃(在使用netdump或diskdump的时候有用)</div>
<div id="_mcePaste">　　* s - 即时同步所有挂载的文件系统</div>
<div id="_mcePaste">　　* u - 即时重新挂载所有的文件系统为只读</div>
<div id="_mcePaste">　　* b - 即时重新启动系统</div>
<div id="_mcePaste">　　* o - 即时关机(如果机器设置并支持此项功能)</div>
<div id="_mcePaste">在终端上同时按Alt,SysRq和命令键则会执行SysRq命令,SysRq键就是"PrentScreen"健.比如Alt SysRq b则重启机器.</div>
<div id="_mcePaste">如果使用telnet或ssh连接到服务器则可以使用echo &gt;/proc/sysrq-trigger的方式执行SysRq命令,比如echo 'b' &gt;/proc/sysrq-trigger重启系统.</div>
<div id="_mcePaste">3.常用的SysRq命令(序列)</div>
<div id="_mcePaste">3.1重启机器的SysRq命令序列是k(SAK)s(sync)u(umount)b(reboot)</div>
<div id="_mcePaste">3.2显示内存信息的SysRq命令是m(memory)</div>
<div id="_mcePaste">3.3显示当前任务信息的SysRq命令是t(task)</div>
<div id="_mcePaste">参考网页：</div>
<div id="_mcePaste">http://www.cublog.cn/u2/77009/showart_1142804.html</div>
<div id="_mcePaste">http://hi.baidu.com/mhpy/blog/item/32ff46238fe43e5a9822ed13.html</div>
<div id="_mcePaste">http://blog.csdn.net/yhjhoo/archive/2009/12/27/5085103.aspx</div>
</div>