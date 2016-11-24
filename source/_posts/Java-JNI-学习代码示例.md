title: Java JNI 学习代码示例
tags:
  - Java
  - 技术
id: 2015
categories:
  - Java
date: 2013-10-31 16:48:55
---

**Java 本地方法声明及测试类**
[java]
package name.zhangmin.java.jni;

/**
 * Basics of JNI
 * @author ZhangMin.name
 *
 */
public class JNIExample {
	private POJO pj;
	private POJO[] pjs;
	private float f;
	private boolean[] bs;

	public native void sayHello();
	public static native POJO getPOJO(int i,double[] d,JObject obj,JObject[] objs);
	public native int getData();
	public native JObject[] getRefs();

	public static void main(String[] args) {
		JNIExample exp = new JNIExample();

		exp.sayHello();

		double[] d = {0.1,0.2};
		JObject obj = new JObject(5);
		JObject[] objs = {new JObject(1),new JObject(2)};
		POJO pj = getPOJO(5,d,obj,objs);
		System.out.println(pj.toString());

		System.out.println(&quot;Get int data:&quot; + exp.getData());

		JObject[] jos = exp.getRefs();
		System.out.println(jos[0].toString());

	}

	static{
		System.loadLibrary(&quot;JavaNativeCode&quot;);
	}

}
[/java]

**Java native method C++实现**
[c]
// JavaNativeCode.cpp : 定义 DLL 应用程序的导出函数。
//
/*
 * JavaNativeCode implementation
 * zhangmin@zhangmin.name
 */
#include &quot;stdafx.h&quot;

#include &lt;iostream&gt;
using namespace std;
/*
 * Class:     name_zhangmin_java_jni_JNIExample
 * Method:    sayHello
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_name_zhangmin_java_jni_JNIExample_sayHello
  (JNIEnv * env, jobject){
	  jstring jstr;
	  const char greeting[] = &quot; Hello JNI World!&quot;;
	  jstr = env-&gt;NewStringUTF(greeting);
	  cout&lt;&lt;&quot;From C++&quot;&lt;&lt;env-&gt;GetStringUTFChars(jstr,0)&lt;&lt;endl;
}

/*
 * Class:     name_zhangmin_java_jni_JNIExample
 * Method:    getPOJO
 * Signature: (I[DLname/zhangmin/java/jni/JObject;[Lname/zhangmin/java/jni/JObject;)Lname/zhangmin/java/jni/POJO;
 */
JNIEXPORT jobject JNICALL Java_name_zhangmin_java_jni_JNIExample_getPOJO
  (JNIEnv * env, jclass jc, jint i, jdoubleArray da, jobject jo, jobjectArray joa){
	  jclass pojo = env-&gt;FindClass(&quot;name/zhangmin/java/jni/POJO&quot;);
	  //获取数组元素
	  jobject ele = env-&gt;GetObjectArrayElement(joa,0);
	  jclass jobj = env-&gt;GetObjectClass(jo);
	  //调用对象的get方法
	  jint id = env-&gt;CallIntMethod(ele,env-&gt;GetMethodID(jobj,&quot;getId&quot;,&quot;()I&quot;));
	  //获取对象的属性
	  jfieldID objID = env-&gt;GetFieldID(jobj,&quot;field&quot;,&quot;D&quot;);
	  jdouble field = env-&gt;GetDoubleField(jo,objID);
	  //创建一个jdoubleArray
	  jdouble dd[2] = {1.2,3.4};
	  jdoubleArray d = env-&gt;NewDoubleArray(2);
	  env-&gt;SetDoubleArrayRegion(d,0,2,dd);
	  //通过调用对象的构造器创建一个对象
	  jobject ret = env-&gt;NewObject(pojo,
		  env-&gt;GetMethodID(pojo,&quot;&lt;init&gt;&quot;,&quot;(I[DLname/zhangmin/java/jni/JObject;)V&quot;)
		  ,id,d,ele);
	  return ret;
}

/*
 * Class:     name_zhangmin_java_jni_JNIExample
 * Method:    getData
 * Signature: ()I
 */
JNIEXPORT jint JNICALL Java_name_zhangmin_java_jni_JNIExample_getData
  (JNIEnv *, jobject){
	  jint i = 510;
	  return i;
}

/*
 * Class:     name_zhangmin_java_jni_JNIExample
 * Method:    getRefs
 * Signature: ()[Lname/zhangmin/java/jni/JObject;
 */
JNIEXPORT jobjectArray JNICALL Java_name_zhangmin_java_jni_JNIExample_getRefs
  (JNIEnv * env, jobject jobj){
	  //返回一个对象数组
	  jclass jc = env-&gt;FindClass(&quot;name/zhangmin/java/jni/JObject&quot;);
	  jobject jo = env-&gt;NewObject(jc,env-&gt;GetMethodID(jc,&quot;&lt;init&gt;&quot;,&quot;(I)V&quot;),100);
	  jobjectArray joa = env-&gt;NewObjectArray(2,jc,NULL);
	  env-&gt;SetObjectArrayElement(joa,0,jo);
	  return joa;
}

[/c]

**POJO类**

[java]
package name.zhangmin.java.jni;

/**
 * @author ZhangMin.name
 *
 */
public class POJO {
	private int i;
	private double[] d;
	private JObject obj;
	private JObject[] objs;
	public POJO(int i,double[] d,JObject obj){
		this.i = i;
		this.d = d;
		this.obj = obj;
	}
	@Override
	public String toString() {
		return i + &quot;,&quot; + d[0] + &quot;,&quot; + obj.getId() ;
	}
}

[/java]
[java]
/**
 *
 * JObject.java
 * ZhangMin.name - zhangmin@zhangmin.name
 * name.zhangmin.java
 *
 */
package name.zhangmin.java.jni;

/**
 * @author ZhangMin.name
 *
 */
public class JObject {
	private int id;
	public double field;
	public JObject(int id){
		this.id = id;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	@Override
	public String toString() {
		return id + &quot;,&quot; + field;
	}
}

[/java]