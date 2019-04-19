title: ARTS-005-20190415-分治算法-Spring依赖管理-SpringBoot-Starter-计算的未来是模拟的
tags:
  - ARTS
  - ''
categories:
  - ARTS
  - ''
author: ZhangMin.name
date: 2019-04-19 15:52:00
---
# Algorithm
[分治算法](/blog/2019/04/19/分治算法/)

# Review
[Spring依赖管理](/blog/2019/04/16/Spring依赖管理/)

# Tips

## 如何定制自己的springboot-starter项目

在没有starter项目之前，需要自己管理maven依赖，如实现某一个功能时，需要引入哪些依赖，版本是多少。多个项目之间的依赖可能还有兼容问题，需要使用
maven的dependency:tree或者maven的IDE插件来排查，然后通过exclusion来排除相关冲突的依赖。

在springboot中，通过maven的dependencyManagement管理版本，还使用Bill of Materials(BOM)来管理依赖。如SpringBoot Parent的POM：
https://github.com/spring-projects/spring-boot/blob/master/spring-boot-project/spring-boot-parent/pom.xml

如果自己的项目也是一个父项目和多个子项目，则也可以使用BOM来统一管理。

为了和官方的springboot starter项目作区分，自己定义的starter的名称可以是：xxx-spring-boot-starter。下面是一个自定义starter项目的pom文件配置：

```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
   <modelVersion>4.0.0</modelVersion>
   <groupId>geektime.spring.hello</groupId>
   <artifactId>geektime-spring-boot-starter</artifactId>
   <version>0.0.1-SNAPSHOT</version>
   <name>geektime-spring-boot-starter</name>
   <description>Demo project for Spring Boot</description>

   <dependencies>
      <dependency>
         <groupId>geektime.spring.hello</groupId>
         <artifactId>geektime-spring-boot-autoconfigure</artifactId>
         <version>0.0.1-SNAPSHOT</version>
      </dependency>
      <dependency>
         <groupId>geektime.spring.hello</groupId>
         <artifactId>greeting</artifactId>
         <version>0.0.1-SNAPSHOT</version>
      </dependency>
   </dependencies>

</project>
```

官方的starter项目参考[Redis starter](https://github.com/spring-projects/spring-boot/blob/master/spring-boot-project/spring-boot-starters/spring-boot-starter-data-redis/pom.xml)
```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starters</artifactId>
		<version>${revision}</version>
	</parent>
	<artifactId>spring-boot-starter-data-redis</artifactId>
	<name>Spring Boot Data Redis Starter</name>
	<description>Starter for using Redis key-value data store with Spring Data Redis and
		the Lettuce client</description>
	<properties>
		<main.basedir>${basedir}/../../..</main.basedir>
	</properties>
	<dependencies>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter</artifactId>
		</dependency>
		<dependency>
			<groupId>org.springframework.data</groupId>
			<artifactId>spring-data-redis</artifactId>
			<exclusions>
				<exclusion>
					<groupId>org.slf4j</groupId>
					<artifactId>jcl-over-slf4j</artifactId>
				</exclusion>
			</exclusions>
		</dependency>
		<dependency>
			<groupId>io.lettuce</groupId>
			<artifactId>lettuce-core</artifactId>
		</dependency>
	</dependencies>
</project>
```

# Share

[The future of computing is analog](https://onezero.medium.com/the-future-of-computing-is-analog-e758471fbfe1)

这篇文章介绍了模拟计算和电子计算的不同，以及两者的关系。作者关心的是计算机会不会取得控制权。

过去的计算机从模拟时代发展到了电子时代。电子计算机通过真空管实现，模拟计算通过固态实现。但是模拟计算依然存在，即使在商业上没有电子计算机出色。

电子计算处理整数，二进制序列，确定性的逻辑，时间被离散化处理。电子计算机执行两类变换：代表空间的比特，和代表时间的比特。这两者之间的变换由计算机程序控制，只要计算机需要程序员，我们就可以保持控制权。

模拟计算可以处理实数，非确定性的逻辑，连续函数，包括真实世界中的时间。模拟计算机也调解两类信息：空间的结构和时间的行为。没有代码，没有编程。模拟计算的复杂性是在其网络拓扑，而不是代码。信息是按照连续函数的值进行处理，如电压和相关的脉冲频率。而不是对离散二进制位的逻辑运算。我们甚至不知道为什么，自然进化成了模拟计算，即我们的升神经系统，吸收来自世界的信息。他们可以通过学习控制自己的行为，延伸到可以控制周围的环境。

现在的计算还只是使用电子计算机模拟神经网络。但是随着自动驾驶汽车，手机，以及神经网络处理器的开发，可能实现真实的神经网络，并会逐渐渗透到我们的生活，并控制整个世界。

> 人工智能的发展已经引起了智人的注意，但是我们应该担心的是逐渐出现的模拟计算对我们的控制。
