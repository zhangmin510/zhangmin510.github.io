title: CVS常用命令速查
id: 517
categories:
  - 分享
date: 2012-03-19 21:21:39
tags:
---

作者： 车东 chedong@bigfoot.com
版权声明：可以任意转载，转载时请务必以超链接形式标明文章原始出处和作者信息及本声明
http://www.chedong.com/tech/cvs_card.html
关键词：CVS CVSWeb CVSTrac WinCVS CVSROOT
内容提要：
CVS环境初始化：CVS环境的搭建 管理员
CVS的日常使用：日常开发中最常用的CVS命令， 开发人员 管理员
CVS的分支开发：项目按照不同进度和目标并发进行 管理员
CVS的用户认证：通过SSH的远程用户认证，安全，简单 管理员
CVSWEB：CVS的WEB访问界面大大提高代码版本比较的效率 管理员
CVS TAG：将$Header$加入代码注释中，方便开发过程的跟踪 开发人员
CVS vs VSS: CVS和Virsual SourceSafe的比较 开发人员 管理员
WinCVS: 通过SSH认证的WinCVS认证设置
基于CVSTrac的小组开发环境搭建：通过CVSTrac实现web界面的CVS用户管理及集成的BUG跟踪和WIKI交流。
一个系统20%的功能往往能够满足80%的需求，CVS也不例外，以下是CVS最常用的功能，可能还不到它全部命令选项的20%，更多的功能在实际应用过程中体会，你想用多少就学多少，不时回头看看经常有意外的收获。

CVS环境初始化
============

环境设置：指定CVS库的路径CVSROOT
tcsh
setenv CVSROOT /path/to/cvsroot
bash
CVSROOT=/path/to/cvsroot ; export CVSROOT

后面还提到远程CVS服务器的设置：
CVSROOT=:extUSER@test.server.address#port:/path/to/cvsroot CVS_RSH=ssh; export CVSROOT CVS_RSH

初始化：CVS版本库的初始化。
cvs init

一个项目的首次导入
cvs import -m "write some comments here" project_name vendor_tag release_tag
执行后：会将所有源文件及目录导入到/path/to/cvsroot/project_name目录下
vender_tag: 开发商标记
release_tag: 版本发布标记

项目导出：将代码从CVS库里导出
cvs checkout project_name
cvs 将创建project_name目录，并将最新版本的源代码导出到相应目录中。这个checkout和Virvual SourceSafe中的check out不是一个概念，相对于Virvual SourceSafe的check out是cvs update， check in是cvs commit。

CVS的日常使用
=============

注意：第一次导出以后，就不是通过cvs checkout来同步文件了，而是要进入刚才cvs checkout project_name导出的project_name目录下进行具体文件的版本同步（添加，修改，删除）操作。

将文件同步到最新的版本
cvs update
不制定文件名，cvs将同步所有子目录下的文件，也可以制定某个文件名/目录进行同步
cvs update file_name
最好每天开始工作前或将自己的工作导入到CVS库里前都要做一次，并养成“先同步 后修改”的习惯，和Virvual SourceSafe不同，CVS里没有文件锁定的概念，所有的冲突是在commit之前解决，如果你修改过程中，有其他人修改并commit到了CVS库中，CVS会通知你文件冲突，并自动将冲突部分用
>;>;>;>;>;>;
content on cvs server
<<<<<<
content in your file
>;>;>;>;>;>;
标记出来，由你确认冲突内容的取舍。
版本冲突一般是在多个人修改一个文件造成的，但这种项目管理上的问题不应该指望由CVS来解决。

确认修改写入到CVS库里
cvs commit -m "write some comments here" file_name

注意：CVS的很多动作都是通过cvs commit进行最后确认并修改的，最好每次只修改一个文件。在确认的前，还需要用户填写修改注释，以帮助其他开发人员了解修改的原因。如果不用写-m "comments"而直接确认`cvs commit file_name` 的话，cvs会自动调用系统缺省的文字编辑器(一般是vi)要求你写入注释。
注释的质量很重要：所以不仅必须要写，而且必须写一些比较有意义的内容：以方便其他开发人员能够很好的理解
不好的注释，很难让其他的开发人员快速的理解：比如： -m "bug fixed" 甚至 -m ""
好的注释，甚至可以用中文: -m "在用户注册过程中加入了Email地址校验"

修改某个版本注释：每次只确认一个文件到CVS库里是一个很好的习惯，但难免有时候忘了指定文件名，把多个文件以同样注释commit到CVS库里了，以下命令可以允许你修改某个文件某个版本的注释：
cvs admin -m 1.3:"write some comments here" file_name

添加文件
创建好新文件后，比如：touch new_file
cvs add new_file
注意：对于图片，Word文档等非纯文本的项目，需要使用cvs add -kb选项按2进制文件方式导入(k表示扩展选项，b表示binary)，否则有可能出现文件被破坏的情况
比如：
cvs add -kb new_file.gif
cvs add -kb readme.doc

然后确认修改并注释
cvs ci -m "write some comments here"

删除文件
将某个源文件物理删除后，比如：rm file_name
cvs rm file_name
然后确认修改并注释
cvs ci -m "write some comments here"
以上面前2步合并的方法为：
cvs rm -f file_name
cvs ci -m "why delete file"
注意：很多cvs命令都有缩写形式：commit=>;ci; update=>;up; checkout=>;co/get; remove=>;rm;

添加目录
cvs add dir_name

查看修改历史
cvs log file_name
cvs history file_name

查看当前文件不同版本的区别
cvs diff -r1.3 -r1.5 file_name
查看当前文件（可能已经修改了）和库中相应文件的区别
cvs diff file_name
cvs的web界面提供了更方便的定位文件修改和比较版本区别的方法，具体安装设置请看后面的cvsweb使用

正确的通过CVS恢复旧版本的方法：
如果用cvs update -r1.2 file.name
这个命令是给file.name加一个STICK TAG： "1.2" ，虽然你的本意只是想将它恢复到1.2版本
正确的恢复版本的方法是：cvs update -p -r1.2 file_name >;file_name
如果不小心已经加成STICK TAG的话：用cvs update -A 解决

移动文件/文件重命名
cvs里没有cvs move或cvs rename，因为这两个操作是可以由先cvs remove old_file_name，然后cvs add new_file_name实现的。

删除/移动目录
最方便的方法是让管理员直接移动，删除CVSROOT里相应目录（因为CVS一个项目下的子目录都是独立的，移动到$CVSROOT目录下都可以作为新的独立项目：好比一颗树，其实砍下任意一枝都能独立存活），对目录进行了修改后，要求其开发人员重新导出项目cvs checkout project_name 或者用cvs update -dP同步。

项目发布导出不带CVS目录的源文件
做开发的时候你可能注意到了，每个开发目录下，CVS都创建了一个CVS/目录。里面有文件用于记录当前目录和CVS库之间的对应信息。但项目发布的时候你一般不希望把文件目录还带着含有CVS信息的CVS目录吧，这个一次性的导出过程使用cvs export命令，不过export只能针对一个TAG或者日期导出，比如：
cvs export -r release1 project_name
cvs export -D 20021023 project_name
cvs export -D now project_name

CVS Branch：项目多分支同步开发
=============================

确认版本里程碑：多个文件各自版本号不一样，项目到一定阶段，可以给所有文件统一指定一个阶段里程碑版本号，方便以后按照这个阶段里程碑版本号导出项目，同时也是项目的多个分支开发的基础。
cvs tag release_1_0

开始一个新的里程碑：
cvs commit -r 2 标记所有文件开始进入2.x的开发

注意：CVS里的revsion和软件包的发布版本可以没有直接的关系。但所有文件使用和发布版本一致的版本号比较有助于维护。

版本分支的建立
在开发项目的2.x版本的时候发现1.x有问题，但2.x又不敢用，则从先前标记的里程碑：release_1_0导出一个分支release_1_0_patch
cvs rtag -b -r release_1_0 release_1_0_patch proj_dir

一些人先在另外一个目录下导出release_1_0_patch这个分支：解决1.0中的紧急问题，
cvs checkout -r release_1_0_patch
而其他人员仍旧在项目的主干分支2.x上开发

在release_1_0_patch上修正错误后，标记一个1.0的错误修正版本号
cvs tag release_1_0_patch_1

如果2.0认为这些错误修改在2.0里也需要，也可以在2.0的开发目录下合并release_1_0_patch_1中的修改到当前代码中：
cvs update -j release_1_0_patch_1

CVS的远程认证：通过SSH远程访问CVS
================================

使用cvs本身基于pserver的远程认证很麻烦,需要定义服务器和用户组，用户名，设置密码等，
常见的登陆格式如下：
cvs -d :pserver:cvs_user_name@cvs.server.address:/path/to/cvsroot login
例子：
cvs -d :pserver:cvs@samba.org:/cvsroot login

不是很安全，因此一般是作为匿名只读CVS访问的方式。从安全考虑，通过系统本地帐号认证并通过SSH传输是比较好的办法，通过在客户机的/etc/profile里设置一下内容：
CVSROOT=:extUSER@cvs.server.address#port:/path/to/cvsroot CVS_RSH=ssh; export CVSROOT CVS_RSH
所有客户机所有本地用户都可以映射到CVS服务器相应同名帐号了。

比如:

CVS服务器是192.168.0.3，上面CVSROOT路径是/home/cvsroot，另外一台开发客户机是192.168.0.4，如果tom在2台机器上都有同名的帐号，那么从192.168.0.4上设置了：
export CVSROOT=:ext:tom@192.168.0.3:/home/cvsroot
export CVS_RSH=ssh
tom就可以直接在192.168.0.4上对192.168.0.3的cvsroot进行访问了（如果有权限的话）
cvs checkout project_name
cd project_name
cvs update
...
cvs commit

如果CVS所在服务器的SSH端口不在缺省的22，或者和客户端与CVS服务器端SSH缺省端口不一致，有时候设置了：
:extUSER@test.server.address#port:/path/to/cvsroot

仍然不行，比如有以下错误信息：
ssh: test.server.address#port: Name or service not known
cvs [checkout aborted]: end of file from server (consult above messages if any)

解决的方法是做一个脚本指定端口转向（不能使用alias，会出找不到文件错误）：
创建一个/usr/bin/ssh_cvs文件：
#!/usr/bin/sh
/path/to/ssh -p 34567 "$@"
然后：chmod +x /usr/bin/ssh_cvs
并CVS_RSH=ssh_cvs; export CVS_RSH

注意：port是指相应服务器SSH的端口，不是cvs pserver的端口

CVSWEB：提高文件浏览效率
=======================

CVSWEB就是CVS的WEB界面，可以大大提高程序员定位修改的效率:
使用的样例可以看：http://www.freebsd.org/cgi/cvsweb.cgi

CVSWEB的下载：CVSWEB从最初的版本已经演化出很多功能界面更丰富的版本，这个是我个人感觉安装设置比较方便的：
http://www.spaghetti-code.de/software/linux/cvsweb/

下载解包：
tar zxf cvsweb.tgz
把配置文件cvsweb.conf放到安全的地方（比如和apache的配置放在同一个目录下），
修改：cvsweb.cgi让CGI找到配置文件：
$config = $ENV{'CVSWEB_CONFIG'} || '/path/to/apache/conf/cvsweb.conf';

转到/path/to/apache/conf下并修改cvsweb.conf：

修改CVSROOT路径设置：
%CVSROOT = (
'Development' =>; '/path/to/cvsroot', #<==修改指向本地的CVSROOT
);
缺省不显示已经删除的文档：
"hideattic" =>; "1",#<==缺省不显示已经删除的文档
在配置文件cvsweb.conf中还可以定制页头的描述信息，你可以修改$long_intro成你需要的文字
CVSWEB可不能随便开放给所有用户，因此需要使用WEB用户认证：
先生成 passwd:
/path/to/apache/bin/htpasswd -c cvsweb.passwd user

修改httpd.conf: 增加
<directory "/path/to/apache/cgi-bin/cvsweb/">;
AuthName "CVS Authorization"
AuthType Basic
AuthUserFile /path/to/cvsweb.passwd
require valid-user
</directory>;

CVS TAGS: who? when?
====================

将$Id$ 加在程序文件开头的注释里是一个很好的习惯，cvs能够自动解释更新其中的内容成：file_name version time user_name 的格式，比如：cvs_card.txt,v 1.1 2002/04/05 04:24:12 chedong Exp，可以这些信息了解文件的最后修改人和修改时间

几个常用的缺省文件：default.php<?php/* * Copyright (c) 2002 Company Name. * $Header$ */?>;====================================Default.java: 注意文件头一般注释用 /* 开始 JAVADOC注释用 /** 开始的区别/* * Copyright (c) 2002 MyCompany Name. * $Header$ */package com.mycompany;import java.;/** * comments here */public class Default {    /**     * Comments here     * @param     * @return     */    public toString() {    }}====================================default.pl:#!/usr/bin/perl -w# Copyright (c) 2002 Company Name.# $Header$# file comments hereuse strict;
CVS vs VSS　
===========

CVS没有文件锁定模式，VSS在check out同时，同时记录了文件被导出者锁定。

CVS的update和commit， VSS是get_lastest_version和check in

对应VSS的check out/undo check out的CVS里是edit和unedit

在CVS中，标记自动更新功能缺省是打开的，这样也带来一个潜在的问题，就是不用-kb方式添加binary文件的话在cvs自动更新时可能会导致文件失效。

$Header$ $Date$这样的标记在Virsual SourceSafe中称之为Keyword Explaination，缺省是关闭的，需要通过OPITION打开，并指定需要进行源文件关键词扫描的文件类型：*.txt,*.java,*.html...

对于Virsual SourceSafe和CVS都通用的TAG有：
$Header$
$Author$
$Date$
$Revision$

我建议尽量使用通用的关键词保证代码在CVS和VSS都能方便的跟踪。

WinCVS
======

下载：
cvs Windows客户端：目前稳定版本为1.2
http://www.wincvs.org/
ssh Windows客户端
http://www.networksimplicity.com/openssh/

安装好以上2个软件以后：
WinCVS客户端的admin==>;preference设置
1 在general选单里
设置CVSROOT： username@192.168.0.123:/home/cvsroot
设置Authorization: 选择SSH server

2 Port选单里
钩上：check for alternate rsh name
并设置ssh.exe的路径，缺省是装在 C:Program FilesNetworkSimplicitysshssh.exe

然后就可以使用WinCVS进行cvs操作了，所有操作都会跳出命令行窗口要求你输入服务器端的认证密码。

当然，如果你觉得这样很烦的话，还有一个办法就是生成一个没有密码的公钥/私钥对，并设置CVS使用基于公钥/私钥的SSH认证（在general选单里）。

可以选择的diff工具：examdiff
下载：
http://www.prestosoft.com/examdiff/examdiff.htm
还是在WinCVS菜单admin==>;preference的WinCVS选单里
选上：Externel diff program
并设置diff工具的路径，比如：C:Program Filesed16iExamDiff.exe
在对文件进行版本diff时，第一次需要将窗口右下角的use externel diff选上。

基于CVSTrac的小组开发环境搭建
==============================

作为一个小组级的开发环境，版本控制系统和BUG跟踪系统等都涉及到用户认证部分。如何方便的将这些系统集成起来是一个非常困难的事情，毕竟我们不能指望Linux下有像Source Offsite那样集成度很高的版本控制/BUG跟踪集成系统。

我个人是很反对使用pserver模式的远程用户认证的，但如果大部分组员使用WINDOWS客户端进行开发的话，总体来说使用CVSROOT/passwd认证还是很难避免的，但CVS本身用户的管理比较麻烦。本来我打算自己用perl写一个管理界面的，直到我发现了CVSTrac：一个基于WEB界面的BUG跟踪系统，它外挂在CVS系统上的BUG跟踪系统，其中就包括了WEB界面的CVSROOT/passwd文件的管理，甚至还集成了WIKIWIKI讨论组功能。

这里首先说一下CVS的pserver模式下的用户认证，CVS的用户认证服务是基于inetd中的：
cvspserver stream tcp nowait nobody /usr/bin/cvs cvs --allow-root=/home/cvsroot pserver
一般在2401端口

CVS用户数据库是基于CVSROOT/passwd文件，文件格式：
[username]:[crypt_password]:[mapping_system_user]
由于密码都用的是UNIX标准的CRYPT加密，这个passwd文件的格式基本上是apache的htpasswd格式的扩展（比APACHE的PASSWD文件多一个系统用户映射字段），所以这个文件最简单的方法可以用
apache/bin/htpasswd -b myname mypassword
创建。注意：通过htpasswd创建出来的文件会没有映射系统用户的字段
例如：
new:geBvosup/zKl2
setup:aISQuNAAoY3qw
test:hwEpz/BX.rEDU

映射系统用户的目的在于：你可以创建一个专门的CVS服务帐号，比如叫cvs，并将/home/cvsroot目录下的所有权限赋予这个用户，然后在passwd文件里创建不同的开发用户帐号，但开发用户帐号最后的文件读写权限都映射为cvs用户，避免了在SSH模式下多个开发用户新建文件后的对于其他用户的文件读写权限问题。

进一步的，你可以将用户分别映射到2组用户上，利用2个用户的权限设置，避免2个项目组的文件互相访问。
new:geBvosup/zKl2:proj1
setup:aISQuNAAoY3qw:proj2
test:hwEpz/BX.rEDU:proj1

CVSTrac很好的解决了CVSROOT/passwd的管理问题，而且包含了BUG跟踪报告系统和集成WIKIWIKI交流功能等，使用的CGI方式的安装，并且基于GNU Public License：

安装过程

下载：可以从http://www.cvstrac.org 下载
我用的是已经在Linux上编译好的应用程序包：cvstrac-1.1.1.bin.gz，
%gzip -d cvstrac-1.1.1.bin.gz
%chmod +x cvstrac-1.1.1.bin
#mv cvstarc-1.1.1.bin /usr/bin/cvstrac

初始化cvstrac数据库：假设数据库名是 myproj
在已经装好的CVS服务器上（CVS库这时候应该已经是初始化好了，比如：cvs init初始化在/home/cvsroot里），运行一下
%cvstrac init /home/cvsroot myproj
运行后，/home/cvsroot里会有一个的myproj.db库，使用CVSTRAC服务，/home/cvsroot/myproj.db /home/cvsroot/CVSROOT/readers /home/cvsroot/CVSROOT/writers /home/cvsroot/CVSROOT/passwd这几个文件对于web服务的运行用户应该是可写的，在RedHat8上，缺省就有一个叫apache用户和一个apache组，所以我在httpd.conf文件中设置了用apache用户运行web服务：
User apache
Group apache，
如果服务器上apache用的是其他用户，比如：nobody nogroup运行，则后面相应的配置中用户/组都设置为nobody nogroup
然后我设置了#chown -R apache:apache /home/cvsroot
-rw-r--r-- 1 apache apache 55296 Jan 5 19:40 myproj.db
drwxrwxr-x 3 apache apache 4096 Oct 24 13:04 CVSROOT/
drwxrwxr-x 2 apache apache 4096 Aug 30 19:47 some_proj/
此外还在/home/cvsroot/CVSROOT中设置了：
chmod 664 readers writers passwd

在apche/cgi-bin目录中创建脚本cvstrac:
#!/bin/sh
/usr/bin/cvstrac cgi /home/cvsroot
设置脚本可执行：
chmod +x /home/apache/cgi-bin/cvstrac

从 http://cvs.server.address/cgi-bin/cvstrac/myproj 进入管理界面
缺省登录名：setup 密码 setup
对于一般用户可以从：
http://cvs.server.address/cgi-bin/cvstrac/myproj
修改登录密码，进行BUG报告等，
更多使用细节可以在使用中慢慢了解。
备注：
在inetd里加入cvspserver服务：
cvspserver stream tcp nowait apache /usr/bin/cvs cvs --allow-root=/home/cvsroot pserver

xietd的配置文件：%cat cvspserver
service cvspserver
{
disable = no
socket_type = stream
wait = no
user = apache
server = /usr/bin/cvs
server_args = -f --allow-root=/home/cvsroot pserver
log_on_failure += USERID
}

注意：这里的用户设置成apache目的是和/home/cvsroot的所有用户一致，并且必须让这个这个用户对/home/cvsroot/下的CVSROOT/passwd和cvstrac初始化生成的myproj.db有读取权限。

对于前面提到的WinCVS在perference里设置：
CVSROOT栏输入：username@ip.address.of.cvs:/home/cvsroot
Authenitication选择：use passwd file on server side
就可以了从服务器上导出项目了。

总结：

利用cvs + (WinCVS/cvsweb/cvstrac)，构成了一个相对完善的跨平台工作组开发版本控制环境。

相关资源：

CVS HOME：
http://www.cvshome.org

CVS FAQ：
http://www.loria.fr/~molli/cvs-index.html

相关网站:
http://directory.google.com/Top/Computers/Software/Configuration_Management/Tools/Concurrent_Versions_System/

CVS 免费书:
http://cvsbook.red-bean.com/

CVS 命令的速查卡片：
http://www.refcards.com/about/cvs.html

WinCVS:
http://cvsgui.sourceforge.net/

CVSTrac: A Web-Based Bug And Patch-Set Tracking System For CVS
http://www.cvstrac.org

StatCVS：基于CVS的代码统计工具：按代码量，按开发者的统计表等
http://sourceforge.net/projects/statcvs

原文出处：[;http://www.chedong.com/tech/cvs_card.html](http://www.chedong.com/tech/cvs_card.html);