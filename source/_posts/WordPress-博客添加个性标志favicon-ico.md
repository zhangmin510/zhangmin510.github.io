title: WordPress 博客添加个性标志favicon.ico
tags:
  - wordpress
id: 187
categories:
  - 分享
date: 2010-11-17 21:35:52
---

为WordPress博客添加个性的favicon.ico，可以让博客个性标志显示在浏览器地址栏上和收藏夹中，加深访客对博客的印象。博主们访问一些添加了favicon标志的博客应该注意到，在浏览器地址栏博客地址前面或在浏览器标签中显示出来的个性图片，[博客吧](http://www.boke8.net/ "博客吧")同时也有添加favicon.ico图标。

**favicon.ico介绍：**

所谓favicon，即Favorites Icon的缩写，顾名思义，便是其可以让浏览器的收藏夹中除显示相应的标题外，还以图标的方式区别不同的网站。而且根据不同版本的浏览器，作用效果也会有差异。

**favicon.ico添加方法：**

先挑一张喜欢的图片，调整成16×16大小，通过相关图片制作工具，将其转换为扩展名为.ico，文件名为favicon的图片，即favicon.ico

_方法一_

*   把准备好的favicon.ico图标直接上传到WordPress博客所在的网站空间的根目录
*   保存更新文件文件，清除浏览器缓存即可以地址栏看到favicon图标
_方法二_

*   把准备好的favicon.ico图标上传到空间的某个目录（如博客根目录）
*   编辑主题文件header.php，在&lt;head&gt;和&lt;/head&gt;之间添加以下代码：
<div>
<table>
<tbody>
<tr>
<td>
<pre></pre>
</td>
<td>
<pre>&lt;link rel="shortcut icon" href="favicon.ico"  type="image/x-icon" /&gt;/&gt;
&lt;link rel="Bookmark" href="favicon.ico" /&gt;</pre>
</td>
</tr>
</tbody>
</table>
</div>
*   保存更新文件文件，清除浏览器缓存即实现效果
**添加动态favicon图标的方法：**

1.  先挑一张喜欢的gif动态图片，调整成16×16大小，重新命名为favicon.gif
2.  编辑WordPress主题文件header.php，在&lt;head&gt;和&lt;/head&gt;之间添加以下代码：
<div>
<table>
<tbody>
<tr>
<td>
<pre></pre>
</td>
<td>
<pre>&lt;link rel="icon" href="favicon.gif" type="image/gif" &gt;</pre>
</td>
</tr>
</tbody>
</table>
</div>
3.  保存更新文件，清除浏览器缓存即可以地址栏看到favicon动态图标效果
**提醒：**有些主机不支持方法一，所以建议使用方法二。
<div>

»本文转自： [博客吧](http://www.boke8.net/)

</div>
<div>

» 原文地址：[http://www.boke8.net/wordpress-favicon-ico.html](/Users/ZhangMin/Desktop/Thisterm/ZM%20Corporation/ZhangMin.name/%E8%B5%84%E6%BA%90/WordPress%20%E5%8D%9A%E5%AE%A2%E6%B7%BB%E5%8A%A0%E4%B8%AA%E6%80%A7%E6%A0%87%E5%BF%97favicon.ico%20%20%20%E5%8D%9A%E5%AE%A2%E5%90%A7_files/WordPress%20%E5%8D%9A%E5%AE%A2%E6%B7%BB%E5%8A%A0%E4%B8%AA%E6%80%A7%E6%A0%87%E5%BF%97favicon.ico%20%20%20%E5%8D%9A%E5%AE%A2%E5%90%A7.htm "WordPress 博客添加个性标志favicon.ico")

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

我的站标是i形，i的点是红色，下面是黑色，是ThinkPad中的i，代表思考，勤思敏行；也是小写的I，代表我，个性，要行动，思行合一。设计的灵感来自ThinkPad的宣传语。

</div>