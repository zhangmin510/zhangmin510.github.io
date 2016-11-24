title: 正确地用Java实现单例(Singleton)模式
tags:
  - Java
  - 马上有OFFER
id: 2359
categories:
  - Java
date: 2014-10-13 14:26:15
---

在设计模式中，单例模式解决的是创建对象实例的数量及创建时间的问题。该模式保证一个类只有一个实例，并提供一个全局的访问点访问对象。之所以需要单例模式一个原因是在某些业务背景下，一个对象只能有一个实例，如金融相关的交易管理引擎；另外一个原因是有的对象创建所需要的内存和CPU开销较大，为了优化程序，只在内存中保存一个对象实例。

### 单例模式实现的特点

单例模式实现的特点有：

1.  有一个无参的私有构造函数。
2.  有一个私有的静态变量保存单例实例的引用。
3.  有一个公有的静态方法来获取单例实例的引用。

### 单例模式的优缺点

单例模式控制了实例的数量，从而保证了访问对象的唯一性。另外，由于由类自己控制实例化进程，所以类在改变实例化进程上有相应的伸缩性。但是由于单例模式自己控制实例化过程，所以整个对象的生命周期也需要由单例类来实现。

### 单线程下的实现

在单线程的情况下，一个单例模式的实现非常简单，代码如下所示：
```[java]
public class Singleton {
     private static Singleton instance;
     private Singleton() { }
     public static Singleton getInstance() {
           if (instance == null) {
                 instance = new Singleton();
           }
           return instance;
     }
}
```

### 多线程下的实现

Java多线程下最简单的同步方法就是使用系统内置的synchronized关键词，只需要在单线程实现代码的getInstance()方法加上synchronized关键词就可以做到线程安全。但是这种实现并不高效。每次只有一个线程访问getInstance方法，但事实上，只要第一次当instance为null时才有必要进行同步，之后就完全没有必要了。所以就有了一种改进实现叫做双重锁检查（Double Checked Locking）。其代码实现如下所示：

``` [java]
public class Singleton {
    private static Singleton instance;
    private Singleton() { }
    public static Singleton getInstance() {
          if (instance == null) {
             synchronized(Singleton.class) {
                 if (instance == null) {
                     instance = new Singleton();
                 }
              }
           }
           return instance;
      }
}
```
之所以要使用双重锁检查是因为如果同时又两个线程进入第一个if语句，就有可能导致创建多个对象的情况。

但是这种实现还是存在问题的。主要是对于语句instance = new Singleton()这条语句在JVM中执行是分三步的：
1\. 给instance分配内存。

2\. 调用Singleton的构造函数来初始化成员变量。

3\. 将instance对象指向已经创建完的对象。

由于JVM为了优化指令执行存在指令重拍，所以2,3两步的顺序不能得到保证。如果对象没有完成初始化就将对象所在的地址引用赋值给了instance，则会导致运行错误。解决这一问题的方法是使用volatile关键字，该关键字在Java内存模型级别保证了变量的可见性，即读到的值一定是最近一次修改的值。它同时也会禁止指令重拍。在Java SE5以后，上述代码就是线程安全的了，因为在Java SE5之前的Java内存模型不能保证volatile关键字禁止指令重拍。

上面的代码实现不够简洁，一种更简洁的实现如下所示。
```[java]
public class Singleton {
    private static final Singleton instance = new Singleton();
    private Singleton() { }
    public static Singleton getInstance() {
           return instance;
      }
}
```
上述代码虽然简洁但是有一个问题是它会在类加载时就被创建，如果这个对象依赖于一些配置文件，就不能使用这种方式实现单例模式了。

在《Effective Java》中推荐的实现方式是使用静态内部类来实现的。利用的JVM的实现机制。SingletonHolder类是私有的，只有Singleton才能访问。也是在第一次使用时才创建对象，而且不需要使用同步。
```[java]
public class Singleton {
       private static class SingletonHolder {
             private static final Singleton INSTANCE = new Singleton();
       }
       private Singleton() { }
       public static Singleton getInstance() {
              return SingletonHolder.INSTANCE;
       }
}
```

推荐的另外一种实现是使用Java的enmu类型，也是使用JVM的实现机制来保证线程安全性的。

```[java]
public enum Singleton {
     INSTANCE;
}
```

上述代码实现的Singleton可以通过Singleton.INSTANCE来访问。

### 一些特殊应用场景下的实现

#### 多ClassLoader环境下的实现

在多个ClassLoader的环境中，由于Java中每个ClassLoader具有隔离性，即同一个类可以被多个ClassLoader加载并创建实例。为了实现单例模式，就要保证所有的单例类使用相同的ClassLoader。

```[java]
private static Class getClass(String classname) throws ClassNotFoundException {
      ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
      if(classLoader == null)
         classLoader = Singleton.class.getClassLoader();
      return (classLoader.loadClass(classname));
   }
}
```

#### 需要序列化时的实现

要在单例类的方法中加入readResolve方法保证反序列化的对象仍然是原来的对象。
```[java]
private Object readResolve() {
     return getInstance();
}
```

### 参考文献

1.  《Effective Java》
2.  http://wuchong.me/blog/2014/08/28/how-to-correctly-write-singleton-pattern/
3.