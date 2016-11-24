title: 使用Apache MINA开发Java网络应用程序
tags:
  - Java
  - 技术
id: 1866
categories:
  - Java
date: 2013-08-29 16:39:47
---

Apache MINA是一种Java NIO 的网络应用框架。通过使用Apache MINA可以开发高性能，高扩展性的网络应用程序。MINA提供基于抽象事件驱动的统一的异步API。

MINA的架构如下图所示：
![MINA架构图](http://mina.apache.org/staticresources/images/mina/mina_app_arch.png)

由上图可知，基于MINA的应用程序可分为三层：
1\. I/O Service 执行实际的I/O操作
2\. Filter Chain 将字节数据过滤成所需数据结构，或者相反
3\. I/O Handler 执行实际业务逻辑

所以，如果你要创建一个基于MINA的网络应用程序，你需要：
1\. 创建I/O Service。可以从已有的Service（*Accepter）中选择或者自己创建。
2\. 创建Filter Chain。从已有的Filters中选择或者自定义。
3\. 创建I/O Handler。处理消息或实现具体的业务逻辑。

下面是一个基于TCP/IP的TimeServer：

TimeServer的代码如下：

[java]
/**
 *
 * MinaTimeServer.java
 * ZhangMin.name - zhangmin@zhangmin.name
 * name.zhangmin.java
 *
 */
package name.zhangmin.java.mina;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.charset.Charset;
import org.apache.mina.core.service.IoAcceptor;
import org.apache.mina.core.session.IdleStatus;
import org.apache.mina.filter.codec.ProtocolCodecFilter;
import org.apache.mina.filter.codec.textline.TextLineCodecFactory;
import org.apache.mina.filter.logging.LoggingFilter;
import org.apache.mina.transport.socket.nio.NioSocketAcceptor;
/**
 * @author ZhangMin.name
 *
 */
public class MinaTimeServer {
	public static int PORT = 1234;
	/**
	 * 一个Apache MINA
	 * @param args
	 */
	public static void main(String[] args) throws IOException{
		//创建一个对象监听从客户端建立的连接
		IoAcceptor acceptor = new NioSocketAcceptor();
		//增加 一个filter，用于答应相关日志信息
		acceptor.getFilterChain().addLast(&quot;logger&quot;, new LoggingFilter());
	    //增加一个filter用于将二进制数据或者协议特定数据翻译成为Message对象，或者相反
		//本实例使用自带的TextLineFactory来处理文本信息
		acceptor.getFilterChain().addLast(&quot;codec&quot;,
					new ProtocolCodecFilter(
					new TextLineCodecFactory(
						Charset.forName(&quot;UTF-8&quot;)
						)));
		//设置处理请求的Handler
		acceptor.setHandler(new TimeServerHandler());
		//设置套接字相关的配置参数
		acceptor.getSessionConfig().setReadBufferSize(2048);
		acceptor.getSessionConfig().setIdleTime(IdleStatus.BOTH_IDLE, 10);
		//设置绑定的端口号
		acceptor.bind(new InetSocketAddress(PORT));
		System.out.println(&quot;Start listening to PORT: &quot; + PORT);
	}

}

[/java]

Handler的代码如下：

[java]
/**
 *
 * TimeServerHandler.java
 * ZhangMin.name - zhangmin@zhangmin.name
 * name.zhangmin.java
 *
 */
package name.zhangmin.java.mina;
import java.util.Date;
import org.apache.mina.core.service.IoHandlerAdapter;
import org.apache.mina.core.session.IdleStatus;
import org.apache.mina.core.session.IoSession;
/**
 * @author ZhangMin.name
 *
 */
public class TimeServerHandler extends IoHandlerAdapter {
    //处理相关异常
	@Override
	public void exceptionCaught(IoSession session, Throwable cause)
			throws Exception {
		cause.printStackTrace();
	}
   //处理从客户端发来的请求和向客户端发送数据
	@Override
	public void messageReceived(IoSession session, Object message)
			throws Exception {
		String str = message.toString();
		System.out.println(&quot;Receiving Message :&quot; + str);
		if(str.trim().equalsIgnoreCase(&quot;quit&quot;)){
			session.close(true);
			System.exit(0);
			return;
		}
		Date date = new Date();
		session.write(date.toString());
		System.out.println(&quot;Messge written...&quot;);
	}

	@Override
	public void sessionIdle(IoSession session, IdleStatus status)
			throws Exception {
		System.out.println(&quot;IDLE: &quot; + session.getIdleCount(status));
	}

}
[/java]

使用telnet程序进行测试：>telent 127.0.0.1 1234