title: Spring OSGi中如何获取ApplicationContext
tags:
  - Java
  - OSGi
id: 1988
categories:
  - Java
date: 2013-10-22 16:58:26
---

### Application Context的创建

Spring OSGi提供org.springframework.osgi.extender这个Bundle来为每个支持Spring功能的Bundle初始化一个Application Context。当extender Bundle启动后，它会为那些状态为ACTIVE并且支持Spring的Bundle创建application context。也就是说，这个Bundle通过监听bundle启动事件来完成Application Context的创建。Extender bundle创建application context是异步的，通过不同的线程启动每个Bundle。这样可以保证启动平台快速并且Bundles之间的服务引用不会引起死锁。如果 application context创建失败，bundle会是ACTIVE状态，但是这时将没有服务导出。
这和Application context销毁相反，Application context销毁是同步的，通过同一个线程。

### 如何判断Application Context创建创建成功

当Application Context创建成功后，这个对象会被注册为一个服务。这个服务接口是 org.springframework.context.ApplicationContext。并且这个服务带有一个服务属性：org.springframework.context.service.name，对应的值为Bundle的symbolic name，这个值在Manifest文件中定义。注册这个服务主要目的是更容易测试管理。通过引用这个服务调用getBean()或类似的方法是不推荐的。建议的方式的将需要的Bean发布成一个服务，然后需要这个服务的Bundle引用它。

### 如何在Bundle中获得OSGi的BundleContext

Application context创建成功后会包含一个类型为BundleContext，名字为bundleContext的Bean。你可以在配制文件注入这个Bean。此外，你还可以通过实现org.springframework.osgi.context.BundleContextAware接口来获取。

当一个bundle停止了，它发布的服务将会从服务注册表里删除，它的状态变成RESOLVED，它将释放所有资源，停止所有线程，但是导出的Packages对其他bundle继续有效。所有资源加载通过org.springframework.core.io.ResourceLoader并且通过它关将资源加入到application context。

### 如何在一个Bundle中获取Spring Extender创建的ApplicationContext

1.通过实现ApplicationContextAware接口

Spring中提供一些Aware相关接口，像是BeanFactoryAware、ApplicationContextAware、ResourceLoaderAware、ServletContextAware等等。这些Aware接口的Bean在被初始之后，可以取得一些相对应的资源，例如实现BeanFactoryAware的Bean在初始化后，Spring容器将会注入BeanFactory的实例，而实作ApplicationContextAware的Bean，在Bean被初始后，将会被注入 ApplicationContext的实例等等。
[java]
 public class SomeBean implements ApplicationContextAware{
      private ApplicationContext context;
      ...
      public void setApplicationContext(ApplicationContext     applicationcontext) throws BeansException {
         this.context= applicationcontext;
      }
   }
[/java]

2.通过OSGi Service

[java]
public static ApplicationContext getApplicationContext(final BundleContext bundleContext) {
        final String filter = &quot;(org.springframework.context.service.name=&quot; + bundleContext.getBundle().getSymbolicName() + &quot;)&quot;;
        final ServiceReference[] applicationContextRefs;
        final ApplicationContext applicationContext;
        try {
            applicationContextRefs = bundleContext.getServiceReferences(ApplicationContext.class.getName(), filter);
        } catch (final InvalidSyntaxException e) {/&gt;
            throw new RuntimeException(e);
        }
        if(applicationContextRefs.length != 1) {
            return null;
        }
        applicationContext = (ApplicationContext) bundleContext.getService(applicationContextRefs[0]);
       return applicationContext;
}
[/java]

### 参考

1.[Spring DM Application Context](http://www.cnblogs.com/ygyinx/archive/2012/10/27/osgi_application_context.html)

2.[Ways to get Spring ApplicationContext -In Spring DM](http://tech-tauk.blogspot.com/2009/10/ways-to-get-spring-applicationcontext.html)

3.[Spring OSGi - how to get ApplicationContext for a bundle](http://mindpipe.blogspot.com/2011/03/spring-osgi-how-to-get.html)