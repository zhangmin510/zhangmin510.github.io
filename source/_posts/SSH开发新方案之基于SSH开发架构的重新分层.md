title: SSH开发新方案之基于SSH开发架构的重新分层
id: 533
categories:
  - Java
date: 2012-03-22 10:44:31
tags:
---

<div>www.diybl.com &nbsp; &nbsp;时间 ： 2010-06-28 &nbsp;作者：佚名 &nbsp; 编辑：壹枝雪糕&nbsp;</div>
<div>现代的企业开发中，越来越多地引入了多层架构设计模式。Struts+Spring+Hibernate (一下简称为SSH)就是其中之一，SSH架构是当前非常火的架构，很多金融、电信项目，大型门户网站均选择该架构作为业务支撑架构，开发流程也已经非常成熟。但是该结构开发起来，依旧存在一些问题。分析这些问题，得先从SSH架构的组成说起。</div>
<div>SSH为Struts+Spring+Hibernate的组成方式，Struts实现MVC，Spring负责架构的结合，Hibernate进行数据的持久化。通常其分层开发的结构图(以一个业务新增为例)如下：</div>
<div>&nbsp;</div>
<div>![diyblPic](http://pic.diybl.com/pic/20100628/212224/0.png)</div>

&nbsp;

<div>这样的结构，满足了一般的业务需要，但是对于当前日益复杂化的WEB2.0的开发，却存在不少问题，归纳起来主要有以下几点的不足：</div>
<div>A)DAO和服务层容易出现职责不明，由于按照MVC逻辑，业务代码应该写在Struts Action里，但是其事务的提供，却是配置在Service层。为了一组在逻辑上完整的数据操作业务逻辑，需要涉及两个层（Serveice、Action）来进行编写，遇到判断的情况下，为了保证完整的事务操作，则需要将业务代码移到Service层完成，而通常习惯了在Struts Action里调用多次Service而产生多个事务而在出现Exception时导致出错时操作之前调用的Service事务的业务数据没有回滚。</div>
<div>B)当需要返回的数据供AJAX使用，操作JSON或XML的的大量使用时。开发起来会很费力，一段同样的业务代码，为了使用AJAX和XML可能需要重新编写一次，或者在同一个ACTION里通过标志来判断，对分层结构造成了比较糟糕的破坏。如果设计得不好，为了使用JSON和XML还得额外增加大量的配置，严重降低了开发效率。</div>
<div>因此，为了克服这些缺点，本人对于SSH架构，进行了实现了重新的分层，共享了业务代码。简化了开发、增强了与AJAX技术、MXL技术的结合。提供了一种更高效的开发模式。</div>
<div>其开发的结构图如下：</div>
<div>&nbsp;</div>
<div>&nbsp;</div>

![diyblPic](http://pic.diybl.com/pic/20100628/212224/1.png)

看到这个架构图有人可能会问，Struts Action类的编写去哪了呢？答案正是这个架构的优点，由于业务代码统一实现IbusinessService接口，使得只需要相对固定的几个Struts Action类调用Service层的方法，便可以完成工作。包括JSON格式输出，XML输出及WebService输出均调用Service层方法来完成功能。这样便实现了业务代码的分离，以及与前端框架的极大解耦。

&nbsp;

本文转自：飞诺网开发频道[http://www.diybl.com/course/3_program/java/javajs/2008525/117741.html](http://www.diybl.com/course/3_program/java/javajs/2008525/117741.html)