title: 关于Nodejs的core文件
date: 2015-12-29 13:54:27
tags: nodejs
categories: 学习笔记

---

## 关于Core文件

当进程崩溃或者终止时会产生core dump文件。该文件包含了进程在终止前得内存信息。core文件可以在gdb中打开，可以检查进程终止时程序
的状态。在node.js开发中，core文件可以帮助开发人员调试程序崩溃和内存泄露等问题。

## 如何产生core文件

不同的系统中生成core文件得方法是不同的。Joyent公司（nodejs的运营公司）建议所有的生产系统都应该打开--abort-on-uncaught-exception选项。
在Unix系统中，还需要使用ulimit -c unlimited命令设置产生的core文件的大小为任意大小。 
如果没有抛出异常，在Linux系统中，你可以使用系统工具gcore来产生core文件。

如果是正常运行Node程序，但程序自己奔溃退出。这是最糟糕的情况，或者是Node，或者是它的依赖，二进制模块有编程错误。如果出现这种情况
向Node团队报告问题，或者向模块作者报告问题。

你也可以调用process.abort()方法也可以产生core文件。


## 代码示例

````
var obj = {
  myproperty: "Hello World",
  count: 0,
};

function increment() {
  obj.count++;
  if (obj.count === 1000)
    throw new Error("sad trombone");
  setImmediate(increment);
}

setImmediate(increment);

$ uname -a
Linux 7527bd77-ab3e-474b-ace7-eed6053931e7 3.1.10joyent-ubuntu-10-opt #1 SMP Fri Jan 20 09:55:31 PST 2012 x86_64 GNU/Linux
$ ulimit -c unlimited
$ node --abort-on-uncaught-exception t.js
Uncaught Error: sad trombone

FROM
Object.increment [as _onImmediate] (/data/test/t.js:10:5)
processImmediate [as _immediateCallback] (timers.js:330:15)
Trace/breakpoint trap (core dumped)
$ ls -alh core
-rw------- 1 root root 12M 2014-01-28 18:37 core

```

## 使用core文件诊断node内存泄漏

可以一定间隔产生core文件，分析v8的heap以及进程的调用栈。
可以分析所有的JavaScript对象，从而分析内存泄漏的代码。
对core文件的分析可以使用gdb（linux平台），也可以使用mdb（SmartOS）。
