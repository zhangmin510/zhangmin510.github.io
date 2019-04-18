title: 如何实现自己的SpringBoot Autoconfigure
tags:
  - JAVA
  - ''
categories:
  - JAVA
  - ''
author: ZhangMin.name
date: 2019-04-16 18:43:00
---
# SpringBoot基本原理

`SpringBoot`可以帮助我们更好的使用`Spring`，更快的配置一个可以运行的Spring应用。

`SpringBoot`实现自动配置实现的入口是`@EnableAutoConfiguration`注解，该注解又通过`@Import`注解导入了`AutoConfigurationImportSelector`，在该类中实现了对`META-INF/spring.factories`中
`org.springframework.boot.autoconfigure.EnableAutoConfiguration`属性指定的所有配置，如`org.springframework.boot.autoconfigure.cache.CacheAutoConfiguration`。

```
//文件：spring-boot-autoconfigure-2.1.3.RELEASE.jar!/META-INF/spring.factories

# Auto Configure
org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
org.springframework.boot.autoconfigure.admin.SpringApplicationAdminJmxAutoConfiguration,\
org.springframework.boot.autoconfigure.aop.AopAutoConfiguration,\
org.springframework.boot.autoconfigure.amqp.RabbitAutoConfiguration,\
org.springframework.boot.autoconfigure.batch.BatchAutoConfiguration,\
org.springframework.boot.autoconfigure.cache.CacheAutoConfiguration,\
```
在CacheAutoConfiguration中，通过条件注解`@ConditionalOnXXX`，以及`@Import`注解来实现对缓存功能的相关`Bean`的自动配置。

```
// 文件：spring-boot-autoconfigure-2.1.3.RELEASE-sources.jar!/org/springframework/boot/autoconfigure/cache/CacheAutoConfiguration.java

@Configuration
@ConditionalOnClass(CacheManager.class)
@ConditionalOnBean(CacheAspectSupport.class)
@ConditionalOnMissingBean(value = CacheManager.class, name = "cacheResolver")
@EnableConfigurationProperties(CacheProperties.class)
@AutoConfigureAfter({ CouchbaseAutoConfiguration.class, HazelcastAutoConfiguration.class,
		HibernateJpaAutoConfiguration.class, RedisAutoConfiguration.class })
@Import(CacheConfigurationImportSelector.class)
public class CacheAutoConfiguration {

	@Bean
	@ConditionalOnMissingBean
	public CacheManagerCustomizers cacheManagerCustomizers(
			ObjectProvider<CacheManagerCustomizer<?>> customizers) {
		return new CacheManagerCustomizers(
				customizers.orderedStream().collect(Collectors.toList()));
	}
```

# 实现自己的AutoConfiguration

在实际开发过程中，我们可能需要将公司内部的，或者Spring官方还不支持的第三方类库集成到我们的项目中。但是为了重用，最好能够按照SpringBoot的自动配置来配置。


## 第一步：引入Spring官方依赖

项目的pom文件：

```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>
    <!-- 和Spring官方的自动配置做区分 -->
	<groupId>geektime.spring.hello</groupId>
	<artifactId>geektime-spring-boot-autoconfigure</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<name>geektime-spring-boot-autoconfigure</name>
	<description>Demo project for Spring Boot</description>

	<properties>
		<java.version>1.8</java.version>
		<spring-boot.version>2.1.3.RELEASE</spring-boot.version>
	</properties>

     <!-- 引入Spring官方的配置管理 -->
	<dependencyManagement>
		<dependencies>
			<dependency>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-dependencies</artifactId>
				<version>${spring-boot.version}</version>
				<type>pom</type>
				<scope>import</scope>
			</dependency>
		</dependencies>
	</dependencyManagement>

	<dependencies>
         <!-- 引入SpringBoot的自动配置模块 -->
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-autoconfigure</artifactId>
		</dependency>

        <!-- 自己的定义第三方依赖 -->
		<dependency>
			<groupId>geektime.spring.hello</groupId>
			<artifactId>greeting</artifactId>
			<version>0.0.1-SNAPSHOT</version>
			<scope>provided</scope>
		</dependency>
	</dependencies>

</project>
```


## 第二步：编写Java Configuration，并添加条件注解

Spring支持的条件注解：
   - 条件注解@Conditional
   - 类条件@ConditionalOnClass，@ConditionalOnMissingClass
   - 属性条件@ConditionalOnProperty
   - Bean 条件@ConditionalOnBean，@ConditionalOnMissingBean，@ConditionalOnSingleCandidate
   - 资源条件@ConditionalOnResource
   - Web 应⽤用条件@ConditionalOnWebApplication，@ConditionalOnNotWebApplication
   - 其他条件@ConditionalOnExpression，@ConditionalOnJava，@ConditionalOnJndi

Java Configuration代码如下：
```
@Configuration
@ConditionalOnClass(GreetingApplicationRunner.class)
public class GreetingAutoConfiguration {
    @Bean
    @ConditionalOnMissingBean(GreetingApplicationRunner.class)
    @ConditionalOnProperty(name = "greeting.enabled", havingValue = "true", matchIfMissing = true)
    public GreetingApplicationRunner greetingApplicationRunner() {
        return new GreetingApplicationRunner();
    }
}
```

## 第三步：定位自动配置

在当前项目的`resource`目录下的`META-INF`目录下创建`spring.factories`文件，内容如下：
```
org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
geektime.spring.hello.greeting.GreetingAutoConfiguration
```

## 第四步：定义自动配置的执行顺序

主要的注解有：
- @AutoConfigureBefore
- @AutoConfigureAfter
- @AutoConfigureOrder

一般不需要，具体使用可以参考[Spring官方的自动配置](https://github.com/spring-projects/spring-boot/tree/master/spring-boot-project/spring-boot-autoconfigure/src/main/java/org/springframework/boot/autoconfigure)。


# 如何在不支持SpringBoot的老版本Spring中实现SpringBoot


如果在老版本的Spring中实现类似SpringBoot的自动配置功能，则需要使用Spring的扩展点机制，原理可以参考博文[Spring框架的扩展点](/blog/2019/04/16/Spring框架的扩展点/)。


添加一个Configuration：
```
@Configuration
public class GreetingAutoConfiguration {
    @Bean
    public static GreetingBeanFactoryPostProcessor greetingBeanFactoryPostProcessor() {
        return new GreetingBeanFactoryPostProcessor();
    }
}
```
自定义一个`BeanFactoryPostProcessor`实现类似条件注解的功能：

```
@Slf4j
public class GreetingBeanFactoryPostProcessor implements BeanFactoryPostProcessor {
    public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) throws BeansException {
        boolean hasClass = ClassUtils.isPresent("geektime.spring.hello.greeting.GreetingApplicationRunner",
                GreetingBeanFactoryPostProcessor.class.getClassLoader());
        if (!hasClass) {
            log.info("GreetingApplicationRunner is NOT present in CLASSPATH.");
            return;
        }

        if (beanFactory.containsBeanDefinition("greetingApplicationRunner")) {
            log.info("We already have a greetingApplicationRunner bean registered.");
            return;
        }

        register(beanFactory);
    }

    private void register(ConfigurableListableBeanFactory beanFactory) {
        if (beanFactory instanceof BeanDefinitionRegistry) {
            GenericBeanDefinition beanDefinition = new GenericBeanDefinition();
            beanDefinition.setBeanClass(GreetingApplicationRunner.class);

            ((BeanDefinitionRegistry) beanFactory)
                    .registerBeanDefinition("greetingApplicationRunner",
                            beanDefinition);
        } else {
            beanFactory.registerSingleton("greetingApplicationRunner",
                    new GreetingApplicationRunner());
        }
    }
}
```



# 参考资料

1. [Spring框架的扩展点](/blog/2019/04/16/Spring框架的扩展点/)
1. [Spring全家桶视频课程之SpringBoot](https://time.geekbang.org/course/detail/156-87616)
1. [Spring全家桶课程代码](https://github.com/digitalsonic/geektime-spring-family/tree/master/Chapter%209)





