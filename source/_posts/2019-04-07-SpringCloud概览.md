title: SpringCloud概览
tags:
  - ARTS
categories:
  - ARTS
date: 2019-04-07 16:12:00
updated: 2019-04-07 16:12:02
---
# Spring Cloud的功能

Spring Cloud提供的典型的使用示例和扩展机制：
1. 分布式多版本配置。
1. 服务注册和发现。
1. 路由。
1. 服务到服务的调用。
1. 负载均衡。
1. 熔断器。
1. 分布式消息。


# 云原生应用

云原生是一种应用开发风格，鼓励使用持续交付的最佳实践和价值导向的开发。和云原生相关的是12-factor应用。

云原生应用的开发会与应用的交付和运维相结合。如使用声明式的编程，管理和监控。

Spring Cloud加速云原生应用的开发，提供分布式应用中最常见的组件。这些组件都是基于Spring Boot开发。主要提供两个类库：Spring Cloud Context和Spring Cloud Common。
- Spring Cloud Context为Spring Cloud的应用的ApplicationContext提供工具类和特殊服务，如启动上下文，加密，作用域刷新，环境等。
- Spring Cloud Common是通用类的抽象，在Spring Cloud的各种实现中使用，如Spring Cloud Netflix和Spring Cloud Consul。


## Spring Cloud Context

Spring Boot有其自己的规范，如通用配置文件的位置，通用的管理和监控任务。Spring Cloud基于Spring Boot构建，提供新的特性，这些特性在开发云原生应用时会被用到。

Spring Cloud应用的运行时通过创建“bootstrap”上下文，这个上下文是应用的父上下文，复杂加载配置文件和解密外部的配置文件。

另外还介绍了bootstrap上下文的自定义方式，日志配置，环境改变，作用域刷新，加密解密以及监控端点。


## Spring Cloud Commons

服务发现，负载均衡，熔断器等作为通用的抽象层，和具体的实现分离，如服务发现可以使用Eureka和Consul实现。

然后介绍了`@EnableDiscoverClient`注解的工作原理，服务注册，负载均衡客户端和Spring已有的HTTP客户端的集成使用，忽略特定的网络接口，HTTP客户端工厂配置，Spring Cloud Feature的监控端点配置等。


# 参考资料

1. [SpringCloud官方文档](https://cloud.spring.io/spring-cloud-static/Greenwich.RELEASE/single/spring-cloud.html#_cloud_native_applications)