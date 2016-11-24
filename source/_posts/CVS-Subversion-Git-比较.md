title: CVS Subversion Git 比较
id: 500
categories:
  - 分享
date: 2012-03-19 21:11:34
tags:
---

<table border="1" width="90%">
<tbody>
<tr>
<td valign="center" width="84">特征</td>
<td valign="center" width="96">CVS</td>
<td valign="center" width="131">Git</td>
<td valign="center" width="96">Subversion</td>
</tr>
<tr>
<td valign="center" width="84">是否原子提交</td>
<td valign="center" width="96">   没有<span style="font-family: Arial;">. CVS</span><span style="font-family: 宋体;">提交不是原子的</span></td>
<td valign="center" width="131">    是的<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">提交都是原子的</span></td>
<td valign="center" width="96">  提交都是原子的</td>
</tr>
<tr>
<td valign="center" width="84">文件和目录是否可以移动或重命名</td>
<td valign="center" width="96">   不是<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">重命名不支持</span><span style="font-family: Arial;">. </span><span style="font-family: 宋体;">如果手动进行</span><span style="font-family: Arial;">, </span><span style="font-family: 宋体;">可能会损坏历史记录</span></td>
<td valign="center" width="131">    支持重命名<span style="font-family: Arial;">, </span><span style="font-family: 宋体;">这是很实用的目的</span><span style="font-family: Arial;">. git</span><span style="font-family: 宋体;">甚至能检测到重命名之后文件的改变</span><span style="font-family: Arial;">. </span><span style="font-family: 宋体;">尽管如此</span><span style="font-family: Arial;">, </span><span style="font-family: 宋体;">基于特殊的存储结构</span><span style="font-family: Arial;">, </span><span style="font-family: 宋体;">重命名不会被显示的记录</span><span style="font-family: Arial;">, git</span><span style="font-family: 宋体;">能够推导出来</span><span style="font-family: Arial;">(</span><span style="font-family: 宋体;">在实际使用中很容易做到</span><span style="font-family: Arial;">)</span></td>
<td valign="center" width="96">  是的<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">支持重命名</span></td>
</tr>
<tr>
<td valign="center" width="84">在移动或重命名之后智能合并</td>
<td valign="center" width="96">   不能<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">重命名都不支持</span><span style="font-family: Arial;">, </span><span style="font-family: 宋体;">就不必说智能了</span></td>
<td valign="center" width="131">    不支持<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">细节在</span><span style="font-family: Arial;">Git FAQ</span><span style="font-family: 宋体;">里</span><span style="font-family: Arial;">: </span><span style="font-family: 'Times New Roman';">“</span><span style="font-family: Arial;">Git</span><span style="font-family: 宋体;">有一个重命名的命令</span><span style="font-family: Arial;">git mv, </span><span style="font-family: 宋体;">但是这仅仅是为了便利</span><span style="font-family: Arial;">. </span><span style="font-family: 宋体;">效果和移掉某个文件</span><span style="font-family: Arial;">, </span><span style="font-family: 宋体;">增加另外一个文件没有任何区别</span><span style="font-family: 'Times New Roman';">”</span></td>
<td valign="center" width="96">  不支持<span style="font-family: Arial;">. </span><span style="font-family: 'Times New Roman';">“</span><span style="font-family: Arial;">svn help me</span><span style="font-family: 'Times New Roman';">“</span><span style="font-family: 宋体;">中提到</span><span style="font-family: 'Times New Roman';">“</span><span style="font-family: 宋体;">注意</span><span style="font-family: Arial;">: </span><span style="font-family: 宋体;">这个子命令相当于拷贝和删除</span><span style="font-family: Arial;">.</span><span style="font-family: 'Times New Roman';">“</span><span style="font-family: 宋体;">并且可能有个</span><span style="font-family: Arial;">bug</span></td>
</tr>
<tr>
<td valign="center" width="84">文件和目录拷贝</td>
<td valign="center" width="96">   不能<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">拷贝不支持</span></td>
<td valign="center" width="131">    不能<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">拷贝不支持</span></td>
<td valign="center" width="96">  是的<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">并且拷贝非常容易</span><span style="font-family: Arial;">(O(1)). </span><span style="font-family: 宋体;">包括产生分支</span></td>
</tr>
<tr>
<td valign="center" width="84">远程存储仓库的备份</td>
<td valign="center" width="96">   间接的<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">可以使用</span><span style="font-family: Arial;">John Polstra</span><span style="font-family: 宋体;">写的</span><span style="font-family: Arial;">CVSup</span></td>
<td valign="center" width="131">    是的<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">是</span><span style="font-family: Arial;">git</span><span style="font-family: 宋体;">的内部特征</span></td>
<td valign="center" width="96">  间接的<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">可以使用</span><span style="font-family: Arial;">Chia-liang Kao</span><span style="font-family: 宋体;">的</span><span style="font-family: Arial;">SVN::Mirror</span><span style="font-family: 宋体;">插件</span><span style="font-family: Arial;">(</span><span style="font-family: 宋体;">好像是台湾人</span><span style="font-family: Arial;">)</span><span style="font-family: 宋体;">或</span><span style="font-family: Arial;">Shlomi Fish</span><span style="font-family: 宋体;">的</span><span style="font-family: Arial;">SVN-Pusher</span><span style="font-family: 宋体;">工具</span></td>
</tr>
<tr>
<td valign="center" width="84">是否传递变更到父仓库</td>
<td valign="center" width="96">   不会</td>
<td valign="center" width="131">    是的<span style="font-family: Arial;">(Linux</span><span style="font-family: 宋体;">内核开发过程经常使用这个特征</span><span style="font-family: Arial;">)</span></td>
<td valign="center" width="96">  是的<span style="font-family: Arial;">, </span><span style="font-family: 宋体;">使用要么是</span><span style="font-family: Arial;">Chia-Ling Kao</span><span style="font-family: 宋体;">的</span><span style="font-family: Arial;">SVN::Mirror</span><span style="font-family: 宋体;">脚本或者</span><span style="font-family: Arial;">Shlomi Fish</span><span style="font-family: 宋体;">的</span><span style="font-family: Arial;">svn-push</span><span style="font-family: 宋体;">工具</span></td>
</tr>
<tr>
<td valign="center" width="84">仓库权限</td>
<td valign="center" width="96">   很有限<span style="font-family: Arial;">. </span><span style="font-family: 'Times New Roman';">“</span><span style="font-family: Arial;">pre-commit hook scripts</span><span style="font-family: 'Times New Roman';">“</span><span style="font-family: 宋体;">能够被用来实现各种权限控制系统</span></td>
<td valign="center" width="131">    请看和<span style="font-family: Arial;">Git</span><span style="font-family: 宋体;">一起附带的</span><span style="font-family: Arial;">contrib/hooks/update-paranoid. </span><span style="font-family: 宋体;">看和</span><span style="font-family: Arial;">svnperms</span><span style="font-family: 宋体;">类似的</span><span style="font-family: Arial;">path_rules</span><span style="font-family: 宋体;">的代码</span></td>
<td valign="center" width="96">  是的<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">基于</span><span style="font-family: Arial;">HTTP</span><span style="font-family: 宋体;">权限的</span><span style="font-family: Arial;">WebDAV-based</span><span style="font-family: 宋体;">模块能够支持基于目录级的仓库</span></td>
</tr>
<tr>
<td valign="center" width="84">变更集</td>
<td valign="center" width="96">   不是<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">变更是基于文件的</span></td>
<td valign="center" width="131">    是的<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">是支持的</span><span style="font-family: Arial;">, </span><span style="font-family: 宋体;">创建他们很容易</span></td>
<td valign="center" width="96">  部分支持<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">对于一次提交会隐式创建一个变更集</span></td>
</tr>
<tr>
<td valign="center" width="84">跟踪线性的文件历史</td>
<td valign="center" width="96">   是的<span style="font-family: Arial;">. cvs annotate</span></td>
<td valign="center" width="131">    是的<span style="font-family: Arial;">.(git blame)</span></td>
<td valign="center" width="96">  是的<span style="font-family: Arial;">(svn blame)</span></td>
</tr>
<tr>
<td valign="center" width="84">能够只在仓库的单目录下作用</td>
<td valign="center" width="96">   是的</td>
<td valign="center" width="131">    不是<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">尽管如此</span><span style="font-family: Arial;">, </span><span style="font-family: 宋体;">提交多少能被限制</span><span style="font-family: Arial;">, </span><span style="font-family: 宋体;">请看</span><span style="font-family: 'Times New Roman';">“</span><span style="font-family: Arial;">Repository Permissions</span><span style="font-family: 'Times New Roman';">”</span></td>
<td valign="center" width="96">  是的</td>
</tr>
<tr>
<td valign="center" width="84">跟踪未提交的变化</td>
<td valign="center" width="96">   是的<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">通过</span><span style="font-family: Arial;">cvs diff</span></td>
<td valign="center" width="131">    是的<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">另外</span><span style="font-family: Arial;">, </span><span style="font-family: 宋体;">分支在</span><span style="font-family: Arial;">git</span><span style="font-family: 宋体;">里非常智能</span><span style="font-family: Arial;">, </span><span style="font-family: 宋体;">在某些工作流里能够被当成是另外一个未提交代码的存储库</span><span style="font-family: Arial;">. </span><span style="font-family: 宋体;">请看</span><span style="font-family: 'Times New Roman';">“</span><span style="font-family: Arial;">git stash</span><span style="font-family: 'Times New Roman';">“</span><span style="font-family: 宋体;">命令</span></td>
<td valign="center" width="96">  是的<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">使用</span><span style="font-family: Arial;">svn diff</span></td>
</tr>
<tr>
<td valign="center" width="84">基于单个文件的提交信息</td>
<td valign="center" width="96">   不是<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">提交信息是基于单次变化的</span></td>
<td valign="center" width="131">    是的<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">提交信息基于变更集</span></td>
<td valign="center" width="96">  不是<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">没有这个特征</span></td>
</tr>
<tr>
<td valign="center" width="84">文档</td>
<td valign="center" width="96">   非常棒<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">有很多在线的</span><span style="font-family: Arial;">tutorials</span><span style="font-family: 宋体;">和资源</span><span style="font-family: Arial;">, </span><span style="font-family: 宋体;">在线的书籍</span><span style="font-family: Arial;">. </span><span style="font-family: 宋体;">命令行客户端也支持一个在线的帮助系统</span></td>
<td valign="center" width="131">    良好<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">短的帮助比较简洁难懂</span><span style="font-family: Arial;">. man</span><span style="font-family: 宋体;">页很有分量</span><span style="font-family: Arial;">, </span><span style="font-family: 宋体;">但容易误解</span><span style="font-family: Arial;">. </span><span style="font-family: 宋体;">有很多</span><span style="font-family: Arial;">tutorial</span></td>
<td valign="center" width="96">  很好<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">有一些在线的书籍和一些在线的</span><span style="font-family: Arial;">tutorials</span><span style="font-family: 宋体;">和资源</span><span style="font-family: Arial;">. </span><span style="font-family: 宋体;">并且书籍是以</span><span style="font-family: Arial;">docbook/xml</span><span style="font-family: 宋体;">写的所以很容易变换成其他格式</span><span style="font-family: Arial;">. </span><span style="font-family: 宋体;">命令行同样提供了在线的帮助系统</span></td>
</tr>
<tr>
<td valign="center" width="84">配置是否轻松</td>
<td valign="center" width="96">   好<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">是个事实上的标准</span><span style="font-family: Arial;">. </span><span style="font-family: 宋体;">基于每个系统都有并且很容易配置</span></td>
<td valign="center" width="131">    好<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">在现有平台上二进制可用</span><span style="font-family: Arial;">. </span><span style="font-family: 宋体;">需要</span><span style="font-family: Arial;">C</span><span style="font-family: 宋体;">编译器和</span><span style="font-family: Arial;">Perl. </span><span style="font-family: 宋体;">在</span><span style="font-family: Arial;">windows</span><span style="font-family: 宋体;">上需要</span><span style="font-family: Arial;">cygwin. </span><span style="font-family: 宋体;">并有一些</span><span style="font-family: Arial;">Unix</span><span style="font-family: 宋体;">特征</span></td>
<td valign="center" width="96">  Subversion<span style="font-family: 宋体;">服务器需要安装在</span><span style="font-family: Arial;">apache2</span><span style="font-family: 宋体;">模块里</span><span style="font-family: Arial;">(</span><span style="font-family: 宋体;">如果有人希望</span><span style="font-family: Arial;">HTTP</span><span style="font-family: 宋体;">作为底层协议的话</span><span style="font-family: Arial;">)</span><span style="font-family: 宋体;">或使用它自身的服务器</span><span style="font-family: Arial;">. </span><span style="font-family: 宋体;">客户端需要</span><span style="font-family: Arial;">Subversion</span><span style="font-family: 宋体;">特征的逻辑还有</span><span style="font-family: Arial;">WebDAV</span><span style="font-family: 宋体;">库</span><span style="font-family: Arial;">(</span><span style="font-family: 宋体;">针对</span><span style="font-family: Arial;">HTTP). </span><span style="font-family: 宋体;">安装组件很直接</span><span style="font-family: Arial;">, </span><span style="font-family: 宋体;">但是需要一些额外的工作</span><span style="font-family: Arial;">(</span><span style="font-family: 宋体;">假定</span><span style="font-family: Arial;">subversion</span><span style="font-family: 宋体;">在某些平台没有二进制包可用</span><span style="font-family: Arial;">)</span></td>
</tr>
<tr>
<td valign="center" width="84">命令集</td>
<td valign="center" width="96">   包含了<span style="font-family: Arial;">3</span><span style="font-family: 宋体;">个经常用到的命令的简单的命令集</span><span style="font-family: Arial;">(cvs commit, cvs update</span><span style="font-family: 宋体;">和</span><span style="font-family: Arial;">cvs checkout)</span><span style="font-family: 宋体;">和其它一些</span></td>
<td valign="center" width="131">    命令集很丰富<span style="font-family: Arial;">, </span><span style="font-family: 宋体;">并且和</span><span style="font-family: Arial;">CVS</span><span style="font-family: 宋体;">不兼容</span></td>
<td valign="center" width="96">  类<span style="font-family: Arial;">CVS</span><span style="font-family: 宋体;">的命令集</span><span style="font-family: Arial;">, </span><span style="font-family: 宋体;">能够很容易被</span><span style="font-family: Arial;">CVS</span><span style="font-family: 宋体;">用户使用</span></td>
</tr>
<tr>
<td valign="center" width="84">网络支持</td>
<td valign="center" width="96">   好<span style="font-family: Arial;">. cvs</span><span style="font-family: 宋体;">在不同的场合使用不同的协议</span><span style="font-family: Arial;">. </span><span style="font-family: 宋体;">协议能够通过</span><span style="font-family: Arial;">ssh</span><span style="font-family: 宋体;">链接的加密隧道进行</span></td>
<td valign="center" width="131">    非常棒<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">能够使用本地的</span><span style="font-family: Arial;">git</span><span style="font-family: 宋体;">协议</span><span style="font-family: Arial;">, </span><span style="font-family: 宋体;">但也能在</span><span style="font-family: Arial;">rsync, ssh, HTTP</span><span style="font-family: 宋体;">和</span><span style="font-family: Arial;">HTTPS</span><span style="font-family: 宋体;">上使用</span></td>
<td valign="center" width="96">  非常好<span style="font-family: Arial;">. Subversion</span><span style="font-family: 宋体;">服务器支持</span><span style="font-family: Arial;">WebDAV+DeltaV(</span><span style="font-family: 宋体;">基于</span><span style="font-family: Arial;">HTTP</span><span style="font-family: 宋体;">或</span><span style="font-family: Arial;">HTTPS)</span><span style="font-family: 宋体;">作为底层协议</span><span style="font-family: Arial;">, </span><span style="font-family: 宋体;">或者它自身的协议同样能在</span><span style="font-family: Arial;">ssh</span><span style="font-family: 宋体;">链接通道里使用</span><span style="font-family: Arial;">.</span></td>
</tr>
<tr>
<td valign="center" width="84">可移植性</td>
<td valign="center" width="96">   好<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">客户端能在</span><span style="font-family: Arial;">UNIX, Windows</span><span style="font-family: 宋体;">和</span><span style="font-family: Arial;">Mac OS</span><span style="font-family: 宋体;">上使用</span><span style="font-family: Arial;">. </span><span style="font-family: 宋体;">服务器端能在</span><span style="font-family: Arial;">UNIX, </span><span style="font-family: 宋体;">附有</span><span style="font-family: Arial;">UNIX</span><span style="font-family: 宋体;">模拟层的</span><span style="font-family: Arial;">Windows</span><span style="font-family: 宋体;">上使用</span></td>
<td valign="center" width="131">    客户端运行在大多数的<span style="font-family: Arial;">UNIX</span><span style="font-family: 宋体;">系统上</span><span style="font-family: Arial;">, </span><span style="font-family: 宋体;">但没有</span><span style="font-family: Arial;">MS-Windows</span><span style="font-family: 宋体;">本地程序</span><span style="font-family: Arial;">. </span><span style="font-family: 宋体;">基于</span><span style="font-family: Arial;">cygwin</span><span style="font-family: 宋体;">的系统看起来也能使用</span></td>
<td valign="center" width="96">  非常好<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">客户端和服务器端都能在</span><span style="font-family: Arial;">UNIX, Windows</span><span style="font-family: 宋体;">和</span><span style="font-family: Arial;">Mac OS X</span><span style="font-family: 宋体;">上运行</span></td>
</tr>
<tr>
<td valign="center" width="84">web<span style="font-family: 宋体;">接口</span></td>
<td valign="center" width="96">   是的<span style="font-family: Arial;">. CVSweb, ViewVC, Chora</span><span style="font-family: 宋体;">和</span><span style="font-family: Arial;">wwCVS</span></td>
<td valign="center" width="131">    是的<span style="font-family: Arial;">. Gitweb</span><span style="font-family: 宋体;">包含在发布包中</span></td>
<td valign="center" width="96">  是的<span style="font-family: Arial;">. ViewVC, SVN::Web, WebSVN, ViewSVN, mod_svn_view, Chora, Trac, SVN::RaWeb::Light, SVN Browser, Insurrection</span><span style="font-family: 宋体;">和</span><span style="font-family: Arial;">perl_svn.</span><span style="font-family: 宋体;">另外</span><span style="font-family: Arial;">, Subversion</span><span style="font-family: 宋体;">的</span><span style="font-family: Arial;">apache</span><span style="font-family: 宋体;">服务也提供了一个基础的</span><span style="font-family: Arial;">web</span><span style="font-family: 宋体;">接口</span></td>
</tr>
<tr>
<td valign="center" width="84">图形用户界面</td>
<td valign="center" width="96">   非常好<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">有很多图形界面可以用</span><span style="font-family: Arial;">: WinCVS, Cervisia(</span><span style="font-family: 宋体;">对于</span><span style="font-family: Arial;">KDE), TortoiseCVS(Windows</span><span style="font-family: 宋体;">浏览器插件</span><span style="font-family: Arial;">)</span></td>
<td valign="center" width="131">    Gitk<span style="font-family: 宋体;">包含在发行版中</span><span style="font-family: Arial;">. Qqit</span><span style="font-family: 宋体;">和</span><span style="font-family: Arial;">Git-gui</span><span style="font-family: 宋体;">工具也可使用</span></td>
<td valign="center" width="96">  非常好<span style="font-family: Arial;">. </span><span style="font-family: 宋体;">有很多</span><span style="font-family: Arial;">GUIs</span><span style="font-family: 宋体;">可用</span><span style="font-family: Arial;">: RapidSVN(</span><span style="font-family: 宋体;">跨平台</span><span style="font-family: Arial;">), TortoiseSVN(Windows</span><span style="font-family: 宋体;">浏览器插件</span><span style="font-family: Arial;">), Jsvn(java), </span><span style="font-family: 宋体;">等</span><span style="font-family: Arial;">. </span><span style="font-family: 宋体;">大多数都还在开发中</span></td>
</tr>
</tbody>
</table>
<span style="font-family: Verdana, Arial, Helvetica, sans-serif;"><span style="font-size: 11px; line-height: normal;">
</span></span>