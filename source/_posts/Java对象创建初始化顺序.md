title: Java对象创建初始化顺序
tags:
  - Java
  - 马上有OFFER
id: 2337
categories:
  - Java
date: 2014-08-26 14:34:14
---

Java对象初始化关乎程序的安全运行，所以理解Java的初始化过程非常必要。Java中对象的初始化和创建是捆绑在一起的，两者不能分离。Java尽力保证所有变量在使用前都能够得到恰当的初始化。与C++一样，Java也通过构造器确保初始化。构造器是一种特殊类型的方法，它没有返回值。这与返回值为空的方法是不同的，虽然是空的返回值，但它仍然可以返回其他内容。构造器不返回任何东西。即使是用new表达式创建对象，也是new表达式返回新对象的引用，构造器没有返回任何东西。

本文将从一个实例分析Java中对象创建的初始化顺序。

假设有一个Horse的类，其对象的创建过程一般如下：

1. 当首次创建类型为Horse的对象时（构造器可以看成是静态方法）或者Horse的静态方法、静态域首次被访问时，Java解释器会查找类路径，定位Horse.class文件。如果有Horse继承自某一个类，还要查找并加载相应类的Class文件。
2. 载入Horse.class（即创建一个Class对象，如果有基类还要载入基类的Class），有关静态初始化的所有动作都会执行。静态初始化只在Class对象首次加载的时候进行一次。
3. 当用new Horse(）创建对象时，首先在堆上分配足够的存储空间。如果有父类，先执行父类的变量初始化和构造器。
4. 这块存储空间清零，自动将所有基本类型数据设置为默认值，引用为null。
5. 执行所有出现于字段定义处的初始化动作。
6. 执行构造器。

在初始化过程中要注意两点：一是基本类型会有一个默认的初始值。这种自动初始化是无法阻止的。
二是非静态程序初始化块也会在构造函数之前执行。且在每次对象创建时都会执行。（常用语匿名内部类的初始化）。

下面是一个实列，Horse类继承了Animal类，具体代码如下所示。
``` [java]
package name.zhangmin.java;
public class Animal {
 private int i = 9;
 protected int j;
 static {
 System.out.println(&quot;Animal's static block&quot;);
 }
 {
 System.out.println(&quot;Animal's non-static block&quot;);
 }
 Animal() {
 System.out.println(&quot;Animal's constructor&quot;);
 System.out.println(&quot;i = &quot; + i + &quot;, j = &quot; + j);
 }
 static int printInit(String s) {
 System.out.println(s);
 return 16;
 }
 private static int x1 = printInit(&quot;static Animal.x1 initialized&quot;);
}​
```

``` [java]
package name.zhangmin.java;
public class Horse extends Animal {
 private int k = printInit(&quot;Horse.k initialized&quot;);
 Horse() {
 System.out.println(&quot;Horse's constructor&quot;);
 System.out.println(&quot;k = &quot; + k + &quot;, j = &quot; + j);
 }
 public static void main(String[] args) {
 System.out.println(&quot;Horse's Main&quot;);
 Horse h = new Horse();
 System.out.println(&quot;Creating another Horse&quot;);
 new Horse();
 }
 static int x2 = printInit(&quot;static Horse.x2 initialized&quot;);
 {
 System.out.println(&quot;Horse's non-static block&quot;);
 }
 static {
 System.out.println(&quot;Horse's static block&quot;);
 }
}​
```

上述代码的运行结果如下所示：

``` [java]
Animal's static block
static Animal.x1 initialized
static Horse.x2 initialized
Horse's static block
Horse's Main
Animal's non-static block
Animal's constructor
i = 9, j = 0
Horse.k initialized
Horse's non-static block
Horse's constructor
k = 16, j = 0
Creating another Horse
Animal's non-static block
Animal's constructor
i = 9, j = 0
Horse.k initialized
Horse's non-static block
Horse's constructor
k = 16, j = 0​
```

首先会执行Animal的静态域，静态块的初始化。执行的顺序就是域或块声明的顺序。执行完父类静态域的初始化后执行Horse的静态域初始化。类加载完成后，开始执行对象的创建过程。在这个过程中先执行父类Animal的非静态域或者块的初始化，然后是父类的构造器，之后才是子类Horse的非静态域或块的初始化，构造器。

当第二次创建Horse对象时我们可以看到只执行父类非静态域或者块的初始化，父类Animal构造器，之后才是子类的非静态域，构造器。

从上述的初始化过程可知，Java尽力保证了每个变量、对象在使用前能够正确的初始化。类的静态域只初始化一次，而非静态域则在每次对象创建时都进行初始化。如果有继承关系，要先完成父类的初始化和构造函数后才执行子类的初始化和构造函数。

_参考资料：《Java编程思想》第五章初始化与清理_