title: Openstack了解
tags: 练笔
categories: 练笔
date: 2016-12-31 15:34:27
updated: 2016-12-31 15:34:27
---

# 云计算

云计算通常包含一个服务责任协议（Service Level Agreement），表示云计算服务商承诺给用户的性能、规格和可用率等。使用共享的计算、网路和存储提供服务，并按照用量计费。

云计算服务的特点：
1. 按需自助服务。
2. 网络访问。访问异构设备的能力。
3. 资源池。
4. 弹性。垂直或者横向扩展。
5. 按照用量计费。

# Openstack开发原则

Open（开源，开放）+Stack（多个模块组成）。
最初是NASA和Rackspace合作开发的项目，在2010年以Apache 2.0许可证开源。

Openstack是一个分散式结构的开源框架，是一个通用开源的云计算平台。

Openstack的优势：解除厂商绑定；可扩展，可定制IaaS；良好的社区氛围。
Openstack的劣势：学习曲线高；偏底层，需要大量的二次开发。

可扩展和可伸缩性是Openstack的主要目标。任何影响这两点的都是可选的。
一起都是异步的，分布式的，接收最终一致性。
测试一切。

Openstack是基于Python写的。

Openstack组件特点：
1. 分布式。可以分开部署在多个服务器上，通过网络互连。
2. 无状态。请求之间独立。
3. RESTful。API接口都是REST风格的。
4. RPC。开发网路分布式程序更容易。
5. Plugin。插件式设计。框架和扩展功能分离。

# Openstack API介绍

整个API框架结构是以WSGI标准为入口，加上routes，webob和paste等python组件构成的。
Web服务器网关接口（Web Server Gateway Interface:WSGI）是Python应用和web服务器之间的一种接口协议。
在WSGI中有application，server和client三个角色。client发送请求给server，server转发请求给application。application处理完请求后，讲响应发送给server，server再将响应转发给client。server是一个转发的作用。

webob是python上的WSGI容器。类似于Java web中的tomcat。paste是一个方便WSGI服务配置和部署的组件，通过一个loadapp函数和配置文件或者egg包。routes是一个简单的url路由组件，完成url到action的映射。

分页查询。作用一是方便查看，而是限定查询返回数目。marker表示从那条记录开始返回，limit为每次返回的记录数，end_marker为标记到那条记录结束。还可以使用changes_since限制指定时间改变后的对象。


Nova对API请求有一定的限制。获取限制详情GET /v2/{tenant_id}/limits。

Eventlet。 协程是一条执行序列，拥有自己独立的栈，局部变量，指令指针，同时又与其他协程共享全局变量和大部分应用数据。线程可以多个并行执行，而多个协程同时只能运行一个。

协程特点：
1. 每个协程有自己私有栈和局部变量。
2. 同一时间只有一个协程在执行，无需全局加锁。
3. 执行顺序可控，完全有程序控制执行。

Eventlet是一个用于处理和网络相关的Python库。依赖于greenlet和select.epoll。greenlet是eventlet并发的基础，
select库的epoll则是网络通信模型。eventlet通过协程并发。把协程封装成greenthread。所谓并发，即启动多个greenthread，并对这些greenthread进行管理，以实现非阻塞式IO。
Python库不支持协程，通过对Python网络几个库进行改写，以补丁的方式导入程序中。

协程就是运行在一个线程内的伪并发方式，最终只有一个协程在运行，有应用程序来控制执行的顺序。


# Openstack模块介绍

Openstack包括计算（computing）、网络（networking）和存储（storing）三个基础元素。

计算模块负责管理不同类型的虚拟资源，允许用户通过API来使用。
网络模块提供可插拨，可扩展的网络系统。
存储模块提供对象和块存储功能。

## Nova（Compute as a service）

Nova的设计遵循基于组件架构，高可用，容错，可恢复性，开放标准，API兼容等原则。Nova是无共享，基于消息的架构，所有组件可以分布式运行。为了避免消息队列等待的阻塞情况，每个组件都是异步响应的，只有收到消息才触发回调。

Nova支持多种后端Hypervisor创建虚拟机，如KVM，Xen，LXC，VMware等。Nova使用libvirt来管理多种Hypervisor。

Nova创建的虚拟机有多种状态，分别是vm_state（nova-api调用，与用户操作期望相匹配，自上而下的实现），task_state（API调用最终实现的过渡态）, power_state（hypervisor中的虚拟机状态，自下而上的实现）。

Nova是由多个组件构成的分布式应用程序。组件工作者守护进程（Worker daemon）执行复杂任务。

nova-api。有Web服务网关接口（Web Server Gateway Interface:WSGI），负责接收和解释API调用。部署在控制节点。
nova-scheduler。从队列中取出一个虚拟机创建请求，并决定在那一台物理机上进行创建。涉及资源的调度。
用户可以自定义调度算法。部署在控制节点。
nova-compute。用于创建和终止虚拟机实例。部署在具体部署虚拟机的物理节点上，称为计算节点。
nova-conduct。新版本用于代理nova-compute节点对数据库的读写操作。nova-compute将数据库读写请求发送到消协队列中。nova-conduct从消协队列中去消息进行操作。

## Neutron（Networking as a service）

Neutron接收来自虚拟机的指令来定义虚拟机所需的网络，然后发送指令给交换机和路由器来创建这些网络。Neutron通过plug-in的方式扩展。核心功能是提供虚拟机与外界网络的连接。

1. neutron-server。接收API请求，储存数据，然后将请求路由到各个agent组件，执行具体操作。
2. neutron-plugin-xxx。底层网路虚拟化技术的插件。必须和neutron-server安装在一个节点上。
3. neutron-plugin-xxx-agent。plugin的agent。agent负责在虚拟网络上的数据包进行处理。通过消息队列与plugin和neutron-server交互。收到指令后在相应的节点上执行底层网络命令。agent必须安装在那些需要处理虚拟机网络数据包的节点上，如虚拟机的计算节点，在安装了neutron-dhcp-agent和neutron-l3
-agent， neutron-lbaas-agent服务的节点上，因为它们乣处理流入或者流出虚拟机的网络数据。

neutron-dhcp-agent是给虚拟机提供dhcp功能的一个服务。在一个环境中可以有多个，因为为特定的网络指定dhcp-agent。
neutron-l3-agent是提供虚拟机访问外部网络的功能，结合floating ip可以使外部网络访问平台上的虚拟机。在原理上是利用linux的ip栈和iptables来实现三层路由的转发和NAT功能。

另外还有提供元数据注入，负载均衡和防火墙功能的agent。

Neutron中的核心概念：

1. network。一个网络。
2. subnet。一个子网就像在交换机使用vlan划分出来的一样。
3. router。在不同子网或者网络之间转发数据。
4. port。交换机上用来插入网线的口。

虚拟出来的这些设备可以实现物理设备同样的功能。

Neutron还可以设置一个以上的外部网络，外部网络和上面的网络不同，不是软件定义的网络。这个网络所分配的IP地址，都是可以从外部访问。

如果一个Internet用户要访问Openstack云平台一个SDN虚拟网络IP，则需要创建一个router，把这两个网络连起来，转发数据。同时，neutron也会把外部IP地址绑定到这个虚拟网络连接的端口上。

neutron也支持防火墙和安全组的功能。安全组可以定义开发端口的范围，从进入和外出两个方向进行控制。

三种网络管理器：

1. flat。基础网络，每个应用实例分配一个固定的ip地址，并连接到一个共同的网桥。该种模式最大缺陷是不能进行网络隔离。
2. flatdhcp。使用dhcp来分配ip。其他同flat。
3. vlan。支持大部分物理vlan特性。虚拟子网和独立网桥。有隔离作用但是缺少QoS，ACL，监控等功能。而且需要物理的vlan交换机参与，不能实现跨机房二层通信。

Open vSwitch（OVS）是一个开源的虚拟交换机软件，可以在系统的管理程序中运行，还可以控制物理机的交换设备。OVS的plugin在neutron-server运行时被载入，负责处理API请求和后端数据库中保存网络逻辑数据。OVS的agent在每个计算节点和网络节点运行，负责从配置文件和数据库收集数据，并与本地的OVS实例通信，并把执行的网络流程操作发送给实例。

OVS可以在内和空间，也可以在用户空间。OVS与物理交换机类似，会根据端口上的配置，给流经的数据打上合适的标签并转发。
除了一开始需要手动建立几个网桥，其他大多数是neutron和OVS通信都是通过plugin来完成的。

Neutron创建的网络可以分为：
1. provider网络。由管理员创建，直接映射到所在数据中心的物理网络。可以给虚拟机使用，也能给router使用。provider网络可以被设置为flat（扁平网络，没有任何tagged），vlan（符合802.1Q tagged的网络），GRE（tunnel技术进行数据传送）。
2. tenant网络。租户tenant创建的网络，不同租户之间是相互独立和隔离的。

## Cinder（Block Storage as a service)

架构和实现与nova类似。

cinder-api。接收和分发API。
cinder-volume。多个后端存储支持。
cinder-scheduler。决定在那个存储节点创建cinder-volume实例。


## Swift（Object Storage as a service）

Swift是一种高可用、分布式的一致性对象存储软件，提供云方式的存储和管理。

提供文件的对象存储及服务。才用对象级别的复制，以保障数据。ext4和xfs作为文件系统存储对象。

swift-proxy。
swift-account。
swift-container。
swift-object。

## Glance（Image as a service）
Glance模块为存储和查询镜像服务，用于发现，注册和检索云平台中的虚拟磁盘镜像。

Glance包括glance-api和glance-registry。

Openstack支持不同的虚拟化技术，每种虚拟化技术使用不同格式的虚拟机镜像文件格式。常见的格式有RAW（裸格式），qcow2（可以动态变化）等。

Glance可以配置不同的镜像后端存储，如本地，CEPH。


## Keystone（Identity as a service）

Keystone提供两个关键功能：
1. 用户管理。控制管理追踪用户访问权限。
2. 服务目录管理。提供哪些服务目录可以访问。

Keystone核心概念：
1. 用户（user）。谁来使用openstack。用户从Keystone获取token来访问openstack服务。用户可以分配给某个租户，访问租户下的资源。
2. 证书（credentials）。只被所有者知道的数据。数据所有者可以通过证书证明自己。如匹配的用户名和密码，匹配的用户名和API访问秘钥，通信令牌（token）。
3. 认证（authentication）。使用用户的证书确认用户的真实身份。首次通过用户名和密码，之后可以通过使用token实现。
4. 令牌（token）。任意比特位的文本，每个令牌都有一个访问范围，时间限制，持续时间，可被撤销。
5. 租户（tenant）。用于分组和分离资源。租户可以映射到一个团体，组织或者项目。
6. 服务（service）。一个服务提供一个或者多个访问点，通过访问点访问资源和执行操作。
7. 访问点（endpoint）。可以网络访问的url。
8. 角色（role）。每个角色有一组权力和特权。可以被继承。

访问任何服务都要通过Keystone来进行认证。

## Horizon（Dashboard as a service）

提供用户界面操作Openstack计算，网络，存储资源。

## 其他项目

Openstack孵化的项目有：Ceilometer 计费和监控服务，Heat编排服务，Ironic物理设备服务，Marconi消息队列服务。
Savannna大数据处理服务，Trove数据库服务。

