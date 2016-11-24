title: Java程序内存使用估计
tags:
  - Java
  - 马上有OFFER
id: 2210
categories:
  - Java
date: 2014-05-18 21:49:19
---

虽然Java最显著的优点就是其内存管理系统，但对于一个追求完美的程序员来说，理解程序的内存需求是非常必要的。需要注意的是，由于各个Java版本的实现可能不同，所以这里使用典型的64位内存模型，在这个模型中每个指针大小为8 byte。在分析过程中只需要把复杂的类型分解到基本类型，然后将每一项的大小进行相加就可以得到最后占用内存的大小。另外，由于方法的动态调用比较复杂，涉及到栈的操作和堆内存的分配，所以本文不考虑方法调用占用的内存，只考虑静态的内存占用大小。

### Java基本类型占用内存大小

boolean byte 1
char 2
int float 4
long double 8

### Java对象占用内存大小

对象由对象头，类属性字段，实例属性字段及方法。对象头包含类的引用，垃圾回收信息及同步信息。对象头一般占用16 byte，引用为8 byte。每个对象都是8 byte的整数倍，所以要有一个填充。如果类中包含内部类，还要包括指向内部类的指针大小为8 byte。

Java中数组实现为对象。包括数组的长度。所以一个数组的头信息包括16 byte对象头信息，4 byte 数组长度变量 及4 byte 填充，共24 byte。
一维数组(N为数组大小）：
char[] 2N + 24
int[] 4N + 24
double[] 8N + 24

二维数组是数组的数组，每一个数组都是一个对象。对于一个double[M][N]数组，包括二维数组的头信息24 bytes加上8M bytes（指向行数组的引用）加上16M bytes(行数组对象的头部信息）加8MN bytes的数组内容的引用。
总的大小为23M + 8NM + 24 bytes ~ 8NM bytes。

char[][] 2MN
int[][] 4MN
double[][] 8MN 
对象数组只计算对象引用的大小即8 byte。

Java中String对象占用内存大小分析示例

![Java String 对象](http://b.hiphotos.bdimg.com/album/s%3D550%3Bq%3D90%3Bc%3Dxiangce%2C100%2C100/sign=503b32b2324e251fe6f7e4fd97bdb82a/960a304e251f95cac0c7023ecb177f3e67095203.jpg?referer=436975ae0b24ab18b901d4079e01&amp;x=.jpg)

String对象总的内存大小为40 + 24 + 2N bytes。其中24 + 2N bytes是value数组的开销。String代表的字符串代为value[offset] 到value[offset + count - 1]之间的字符（包括端点）。对于String的常用操作都是subString，由于String是不可变的，一般value数组在各个String对象之间共享。使用subString时只需要40bytes，因为value数组可以共享。这样可以提高内存使用率。也就是说对于一个较长的字符串，创建子字符串只需要常数时间和常数空间。这种时空复杂度和字符串长度无关的设计对于字符处理算法是非常有效的。
![](http://f.hiphotos.bdimg.com/album/s%3D550%3Bq%3D90%3Bc%3Dxiangce%2C100%2C100/sign=913c29fce9f81a4c2232eccce7111164/8644ebf81a4c510f44f679926259252dd42aa50c.jpg?referer=91fb9f15c9ef7609651cacaf0302&amp;x=.jpg)

_参考文献_

_Algorithms 4th Edition by Robert Sedgewick and Kevin Wayne _