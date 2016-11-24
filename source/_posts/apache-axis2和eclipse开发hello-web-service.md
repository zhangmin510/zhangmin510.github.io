title: apache axis2和eclipse开发hello web service
tags:
  - Web Service
id: 1082
categories:
  - Java
date: 2013-03-20 14:59:20
---

**Axis2**

Axis2是下一代 Apache Axis。Axis2 虽然由 Axis 1.x 处理程序模型提供支持，但它具有更强的灵活性并可扩展到新的体系结构。Axis2 基于新的体系结构进行了全新编写，而且没有采用 Axis 1.x 的常用代码。支持开发 Axis2 的动力是探寻模块化更强、灵活性更高和更有效的体系结构，这种体系结构可以很容易地插入到其他相关 Web 服务标准和协议（如 WS-Security、WS-ReliableMessaging 等）的实现中。
Apache Axis2 是Axis的后续版本，是新一代的SOAP引擎。

**下载与安装**

下载axis2 Binary Distribution：http://axis.apache.org/axis2/java/core/download.cgi

解压到一个单独的目录即可。

下载 Service Archive Wizard - Eclipse Plug-in和Code Generator Wizard - Eclipse Plug-in：http://axis.apache.org/axis2/java/core/tools/index.html

解压后，将两个jar 文件放到eclipse的dropsin目录，并重启eclipse。

**编写服务代码**

新建一个java项目，代码如下：

[java]

package com.example;
public class HelloWebService {
 /**
 * say hello service
 * @param name
 * @return
 */
 public String sayHello(String name){
 return &quot;hello &quot;+name;
 }
 /**
 * add service
 * @param a
 * @param b
 * @return
 */
 public int add(int a,int b){
 return a+b;
 }
}

[/java]

然后利用Axis2 Service Archiver打包-&gt;class file location 为项目的bin目录-&gt;选择skip wsdl-&gt;如果没有引用其他jar文件点击下一步-&gt;选择自动生成service xml文件-&gt;输入服务名称(随意)、类全名-&gt;设置aar文件名以及存放目录-&gt;Finish.

这是生成一个HelloWebService.aar文件，该文件很像一个jar包，文件中META-INF目录下的service.xml 内容如下，描述了你创建的服务。

[xml]

&lt;?xml version=&quot;1.0&quot;?&gt;
-&lt;service name=&quot;HelloWebService&quot;&gt; &lt;description&gt; Please Type your service description here &lt;/description&gt; -&lt;messageReceivers&gt; &lt;messageReceiver class=&quot;org.apache.axis2.rpc.receivers.RPCInOnlyMessageReceiver&quot; mep=&quot;http://www.w3.org/2004/08/wsdl/in-only&quot;/&gt; &lt;messageReceiver class=&quot;org.apache.axis2.rpc.receivers.RPCMessageReceiver&quot; mep=&quot;http://www.w3.org/2004/08/wsdl/in-out&quot;/&gt; &lt;/messageReceivers&gt; &lt;parameter name=&quot;ServiceClass&quot;&gt;com.example.HelloWebService&lt;/parameter&gt; &lt;/service&gt;

[/xml]

**发布Web Service**

将生成的HelloWebService.aar 文件拷贝到...axis2-1.6.2repositoryservices目录中，然后运行...axis2-1.6.2bin中的axis2server.bat 文件。启动后访问http://localhost:8080/axis2/services/就可以看到你的服务的描述了。

HelloWebService

Available operations

*   add
*   sayHello
点击[HelloWebService](http://localhost:8080/axis2/services/HelloWebService?wsdl)可以看到发布服务的wsdl文件。
**生成客户端代码
**选择Eclipse Wizard 中的Axis2 Code Generator-&gt;选择Generate Java source code from a WSDL file-&gt;输入wsdl location：http://localhost:8080/axis2/services/HelloWebService?wsdl-&gt;选择output为你的项目-&gt;Finish。
然后添加axis2 Binary Distribution lib中的所有jar文件。

**编写测试代码
**编写代码如下：
[java]
package com.example.test;
import java.rmi.RemoteException;
import com.example.Add;
import com.example.AddResponse;
import com.example.HelloWebService;
import com.example.HelloWebServiceStub;
import com.example.SayHello;
import com.example.SayHelloResponse;
public class Client {
 /**
 * @param args
 */
 public static void main(String[] args) {
 // TODO Auto-generated method stub
 HelloWebServiceStub hws;
 try {
 hws = new HelloWebServiceStub();
 SayHello sh = new SayHello();
 sh.setName(&quot;world&quot;);
 SayHelloResponse shr = hws.sayHello(sh);
 System.out.println(shr.get_return());

 Add add = new Add();
 add.setA(1);
 add.setB(1);
 AddResponse ar = hws.add(add);
 System.out.println(ar.get_return());

 } catch (RemoteException e) {
 // TODO Auto-generated catch block
 e.printStackTrace();
 }
 }
}
[/java]
运行结果为：
hello world
2

**可能出现的错误的解决方法**

Unsupported major.minor version 51.0 错误：用jdk7编译的class文件放到基于jdk6运行在tomcat之中，就会报这个错。打开exclipse中项目上的属性—java compiler–选择一个合适的版本后重新编译即可。

_参考文章_

_1)http://blog.csdn.net/xiaochunyong/article/details/7764683_

_2)http://blog.163.com/tuchengju@126/blog/static/38071165201111196597487/_

_3)http://baike.baidu.com/view/2435061.htm_

4)http://axis.apache.org/axis2/java/core/index.html