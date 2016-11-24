title: CVS简介
id: 497
categories:
  - 分享
date: 2012-03-19 20:51:20
tags:
---

CVS<span style="font-family: 宋体;">是</span><span style="font-family: 'Times New Roman';">Concurrent Versions System</span><span style="font-family: 宋体;">（并发版本系统）的简称。它是一个开放源代码的项目，是当前最流行的版本控制系统，目前绝大部分</span><span style="font-family: 'Times New Roman';">Open Source</span><span style="font-family: 宋体;">项目都使用它来做版本管理。如果你还习惯用微软的</span><span style="font-family: 'Times New Roman';">VSS</span><span style="font-family: 宋体;">来进行</span><span style="font-family: 'Times New Roman';">Java</span><span style="font-family: 宋体;">项目的版本管理，那么用上</span><span style="font-family: 'Times New Roman';">Eclipse</span><span style="font-family: 宋体;">后，建议还是转为使用</span><span style="font-family: 'Times New Roman';">CVS</span><span style="font-family: 宋体;">。</span>

CVS<span style="font-family: 宋体;">采用客户机</span><span style="font-family: 'Times New Roman';">/</span><span style="font-family: 宋体;">服务器体系，代码、文档的各种版本都存储在服务器端，开发者首先从服务器上获得一份复制到本机，然后在此基础上进行开发。开发者可随时将新代码提交给服务器，当然也可以通过更新操作获得最新的代码，保持与其他开发者的一致。</span>

CVS<span style="font-family: 宋体;">中常用的术语：</span>

<span style="font-family: Arial;">Revision (</span><span style="font-family: 宋体;">修订版本</span><span style="font-family: Arial;">)</span><span style="font-family: 宋体;">－－文件历史记录中的被开发者提交的变化。一个修订版本就是一个时常变化的项目的 </span><span style="font-family: Arial;">snapshot (</span><span style="font-family: 宋体;">瞬态图</span><span style="font-family: Arial;">)</span><span style="font-family: 宋体;">。　　</span>

Repository (<span style="font-family: 宋体;">源代码库</span><span style="font-family: Arial;">)</span><span style="font-family: 宋体;">－－</span><span style="font-family: Arial;">CVS </span><span style="font-family: 宋体;">存储所有修订版本历史记录的地方。每个项目都有自己的一个确定的源代码库。　　</span>

Working copy (<span style="font-family: 宋体;">工作拷贝</span><span style="font-family: Arial;">)</span><span style="font-family: 宋体;">－－开发者对文件作出修改时文件所在的拷贝。　　</span>

Check out (<span style="font-family: 宋体;">检验</span><span style="font-family: Arial;">)</span><span style="font-family: 宋体;">－－从源代码库中申请一份工作拷贝。该工作拷贝反映的是取出时项目的瞬时状态。当开发者对拷贝作出修改时，必须运用 </span><span style="font-family: Arial;">commit (</span><span style="font-family: 宋体;">提交</span><span style="font-family: Arial;">)</span><span style="font-family: 宋体;">和 </span><span style="font-family: Arial;">update (</span><span style="font-family: 宋体;">更新</span><span style="font-family: Arial;">) </span><span style="font-family: 宋体;">命令来 </span><span style="font-family: 'Times New Roman';">“</span><span style="font-family: 宋体;">发布</span><span style="font-family: 'Times New Roman';">”</span><span style="font-family: 宋体;">变化和查看其他开发者所作的修改。　　</span>

Commit (<span style="font-family: 宋体;">提交</span><span style="font-family: Arial;">)</span><span style="font-family: 宋体;">－－将工作拷贝中的变化输入中央源代码库。　　</span>

Log message (<span style="font-family: 宋体;">日志信息</span><span style="font-family: Arial;">)</span><span style="font-family: 宋体;">－－提交修订版本的时候，附带描述变化的注解。通过查阅记录信息，人们可以获得一个当前项目进程的总结。　　</span>

Update (<span style="font-family: 宋体;">更新</span><span style="font-family: Arial;">)</span><span style="font-family: 宋体;">－－从源代码库中取出别人的修改数据，将其输入自己的工作拷贝，并显示自己的工作拷贝是否有未提交的修改。注意，不要和 </span><span style="font-family: Arial;">commit (</span><span style="font-family: 宋体;">提交</span><span style="font-family: Arial;">)</span><span style="font-family: 宋体;">混淆，更新和提交是一对互补的指令。记住： </span><span style="font-family: Arial;">Update </span><span style="font-family: 宋体;">将使工作拷贝和源代码库拷贝保持同步更新。　　</span><span style="font-family: Arial;">Conflicts (</span><span style="font-family: 宋体;">冲突</span><span style="font-family: Arial;">)</span><span style="font-family: 宋体;">－－两个开发者对同一个区域所做的改动都提交给主版本时出现的情况，在 </span><span style="font-family: Arial;">CVS </span><span style="font-family: 宋体;">觉察并指出这个冲突后，开发者必须解决该冲突。</span>