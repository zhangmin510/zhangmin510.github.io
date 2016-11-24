title: 在linux或windows下用repo下载android源码
tags:
  - Linux
  - 技术
id: 1315
categories:
  - linux
date: 2013-04-19 18:36:01
---

最近想研究android的应用权限相关源码，于是就开始在linux上腾出18G的空间下载源码，用60kb/s的网速连续下载了好几天。终于下载了9G，心里很是高兴，终于要下完了。可是当repo下载完所有object文件开始检出时，我的剩余9G空间瞬间就爆满。无奈，只好将.repo中的文件导出到windows下，配置cygwin，安装repo，curl，git等，重新生成manifest文件及目录后，继续从我在linux上进度。
现在的android源码大小在8.5G左右（repo工作目录8.5G，检出后8.5G，总共约18G），构建单个build需要30G空间，如果构建所有的build则需要100G左右的空间。
下面介绍在linux和windows如何利用repo下载android源码。
**1.Linux**
1）配置repo。

[java]
$ mkdir ~/bin
$ PATH=~/bin:$PATH
$ curl https://dl-ssl.google.com/dl/googlesource/git-repo/repo &gt; ~/bin/repo
$ chmod a+x ~/bin/repo
[/java]

2）初始化repo客户端

[java]
$ mkdir WORKING_DIRECTORY
$ cd WORKING_DIRECTORY
$ repo init -u https://android.googlesource.com/platform/manifest
或者检出特定分支
$ repo init -u https://android.googlesource.com/platform/manifest -b android-4.0.1_r1
[/java]

3）同步文件

[java]
$ repo sync
[/java]

详见http://source.android.com/source/downloading.html
**2.Windows**
1）安装cygwin。需要安装的库有
curl
git,git-completion
vim
python
GnuPG
2）配置repo
同linux
3）下载android源码
同linux
**在windows下可能出现的问题及解决方案**
问题一：1 [main] python 5536 child_info_fork::abort: unable to remap select.dll to same address as parent (00C70000) - try running rebaseall
Traceback (most recent call last):
File "/cygdrive/f/android/source/.repo/repo/main.py", line 385, in
_Main(sys.argv[1:])......
解决方案：关闭所有cygwin进程，启动cygwin的bin目录下的ash，运行./rebaseall -v
问题二：error: error setting certificate verify locations:
CAfile: /usr/ssl/certs/ca-bundle.crt
CApath: none while accessing https://github.com/username/repositoryname/info/refs
fatal: HTTP request failed
解决方案：缺少证书所致，重新运行cygwin的setup.exe，然后安装ca-certificates包即可解决问题。

_参考文献
1.http://tech.idv2.com/2012/09/14/cygwin-git-error/
2.http://www.java123.net/detail/view-20392.html
3.http://blog.163.com/liuyichaoweiyi@126/blog/static/21743855201231321814801/
_