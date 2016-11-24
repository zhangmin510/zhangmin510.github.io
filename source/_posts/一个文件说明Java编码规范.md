title: 一个文件说明Java编码规范
tags:
  - Java
id: 1848
categories:
  - Java
date: 2013-08-21 17:06:36
---

[java]
/**
 *
 * JavaCodeConvention.java
 * ZhangMin.name - zhangmin@zhangmin.name
 * name.zhangmin.java
 * 2013年8月21日
 *
 */
package name.zhangmin.java;

import java.util.Date;
import java.math.*;

/**
 * 这里是类或者借口的注释内容。属于Java文档注释，主要类的设计规范。
 *
 * 对于所有的注释应该注意以下几点：
 * 1.注释应该提供代码的概要信息及其他一些不易通过代码就能理解的附属的信息；
 * 2.注释应该只包括哪些与代码实现和理解相关的内容。
 * 3.注释一般不要包括特殊字符，如格式符和退格。
 *
 * 缩进一般为4个空格，Tab为八个空格。一行内容不要超过80个字符。
 *
 * @author ZhangMin.name
 *
 */
public class JavaCodeConvention {

	/* 类或者接口范围内的注释内容 。属于实现注释，主要描述具体的代码实现*/

	/* 静态变量 */
	public static String hello = &quot;hello world&quot;;

	/* 实例变量 */
	public final int MIN_WIDTH = 4;

	public    int     id;				/* id标识 */
	protected String  name;		        /* 名字 */
	private   Date    birthday;		    /* 生日 */

	int level; // indentation level
	int size; // size of table

	/* 构造器 */
	public JavaCodeConvention(String name){
		this.name = name;
	}

	/* 方法应该按照功能进行排序，而不是按照可访问性来进行排序 */
	public void setBirthday(Date birth){
		this.birthday = birth;
	}

	/* 将过长的代码行进行分解 */
	public void function(String longExpression1, String longExpression2, String longExpression3,
			String longExpression4, String longExpression5){
		name = longExpression1 + longExpression2 + longExpression3 + longExpression4
				 + longExpression5; // PREFER
	}

	//传统的缩进
	public void someMethod(int anArg, Object anotherArg, String yetAnotherArg,
	 Object andStillAnother) {

	}

	public void emptyMethod(){ }

	//八个空格的缩进
	private synchronized void horkingLongMethodName(int anArg,
			Object anotherArg, String yetAnotherArg,
			Object andStillAnother) {

	}

	private void doSomethingAboutIt(){
		//变量声明放到方法的第一行
		Integer alpha = new Integer(0);
		int condition = 1;

		//过长三元运算语句的处理方法
		String aLongBooleanExpression = new String(&quot;world&quot;);
		int beta = 1,gamma = 2;
		alpha = (aLongBooleanExpression.equals(&quot;hello&quot;)) ? beta : gamma;
		alpha = (aLongBooleanExpression.equals(&quot;hello&quot;)) ? beta
														 : gamma;
		alpha = (aLongBooleanExpression.equals(&quot;hello&quot;))
				? beta
				: gamma;

		for (int i = 1; i &lt; 1000; i++);
		while (condition == 1) {

		}
		switch (condition) {
			case 1:
				System.out.println(1);
				/* falls through */
			case 2:
				System.out.println(2);
				break;
			default:
				System.out.println(3);
				break;
		}
		//if (bar &gt; 1) {
		//
		// // Do a triple-flip.
		// ...
		//}
		//else
		// return false;
	}

	protected void ifStatement(){
		int a=1,b=2,c=2,d=1;

		a += c + d;
		a = (a + b) / (c * d);

		//过长条件语句的处理方法
		if ((a &gt; b &amp;&amp; c &gt; d)
				|| (b == d &amp;&amp; a &lt; d)
				||!(a == c &amp;&amp; d == b)) {
		 doSomethingAboutIt();
		}else if( b == d){

		}else{

		}

		//或者
		if ((a &gt; b &amp;&amp; c &gt; d) || ((b == d &amp;&amp; a &lt; d)
				||!(a == c &amp;&amp; d == b))) {
		 doSomethingAboutIt();
		}
	}
}
[/java]