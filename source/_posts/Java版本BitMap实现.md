title: Java版本BitMap实现
tags:
  - Java
  - 马上有OFFER
id: 2212
categories:
  - Java
date: 2014-05-13 15:05:43
---

BitMap即位图数据结构。此数据结构代表了有限域中的一个稠密集合，每个元素在集合中出现至多一次。
这一数据结构在《编程珠玑》一书中用于高效解决一定范围内无重复整数的排序问题。

比如一个小于10的整数集合如{1,2,3,4,8}可以用下面的二进制字符串表示：
0 1 1 1 1 0 0 0 1 0

如果整数在集合中，则其相应位置为1，否则为0。

可以通过对int的位操作来实现BitMap。实现的思路是先找到相应位的存储位置，然后把该位设为0或1.
由于Java中int为32位，所以每次通过右移5位来找到i所在的整数在int[]中的位置（右移5位相当于除以32），然后将相应的位置设为1.

具体的实现代码如下：

<pre>
[java]
/**
 *
 * BitMap.java
 * ZhangMin.name - zhangmin@zhangmin.name
 * name.zhangmin.java
 *
 */
package name.zhangmin.java.bop;

import name.zhangmin.util.StdOut;

/**
 * The &lt;tt&gt;BitMap&lt;/tt&gt; class represents a bit map.
 * It supports operations such as &lt;em&gt;set&lt;/em&gt;, &lt;em&gt;test&lt;/em&gt;,
 * &lt;em&gt;clear&lt;/em&gt;.
 * &lt;p&gt;
 * This implementation use bitwise logical operations (such as
 * and, or, shift).
 * 
 * @author ZhangMin.name
 *
 */
public class BitMap {
    private static final int BITPERWORD = 32;
    private static final int SHIFT = 5;
    private static final int MASK = 0x1F;
    private int[] a;

    /**
     * Initialize a empty bitmap.
     * @param N the bitmap size
     */
    public BitMap(int N) {
        if (N &lt; 0 || N &gt; Integer.MAX_VALUE)
            throw new IllegalArgumentException(N + &quot; shoule be in [0,2147483647)&quot;);
        this.a = new int[1 + N / BITPERWORD];
        for (int i = 0; i &lt; a.length; i++)
            a[i] &amp;= 0x0;
    }
    /**
     * Set the i&lt;em&gt;th&lt;/em&gt; bit to 1.
     * @param i
     */
    public void set(int i) {
        if (i &lt; 0 || i &gt; Integer.MAX_VALUE)
            throw new IllegalArgumentException(i + &quot; shoule be in [0,2147483647]&quot;);
        a[i &gt;&gt; SHIFT] |= (1 &lt;&lt; (i &amp; MASK));
    }
    /**
     * Clear the i&lt;em&gt;th&lt;/em&gt; bit to 0.
     * @param i
     */
    public void clear(int i) {
        if (i &lt; 0 || i &gt; Integer.MAX_VALUE)
            throw new IllegalArgumentException(i + &quot; shoule be in [0,2147483647]&quot;);
        a[i &gt;&gt; SHIFT] &amp;= ~(1 &lt;&lt; (i &amp; MASK));
    }
    /**
     * Test the i&lt;em&gt;th&lt;/em&gt; bit.
     * @param i
     * @return 0 if the i&lt;em&gt;th&lt;/em&gt; bit is 0, non-zero otherwise.
     */
    public int test(int i) {
        if (i &lt; 0 || i &gt; Integer.MAX_VALUE)
            throw new IllegalArgumentException(i + &quot; shoule be in [0,2147483647]&quot;);
        return a[i &gt;&gt; SHIFT] &amp; (1 &lt;&lt; (i &amp; MASK));
    }
    /**
     * Unit test.
     */
    public static void main(String[] args) {
        int N = 100;
        BitMap bm = new BitMap(N);
        for (int i = 0; i &lt; N; i += 3) {
            bm.set(i);
            StdOut.printf(&quot;%dth value is %d\n&quot;, i, bm.test(i));
            bm.clear(i);
            StdOut.printf(&quot;%dth value is %d\n&quot;, i, bm.test(i));
        }
    }

}
[/java]
</pre>

_参考文献_
1\. 《编程珠玑》第一章