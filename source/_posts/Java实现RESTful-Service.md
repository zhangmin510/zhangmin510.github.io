title: Java实现RESTful Service
tags:
  - Java
  - Web Service
id: 2298
categories:
  - Java
date: 2014-07-16 14:41:24
---

原文地址：[http://www.vogella.com/tutorials/REST/article.html](http://www.vogella.com/tutorials/REST/article.html)

本教程介绍了如何使用JAX-RS的参考实现Jersey来实现REST Web Service。
本教程使用Eclipse 4.4，Java 1.6，Tomcat 6.0 及JAX-RS 1.1 (Jersey 1.5)。

### 1.REST-Representational State Transfer

#### 1.1 什么是REST

REST是一种基于web标准和http协议的架构风格。REST是由Roy Fielding在2000年提出的。
在REST中一切都是resource，resource的访问是通过Http的标准接口来实现的。有一个REST服务器提供相关REST的服务，如
访问resource，修改resource。
每种resource都有一个唯一的URI标识，且都应该支持标准的http操作。REST允许resource使用不同的表示方法，如文本，XML，JSON等。
REST客户端可以通过Http请求使用特定的表示。

#### 1.2 Http方法

PUT，GET，POST，DELETE是REST中常用的Http方法。它们分别表示：
1\. GET 定义resource的读取。没有任何的副作用，即不会改变resource。要满足幂等这个性质（自己重复运算得到的结果仍然是自己）。
2\. PUT 创建一个resource。也是幂等的。
3\. DELETE 移除一个resource。幂等，可以执行多次而不会产生不同的结果。
4\. POST 更新一个已经存在的resource或者创建一个新的resource。

#### 1.3 RESTful web Service

RESTful web Service是使用REST的基本概念及Http的方法实现的。一个典型的RESTful web Service定义了服务的基本的resource，支持的MIME Type（XML，JSON，用户自定义等），及支持的操作集合（GET，POST，PUT，DELETE）。

### 2.JAX-RS

#### 2.1 JAX-RS

Java通过JSR 311提供了REST支持。全名是The Java API for RESTful Web Service）。JAX-RS使用朱姐来定义REST相关的Java类。

#### 2.2 JAX-RS的参考实现Jersey

Jersey是JAX-RS的参考实现。在Java Servlet容器中实现RESTful web Service。在服务端，Jersey提供了一个Servlet实现用来扫描可识别的resource。需要在web.xml中进行配置，即对这个Servlet进行注册和配置。
Jersey也提供了一个客户端程序用于与服务端的交互。
这个Servlet的基本的URL是
[java]
http://your_domain:port/display-name/url-pattern/path_from_rest_class 
[/java]
这个Servlet分析Http请求，并选择正确的类和方法来响应请求。这些选择是基于每个提供resource的类的注解。
一个REST web Service包括数据类（resource）和服务。这两种类型要在不同的包中进行维护，这样可以方便Jersey的Servlet进行查找特定的数据类。
JAX-RS支持使用Java Architecture for XML Binding（[JAXB教程](http://www.vogella.com/tutorials/JAXB/article.html）创建XML，JSON。

#### 2.3 JRX-RS注解

@PATH(your_path) 将访问路径设置为基本的URL+/your_path。基本路径取决于web.xml中配置的应用名称，Servlet的URL。 
@POST 指示下面的方法将响应http POST请求。
@GET  指示下面的方法将响应http GET请求。
@PUT  指示下面的方法将响应http PUT请求。
@DELETE  指示下面的方法将响应http DELETE请求。
@Produces(MediaType.TEXT_PLAIN[, more-types])  @Produces 定义被注解为@GET的方法将要使用的MIME Type。d
@Consumes(type[, more-types])  @Consumes 定义这个方法将消费什么样的MIME Type。
@PathParam  用于从URL中提取参数并注入为方法的参数。

### 3.Jersey

在[http://jersey.java.net/](http://jersey.java.net/)下载Jersey。

### 4.创建一个REST示例服务

在Eclipse中创建Dynamic Web Project。将下载的jars放入WEB-INF/lib目录下。

创建下面的Java类
``` java
package de.vogella.jersey.first;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
// Plain old Java Object it does not extend as class or implements 
// an interface
// The class registers its methods for the HTTP GET request using the @GET annotation. 
// Using the @Produces annotation, it defines that it can deliver several MIME types,
// text, XML and HTML. 
// The browser requests per default the HTML MIME type.
//Sets the path to base URL + /hello
@Path(&quot;/hello&quot;)
public class Hello {
  // This method is called if TEXT_PLAIN is request
  @GET
  @Produces(MediaType.TEXT_PLAIN)
  public String sayPlainTextHello() {
    return &quot;Hello Jersey&quot;;
  }
  // This method is called if XML is request
  @GET
  @Produces(MediaType.TEXT_XML)
  public String sayXMLHello() {
    return &quot;&lt;?xml version=\&quot;1.0\&quot;?&gt;&quot; + &quot;&lt;hello&gt; Hello Jersey&quot; + &quot;&lt;/hello&gt;&quot;;
  }
  // This method is called if HTML is request
  @GET
  @Produces(MediaType.TEXT_HTML)
  public String sayHtmlHello() {
    return &quot;&lt;html&gt; &quot; + &quot;&lt;title&gt;&quot; + &quot;Hello Jersey&quot; + &quot;&lt;/title&gt;&quot;
        + &quot;&lt;body&gt;&lt;h1&gt;&quot; + &quot;Hello Jersey&quot; + &quot;&lt;/body&gt;&lt;/h1&gt;&quot; + &quot;&lt;/html&gt; &quot;;
  }
} 
```

在web.xml中进行配置

``` java
&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;
&lt;web-app xmlns:xsi=&quot;http://www.w3.org/2001/XMLSchema-instance&quot; xmlns=&quot;http://java.sun.com/xml/ns/javaee&quot; xmlns:web=&quot;http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd&quot; xsi:schemaLocation=&quot;http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd&quot; id=&quot;WebApp_ID&quot; version=&quot;2.5&quot;&gt;
  &lt;display-name&gt;de.vogella.jersey.first&lt;/display-name&gt;
  &lt;servlet&gt;
    &lt;servlet-name&gt;Jersey REST Service&lt;/servlet-name&gt;
    &lt;servlet-class&gt;com.sun.jersey.spi.container.servlet.ServletContainer&lt;/servlet-class&gt;
    &lt;init-param&gt;
      &lt;param-name&gt;com.sun.jersey.config.property.packages&lt;/param-name&gt;
      &lt;param-value&gt;de.vogella.jersey.first&lt;/param-value&gt;
    &lt;/init-param&gt;
    &lt;load-on-startup&gt;1&lt;/load-on-startup&gt;
  &lt;/servlet&gt;
  &lt;servlet-mapping&gt;
    &lt;servlet-name&gt;Jersey REST Service&lt;/servlet-name&gt;
    &lt;url-pattern&gt;/rest/*&lt;/url-pattern&gt;
  &lt;/servlet-mapping&gt;
&lt;/web-app&gt; 
``` 
访问网址测试： http://localhost:8080/de.vogella.jersey.first/rest/hello.
或者使用Jersey的客户端测试，当然你也可以使用Apache HttpClient。
``` java
package de.vogella.jersey.first.client;
import java.net.URI;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.UriBuilder;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;
public class Test {
  public static void main(String[] args) {
    ClientConfig config = new DefaultClientConfig();
    Client client = Client.create(config);
    WebResource service = client.resource(getBaseURI());
    // Fluent interfaces
    System.out.println(service.path(&quot;rest&quot;).path(&quot;hello&quot;).accept(MediaType.TEXT_PLAIN).get(ClientResponse.class).toString());
    // Get plain text
    System.out.println(service.path(&quot;rest&quot;).path(&quot;hello&quot;).accept(MediaType.TEXT_PLAIN).get(String.class));
    // Get XML
    System.out.println(service.path(&quot;rest&quot;).path(&quot;hello&quot;).accept(MediaType.TEXT_XML).get(String.class));
    // The HTML
    System.out.println(service.path(&quot;rest&quot;).path(&quot;hello&quot;).accept(MediaType.TEXT_HTML).get(String.class));
  }
  private static URI getBaseURI() {
    return UriBuilder.fromUri(&quot;http://localhost:8080/de.vogella.jersey.first&quot;).build();
  }
} 
```

### 5.RESTful Web Service与JAXB

#### 5.1创建项目

新建项目方法如上。

``` java
package de.vogella.jersey.jaxb.model;
import javax.xml.bind.annotation.XmlRootElement;
@XmlRootElement
// JAX-RS supports an automatic mapping from JAXB annotated class to XML and JSON
// Isn't that cool?
public class Todo {
  private String summary;
  private String description;
  public String getSummary() {
    return summary;
  }
  public void setSummary(String summary) {
    this.summary = summary;
  }
  public String getDescription() {
    return description;
  }
  public void setDescription(String description) {
    this.description = description;
  }
} 
```

``` java
package de.vogella.jersey.jaxb;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import de.vogella.jersey.jaxb.model.Todo;
@Path(&quot;/todo&quot;)
public class TodoResource {
  // This method is called if XMLis request
  @GET
  @Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
  public Todo getXML() {
    Todo todo = new Todo();
    todo.setSummary(&quot;This is my first todo&quot;);
    todo.setDescription(&quot;This is my first todo&quot;);
    return todo;
  }
  // This can be used to test the integration with the browser
  @GET
  @Produces({ MediaType.TEXT_XML })
  public Todo getHTML() {
    Todo todo = new Todo();
    todo.setSummary(&quot;This is my first todo&quot;);
    todo.setDescription(&quot;This is my first todo&quot;);
    return todo;
  }
} 
```

``` java
&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;
&lt;web-app xmlns:xsi=&quot;http://www.w3.org/2001/XMLSchema-instance&quot;
  xmlns=&quot;http://java.sun.com/xml/ns/javaee&quot; xmlns:web=&quot;http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd&quot;
  xsi:schemaLocation=&quot;http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd&quot;
  id=&quot;WebApp_ID&quot; version=&quot;2.5&quot;&gt;
  &lt;display-name&gt;de.vogella.jersey.jaxb&lt;/display-name&gt;
  &lt;servlet&gt;
    &lt;servlet-name&gt;Jersey REST Service&lt;/servlet-name&gt;
    &lt;servlet-class&gt;com.sun.jersey.spi.container.servlet.ServletContainer&lt;/servlet-class&gt;
    &lt;init-param&gt;
      &lt;param-name&gt;com.sun.jersey.config.property.packages&lt;/param-name&gt;
      &lt;param-value&gt;de.vogella.jersey.jaxb&lt;/param-value&gt;
    &lt;/init-param&gt;
    &lt;load-on-startup&gt;1&lt;/load-on-startup&gt;
  &lt;/servlet&gt;
  &lt;servlet-mapping&gt;
    &lt;servlet-name&gt;Jersey REST Service&lt;/servlet-name&gt;
    &lt;url-pattern&gt;/rest/*&lt;/url-pattern&gt;
  &lt;/servlet-mapping&gt;
&lt;/web-app&gt; 
```
访问网址：http://localhost:8080/de.vogella.jersey.jaxb/rest/todo 
创建客户端访问
``` java
package de.vogella.jersey.jaxb.client;
import java.net.URI;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.UriBuilder;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;
public class Test {
  public static void main(String[] args) {
    ClientConfig config = new DefaultClientConfig();
    Client client = Client.create(config);
    WebResource service = client.resource(getBaseURI());
    // Get XML  System.out.println(service.path(&quot;rest&quot;).path(&quot;todo&quot;).accept(MediaType.TEXT_XML).get(String.class));
    // Get XML for application  System.out.println(service.path(&quot;rest&quot;).path(&quot;todo&quot;).accept(MediaType.APPLICATION_JSON).get(String.class));
    // Get JSON for application
 System.out.println(service.path(&quot;rest&quot;).path(&quot;todo&quot;).accept(MediaType.APPLICATION_XML).get(String.class));
  }
  private static URI getBaseURI() {
    return UriBuilder.fromUri(&quot;http://localhost:8080/de.vogella.jersey.jaxb&quot;).build();
  }
} 
```

### 6.创建CURD的RESTful web service

``` java
&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;
&lt;web-app xmlns:xsi=&quot;http://www.w3.org/2001/XMLSchema-instance&quot; xmlns=&quot;http://java.sun.com/xml/ns/javaee&quot; xmlns:web=&quot;http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd&quot; xsi:schemaLocation=&quot;http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd&quot; id=&quot;WebApp_ID&quot; version=&quot;2.5&quot;&gt;
  &lt;display-name&gt;de.vogella.jersey.todo&lt;/display-name&gt;
  &lt;servlet&gt;
    &lt;servlet-name&gt;Jersey REST Service&lt;/servlet-name&gt;
    &lt;servlet-class&gt;com.sun.jersey.spi.container.servlet.ServletContainer&lt;/servlet-class&gt;
    &lt;init-param&gt;
      &lt;param-name&gt;com.sun.jersey.config.property.packages&lt;/param-name&gt;
      &lt;param-value&gt;de.vogella.jersey.todo.resources&lt;/param-value&gt;
    &lt;/init-param&gt;
    &lt;load-on-startup&gt;1&lt;/load-on-startup&gt;
  &lt;/servlet&gt;
  &lt;servlet-mapping&gt;
    &lt;servlet-name&gt;Jersey REST Service&lt;/servlet-name&gt;
    &lt;url-pattern&gt;/rest/*&lt;/url-pattern&gt;
  &lt;/servlet-mapping&gt;
&lt;/web-app&gt; 
```
创建下面的数据模型作为数据模型及一个单体提供这个模型。
``` java
package de.vogella.jersey.todo.model;
import javax.xml.bind.annotation.XmlRootElement;
@XmlRootElement
public class Todo {
  private String id;
  private String summary;
  private String description;
  public Todo(){
  }
  public Todo (String id, String summary){
    this.id = id;
    this.summary = summary;
  }
  public String getId() {
    return id;
  }
  public void setId(String id) {
    this.id = id;
  }
  public String getSummary() {
    return summary;
  }
  public void setSummary(String summary) {
    this.summary = summary;
  }
  public String getDescription() {
    return description;
  }
  public void setDescription(String description) {
    this.description = description;
  }
} 
```

``` java
package de.vogella.jersey.todo.dao;
import java.util.HashMap;
import java.util.Map;
import de.vogella.jersey.todo.model.Todo;
public enum TodoDao {
  instance;
  private Map&lt;String, Todo&gt; contentProvider = new HashMap&lt;String, Todo&gt;();
  private TodoDao() { 
    Todo todo = new Todo(&quot;1&quot;, &quot;Learn REST&quot;);
    todo.setDescription(&quot;Read http://www.vogella.com/tutorials/REST/article.html&quot;);
    contentProvider.put(&quot;1&quot;, todo);
    todo = new Todo(&quot;2&quot;, &quot;Do something&quot;);
    todo.setDescription(&quot;Read complete http://www.vogella.com&quot;);
    contentProvider.put(&quot;2&quot;, todo); 
  }
  public Map&lt;String, Todo&gt; getModel(){
    return contentProvider;
  }
} 
```
创建一个简单地html页面POST数据到Service。
``` java
&lt;!DOCTYPE html&gt;
&lt;html&gt;
 &lt;head&gt;
  &lt;title&gt;Form to create a new resource&lt;/title&gt;
 &lt;/head&gt;
&lt;body&gt;
  &lt;form action=&quot;../de.vogella.jersey.todo/rest/todos&quot; method=&quot;POST&quot;&gt;
  &lt;label for=&quot;id&quot;&gt;ID&lt;/label&gt;
  &lt;input name=&quot;id&quot; /&gt;
  &lt;br/&gt;
  &lt;label for=&quot;summary&quot;&gt;Summary&lt;/label&gt;
  &lt;input name=&quot;summary&quot; /&gt;
  &lt;br/&gt;
  Description:
  &lt;TEXTAREA NAME=&quot;description&quot; COLS=40 ROWS=6&gt;&lt;/TEXTAREA&gt;
  &lt;br/&gt;
  &lt;input type=&quot;submit&quot; value=&quot;Submit&quot; /&gt;
  &lt;/form&gt;
&lt;/body&gt;
&lt;/html&gt; 
```
REST Service
``` java
package de.vogella.jersey.todo.resources;
import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.PUT;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Request;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.UriInfo;
import javax.xml.bind.JAXBElement;
import de.vogella.jersey.todo.dao.TodoDao;
import de.vogella.jersey.todo.model.Todo;
public class TodoResource {
  @Context
  UriInfo uriInfo;
  @Context
  Request request;
  String id;
  public TodoResource(UriInfo uriInfo, Request request, String id) {
    this.uriInfo = uriInfo;
    this.request = request;
    this.id = id;
  }
  //Application integration

  @GET
  @Produces({MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON})
  public Todo getTodo() {
    Todo todo = TodoDao.instance.getModel().get(id);
    if(todo==null)
      throw new RuntimeException(&quot;Get: Todo with &quot; + id +  &quot; not found&quot;);
    return todo;
  }
  // for the browser
  @GET
  @Produces(MediaType.TEXT_XML)
  public Todo getTodoHTML() {
    Todo todo = TodoDao.instance.getModel().get(id);
    if(todo==null)
      throw new RuntimeException(&quot;Get: Todo with &quot; + id +  &quot; not found&quot;);
    return todo;
  }
  @PUT
  @Consumes(MediaType.APPLICATION_XML)
  public Response putTodo(JAXBElement&lt;Todo&gt; todo) {
    Todo c = todo.getValue();
    return putAndGetResponse(c);
  }
  @DELETE
  public void deleteTodo() {
    Todo c = TodoDao.instance.getModel().remove(id);
    if(c==null)
      throw new RuntimeException(&quot;Delete: Todo with &quot; + id +  &quot; not found&quot;);
  }
  private Response putAndGetResponse(Todo todo) {
    Response res;
  if(TodoDao.instance.getModel().containsKey(todo.getId())) {
      res = Response.noContent().build();
    } else {
      res = Response.created(uriInfo.getAbsolutePath()).build();
    }
    TodoDao.instance.getModel().put(todo.getId(), todo);
    return res;
  }
} 
```
``` java
package de.vogella.jersey.todo.resources;
import java.io.IOException;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Request;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.UriInfo;
import de.vogella.jersey.todo.dao.TodoDao;
import de.vogella.jersey.todo.model.Todo;
// Will map the resource to the URL todos
@Path(&quot;/todos&quot;)
public class TodosResource {
  // Allows to insert contextual objects into the class, 
  // e.g. ServletContext, Request, Response, UriInfo
  @Context
  UriInfo uriInfo;
  @Context
  Request request;
  // Return the list of todos to the user in the browser
  @GET
  @Produces(MediaType.TEXT_XML)
  public List&lt;Todo&gt; getTodosBrowser() {
    List&lt;Todo&gt; todos = new ArrayList&lt;Todo&gt;();
    todos.addAll(TodoDao.instance.getModel().values());
    return todos; 
  }
  // Return the list of todos for applications
  @GET
  @Produces({MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON})
  public List&lt;Todo&gt; getTodos() {
    List&lt;Todo&gt; todos = new ArrayList&lt;Todo&gt;();
    todos.addAll(TodoDao.instance.getModel().values());
    return todos; 
  }
  // retuns the number of todos
  // use http://localhost:8080/de.vogella.jersey.todo/rest/todos/count
  // to get the total number of records
  @GET
  @Path(&quot;count&quot;)
  @Produces(MediaType.TEXT_PLAIN)
  public String getCount() {
    int count = TodoDao.instance.getModel().size();
    return String.valueOf(count);
  }
  @POST
  @Produces(MediaType.TEXT_HTML)
  @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
  public void newTodo(@FormParam(&quot;id&quot;) String id,
      @FormParam(&quot;summary&quot;) String summary,
      @FormParam(&quot;description&quot;) String description,
      @Context HttpServletResponse servletResponse) throws IOException {
    Todo todo = new Todo(id,summary);
    if (description!=null){
      todo.setDescription(description);
    }
    TodoDao.instance.getModel().put(id, todo);
    servletResponse.sendRedirect(&quot;../create_todo.html&quot;);
  }
  // Defines that the next path parameter after todos is
  // treated as a parameter and passed to the TodoResources
  // Allows to type http://localhost:8080/de.vogella.jersey.todo/rest/todos/1
  // 1 will be treaded as parameter todo and passed to TodoResource
  @Path(&quot;{todo}&quot;)
  public TodoResource getTodo(@PathParam(&quot;todo&quot;) String id) {
    return new TodoResource(uriInfo, request, id);
  }
} 
```
创建客户端
运行：http://localhost:8080/de.vogella.jersey.todo/rest/todos
``` java
package de.vogella.jersey.todo.client;
import java.net.URI;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.UriBuilder;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;
import com.sun.jersey.api.representation.Form;
import de.vogella.jersey.todo.model.Todo;
public class Tester {
  public static void main(String[] args) {
    ClientConfig config = new DefaultClientConfig();
    Client client = Client.create(config);
    WebResource service = client.resource(getBaseURI());
    // create one todo
    Todo todo = new Todo(&quot;3&quot;, &quot;Blabla&quot;);
    ClientResponse response = service.path(&quot;rest&quot;).path(&quot;todos&quot;)
      .path(todo.getId()).accept(MediaType.APPLICATION_XML)
        .put(ClientResponse.class, todo);
    // Return code should be 201 == created resource
    System.out.println(response.getStatus());
    // Get the Todos
    System.out.println(service.path(&quot;rest&quot;).path(&quot;todos&quot;)
        .accept(MediaType.TEXT_XML).get(String.class));
    // Get JSON for application
    System.out.println(service.path(&quot;rest&quot;).path(&quot;todos&quot;)
.accept(MediaType.APPLICATION_JSON).get(String.class));
    // Get XML for application
    System.out.println(service.path(&quot;rest&quot;).path(&quot;todos&quot;)
     .accept(MediaType.APPLICATION_XML).get(String.class));
    // Get the Todo with id 1
    System.out.println(service.path(&quot;rest&quot;).path(&quot;todos/1&quot;)
     .accept(MediaType.APPLICATION_XML).get(String.class));
    // get Todo with id 1
    service.path(&quot;rest&quot;).path(&quot;todos/1&quot;).delete();
    // Get the all todos, id 1 should be deleted
    System.out.println(service.path(&quot;rest&quot;).path(&quot;todos&quot;)
    .accept(MediaType.APPLICATION_XML).get(String.class));
    // create a Todo
    Form form = new Form();
    form.add(&quot;id&quot;, &quot;4&quot;);
    form.add(&quot;summary&quot;, &quot;Demonstration of the client lib for forms&quot;);
    response = service.path(&quot;rest&quot;).path(&quot;todos&quot;)
        .type(MediaType.APPLICATION_FORM_URLENCODED)
        .post(ClientResponse.class, form);
    System.out.println(&quot;Form response &quot; + response.getEntity(String.class));
    // Get the all todos, id 4 should be created
    System.out.println(service.path(&quot;rest&quot;).path(&quot;todos&quot;)
     .accept(MediaType.APPLICATION_XML).get(String.class));
  }
  private static URI getBaseURI() {
    return UriBuilder.fromUri(&quot;http://localhost:8080/de.vogella.jersey.todo&quot;).build();
  }
} 
```