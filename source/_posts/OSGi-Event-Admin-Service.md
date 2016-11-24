title: OSGi Event Admin Service
tags:
  - Java
  - OSGi
id: 2276
categories:
  - Java
date: 2014-07-03 16:10:38
---

Event Admin是OSGi中用于bundles之间通信的手段,是处理事件的一种通用机制。采用的是pub/sub架构。

### 发布订阅模型

发布订阅模型应满足的需求：

1\. 发布者不应该拥有订阅者的信息。
2\. 新的发布者或者新的订阅者的动态增加或者删除不能影响这个发布订阅系统
3\. 订阅者不应该阻塞发布者。

在发布订阅模型需要一个中间人来解耦发布者和订阅者。在Event Admin Service中这个中间人就是EventAdmin。

Event Admin service使用Topic来定义分发通道，类似于JMS。发布者发送事件到Topic，订阅者从Topic中接受信息。向Topic发送事件的发布者可以是多个，从Topic接受的订阅者也可以是多个。也就是说是一种多对多的关系。

下面是示例代码：

[java]
SimpleSubscriber subscriber = new SimpleSubscriber();
Dictionary dict = new Properties();
dict.put(EventConstants.EVENT_TOPIC,
&quot;manning/osgi/LoginEvent&quot;);
context.registerService(EventHandler.class.getName(),
subscriber, dict);​
[/java]
[java]
public class SimpleSubscriber implements EventHandler {
public void handleEvent(Event event) {
System.out.println(&quot;Received event on topic = &quot; +
event.getTopic());
for (String propertyName :
event.getPropertyNames()) {
System.out.println(&quot;\t&quot; + propertyName + &quot; = &quot; +
event.getProperty(propertyName));
​}
}
}
[/java]

### Topic

Topic一般使用类似于java的包名的命名方法，只不过使用右斜杠替换点号。

如果使用"manning/osgi/TravelAgent/*"，则会匹配四层的事件，如
"manning/osgi/TravelAgent/CarEvent"
"manning/osgi/TravelAgent/HotelEvent"
"manning/osgi/TravelAgent/FlightEvent"
但不会匹配
​"manning/osgi/TravelAgent/HotelEvent/USA"
"manning/osgi/TravelAgent"
因为它们一个是五层一个是四层。

一个空的或者不存在的EVENT_TOPIC表示不接受任何事件，一个通配符"*"表示接收所有事件。

指定多个订阅者接收多种事件的方法是使用Sring[]。

[java]
Dictionary dict = new Properties();
dict.put(EventConstants.EVENT_TOPIC,
new String [] {&quot;manning/osgi/TravelAgent/CarEvent&quot;,
&quot;manning/osgi/TravelAgent/HotelEvent&quot;,
&quot;manning/osgi/TravelAgent/FlightEvent&quot;});
context.registerService(EventHandler.class.getName(),
subscriber, dict);
[/java]​

### Event

Event对象包含Topic名和时间相关的属性信息。自定义事件对象必须继承Event。关于事件的常量最好放到一个Property对象中，而不是写在代码中。

#### OSGi框架的事件

框架变化：包括启动类路径变化，包刷新，异常，被停止等等。
bundle变化：包括安装，更新，卸载。
服务变化：服务注册，修改，删除。

这些事件可以通过bundle context进行监听。事件会按照注册的顺序进行发送。
[java]
public void start(BundleContext bundleContext) throws Exception {
BundleListener bundleListener = // ...
bundleContext.addBundleListener(bundleListener);
// ...
}
[/java]​

[java]
public class MyBundleListener implements BundleListener {
public void bundleChanged(BundleEvent bundleEvent) {
if (bundleEvent.getType() == BundleEvent.INSTALLED) {
// ...
}
}
}
[/java]​

BundleEvent 包含一个Bundle类的实例，可以通过这个类来获取bundle的任何内容。

### 事件处理

EventAdmin的post方法异步发送事件，是非阻塞的；而send则是同步发送事件，是阻塞的。

要注意EvenHandler的handleEvent方法要尽快返回，而且该方法有可能被阻塞。

事件的传递顺序也受发布者发布方式的影响。如果是多线程发送，则无法保证事件的顺序。

如果handleEvent抛出一个异常，该异常并不会传递到发布者，EventAdmin会处理下一个订阅者。

EventAdmin在发送事件时会将所有可用的订阅者做一份拷贝，这就避免了订阅者收到在它存在之前的事件。同时，EventAdmin也会确保订阅者仍然注册并愿意接收事件。

由于发布者和订阅者的解耦，要特别注意发生死锁的情况。

### 事件过滤

使用EVENT_FILTERE来进行事件过滤。

[java]
Dictionary payload = new Properties();
payload.put(&quot;price&quot;, 80);
Event event =
new Event(&quot;manning/osgi/TravelAgent/HotelEvent&quot;, payload);
admin.postEvent(event);
[/java]
[java]
Dictionary dict = new Properties();
dict.put(EventConstants.EVENT_TOPIC,
&quot;manning/osgi/TravelAgent/HotelEvent&quot;);
dict.put(EventConstants.EVENT_FILTER, &quot;(price&lt;100)&quot;);
context.registerService(EventHandler.class.getName(),
travelAgentEventHandler, dict);
[/java]​

### Event Admin的缺点

​1\. 事件丢失

如果Event Admin突然挂掉，事件就会丢失。解决的办法是可以通过配置让Event Admin对事件进行持久化存储。

1.  过滤能力有限

基于LDAP的过滤机制很难实现复杂的事件过滤。解决的方法是通过插入复杂事件处理引擎来实现。
另一个问题是对于大型系统事件的关联属性可能很多，处理起来会非常复杂，而且有可能导致事件内容过大。解决的办法是直接发送
java 对象，然后再接收端进行相应的处理。
另一个缺点是服务保证订阅者接受事件的顺序。解决的方法是扩展EventAdmin。