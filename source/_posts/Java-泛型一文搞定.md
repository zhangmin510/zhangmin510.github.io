title: Java 泛型一文搞定
tags:
  - Java
  - 技术
  - 马上有OFFER
id: 2106
categories:
  - Java
date: 2014-03-04 16:24:59
---

### 为什么要引入泛型机制

你可以使用泛型机制写出更安全、更简单易读的代码，而不是使用Object变量和强制转换。
泛型编程意味着你可以写出对不同类型都可以重用的代码。

先看在Java SE 5.0之前，java的泛型编程是通过继承实现的。如一个ArrayList的实现：
[java]
public class ArrayList{
    public Object get(int i){...}
    public void add(Object o){...}
    ...
    private Object[] elementData;
[/java]

这种方法有两个问题：

1）当你调用get方法时，你必须使用强制类型转换。

2）由于没有类型检查，你可以add任何类型的对象。而这可能导致运行时发生错误。

Java泛型使用类型参数很好的解决了这两个问题：无论是编译器还是程序员都可以很容易的获得类型
信息，从而避免强制类型转换并且必要时（如add）进行类型检查以避免运行时的发生错误。

一般情况下，只有涉及到大量的强制转换和一般类型（如Object，Comparable）的代码才会从泛型编程中受益。

### 泛型类

将类型参数作为方法返回值和域及本地变量的类型定义，一个泛型类定义示例:

[java]
public class Pair&lt;T,U&gt;{
    private T first;
    private U second;
    public Pair(){
        first = null;
        second = null;
    }
    public Pair(T first,U second){
        this.first = first;
        this.second = second;
    }
    public T getFirst(){
        return first;
    }
    ...
}
[/java]

### 泛型方法

你也可以在普通类中定义泛型方法，示例如下：

[java]
class GenericMethod{
    public static &lt;T&gt; T getMiddle(T[] a){
           return a[a.length/2];
    }
}
[/java]
注意类型参数&lt;T&gt;在修饰符（public static）后面，方法返回类型之前。
在使用泛型方法时你可以指定类型，如:

[java]
String[] name = {&quot;a&quot;,&quot;b&quot;};
String mid = GenericMethod.&lt;String&gt;getMiddle(names);
[/java]

但一般情况下你不需要指定，因为编译器会帮你搞定的。

### 类型参数的边界

可以指定类型参数的边界：

[java]
&lt;T extends BoundingType&gt;
[/java]

也可以是多个边界：

[java]
&lt;T extends Comparable &amp; Serializable&gt;
[/java]

由于java是单继承，所以在指定泛型类型边界时只能指定一个类，且必须放在第一位，但可以指定多个接口。

### 泛型代码与虚拟机

当你定义泛型时，编译器会自动提供一个对应的原始类型。原始类型的名称就是泛型类型的名称，只是移除了类型参数。
类型变量将会被第一个边界类型替代，如果没有边界类型，将由Object代替。因此，一般把标记接口（没有方法的接口，如
Seralizable）放在边界类型列表的后一位。

下面的代码显示了Pair&lt;T,U&gt;的原始类型：

[java]
public class Pair{
    private Object first;
    private Object second;
    public Pair(){
        first = null;
        second = null;
    }
    public Pair(Object first,Object second){
        this.first = first;
        this.second = second;
    }
    public Object getFirst(){
        return first;
    }
    ...
}
[/java]

当你进行方法调用时，编译器会先调用方法（Object的），然后自动加入类型转换。

### 类型擦除引起的问题

java的泛型在编译期有效，在运行期被擦除。

对于代码：

[java]
class DateInterval extends Pair&lt;Date&gt;
{
public void setSecond(Date second)
{
if (second.compareTo(getFirst()) &gt;= 0)
super.setSecond(second);
}
}
[/java]

类型擦除后为：

[java]
class DateInterval extends Pair
{
public void setSecond(Date second)
{...}
. . .
}
[/java]

但是DateInterval内还有一个方法，继承自Pair，即：

[java]
public void setSecond(Object second)
[/java]

这两个方法是完全不同的方法，因为它们的参数类型不一样。当进行调用时，它们应该没什么不同。

[java]
DateInterval interval = new DateInterval(. . .);
Pair&lt;Date&gt; pair = interval; 
pair.setSecond(aDate);
[/java]

期望的运行结果是调用dateInterval的setSecond方法。

为了确保正确性，编译器会在DateInterval中加入桥方法：

[java]
public void setSecond(Object second) {
      setSecond((Date) second); 
}
[/java]

现在让我们看一下执行过程：

pair的类型是Pair&lt;Date&gt;，该类只有一个setSecond(Object)方法。编译器调用pair指向的对象的
方法即DateInterval的setSecond(Object),这是一个桥方法，调用了我们期望调用的方法。

关于泛型代码的翻译：

1）虚拟机没有泛型，只有普通的类和方法。

2）类型参数都被替换了。

3）桥方法用于保证多态。

4）强制转换被插入以保证类型安全。

### java泛型的限制和局限（多数是由于类型擦除）

1）类型参数不能使用原始类型。类型被擦除成Object了。

2）运行时类型查询只适合原始类型。getClass返回的也是原始类型。

3）不能抛出或者捕捉泛型类的实例。

[java]
public static &lt;T extends Throwable&gt; void doWork(Class&lt;T&gt; t)
{
try
{
do work
}
catch (T e)//错误
{
}
}
[/java]

但可以指定抛出异常：

[java]
public static &lt;T extends Throwable&gt; void doWork(T t) throws T // OK
{
try
{
do work
}
catch (Throwable realCause)
{
t.initCause(realCause);
throw t;
}
}
[/java]

4）不能创建泛型数组。类型擦除后，List&lt;Object&gt;[] 和 List&lt;String&gt;[]是一样的，由于数组会检查每一项的类型，如果类型不一致，会抛出ArrayStoreException。擦除机制不能很好的处理，仍然会抛出异常，所以干脆就不允许。（注：创建泛型数组的方法：T[] t = (T[]) Array.newInstance(class,size);)

5）不能实例化类型参数变量。new T()。不过可以通过Class.newInstance来创建。

6）不能再static域使用类型参数。

7）小心类型擦除后的冲突。

### 类型通配符

java泛型支持通配符，可以单独使用一个“？”来表示任意类型，也可以使用extends关键词表示某一个类或者接口的子类型。还可以使用super关键词表示某一个类或者接口的父类型。

一般情况下，泛型结构只参与“读”操作则限定上界（extends），如：

[java]
public static &lt;E&gt; void read(List&lt;? super E&gt; list){
    ...
}
[/java]

编译器只能推断出是E类型的父类，不能确定E类型的父类到底是什么，只能在运行时确定。
当然你可以把它当做Object类来处理，需要时在转换成E类型，但这违背了泛型的初衷——避免强制类型转换。
如果使用extends，虽然也不能确定具体是什么类型，但它一定是一个确定的类型，比如read(Arrays.asList("A'))调动该方法就可以确定是String。

只参与“写”操作则限定下界（super），如：

[java]
public static void write(List&lt;? extends Number&gt; list){
    ...
}
[/java]

编译器无法推断出泛型类型到底是什么，是Integer还是Double？在这种情况下，只有null可以write。因为null是一个万用类型，它可以是所有类的实例对象。如果使用super关键字，无论是123，还是1.23都是Number类型，都可以进行操作。

如果既读又写，直接使用泛型类型，如List&lt;E&gt;。

### 协变与泛型

协变（covariance）,即用一个窄类型替换宽类型。相反，逆变（contravariance），则是用宽类型替代子类型。​
泛型不支持协变，数组支持协变。

[java]
Number[] n = new Integer[10];
//error
List&lt;Number&gt; ln = new ArrayList&lt;Integer&gt;();
[/java]

java为了保证运行期安全，必须保证参数类型是固定的，所以不允许一个泛型参数可以同时包含两种类型。
但可以使用通配符模拟协变。

[java]
//correct
List&lt;? extends Number&gt; ln = new ArrayList&lt;Integer&gt;();
[/java]

​表示允许Number的所有子类，包括自身作为泛型类型，但在运行期只能有一个具体类型。也就是通配符只在编码期有效，
运行期必须是一个确定的类型。

java泛型也不支持逆变，但同样可以使用super关键字模拟逆变。

[java]
//correct
List&lt;? super Integer&gt; ln = new ArrayList&lt;Number&gt;();
[/java]

### 泛型类型参数T,?和Object之间的区别

三者都可以容纳所有对象，但使用顺序应该是List&lt;T&gt;,List&lt;?&gt;,List&lt;Object&gt;。
List&lt;T&gt;表示集合中都是T类型，具体类型运行时确定；List&lt;?&gt;表示的是任意类型，与List&lt;T&gt;类似，
而List&lt;Object&gt;表示集合中的类型是Object类型.
List&lt;T&gt;可以进行读写操作，因为它是固定的类型，不需要转型。
List&lt;?&gt;是只读类型，可以且只支持删除操作，因为编译器不知道是什么类型，无法校验安全。而且List&lt;?&gt;读出的类型是Object类型，
需要主动转型，通常用于泛型方法的返回值。
List&lt;Object&gt;可以执行读写操作，但是执行写入操作时要向上转型，读出时要向下转型，而此时已经失去了泛型的意义。

_参考文献_

1.  《Java核心技术》2.  《编写高质量代码——改善Java程序的151个建议》