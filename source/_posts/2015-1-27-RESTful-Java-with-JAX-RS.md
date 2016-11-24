title: RESTful Java with JAX-RS Reading Note
date: 2015-1-27 10:38:51
tags:
- Java
- Web Service
categories:
- MSE

---

# REST Theory

REpresentation State Transfer(REST) principles:

* Addressable resources.The key abstraction of information and data in REST is a resource, and each resource
must be addressable via a URI (Uniform Resource Identifier).Each HTTP request
must contain the URI of the object you are requesting information from or posting
information to. 
* Uniform, constrained interface.Use a small set of well-defined methods(HTTP's method) to manipulate your resources.
* Representation-oriented.You interact with services using representations of that service. A resource referenced
by one URI can have different formats. Different platforms need different formats.
* Communicate statelessly.Stateless applications are easier to scale.
* Hypermedia As The Engine Of Application State(HATEOAS).Let your data formats drive state transitions in your applications.
Hypermedia is a document-centric approach with the added support for embedding links to other services and information within that document
format.

# Designing RESTful Service

## Object model
![Object Model](http://f.picphotos.baidu.com/album/s%3D550%3Bq%3D90%3Bc%3Dxiangce%2C100%2C100/sign=a78e60e36f224f4a5399731639cce16f/42166d224f4a20a453562a0292529822730ed0ae.jpg?referer=fc2516dfc45c10387d69faf21064&x=.jpg)
## Model the URI
In a RESTful system, endpoints are usually referred to as resources and are identified using a URI. URIs satisfy the addressability
requirements of a RESTful service.
For example:
/orders
/orders/{id}

## Define the data format
XML,JSON,YMAL etc.

``` [xml]
<product id="543">
<link rel="self" href="http://example.com/products/543"/>
<name>iPhone</name>
<cost>$199.99</cost>
</product>
```

## Assigning HTTP methods
``` [java]
GET /products HTTP/1.1

HTTP/1.1 200 OK
Content-Type: application/xml
<products>
<product id="111">
<link rel="self" href="http://example.com/products/111"/>
<name>iPhone</name>
<cost>$199.99</cost>
</product>
<product id="222">
<link rel="self" href="http://example.com/products/222"/>
<name>Macbook</name>
<cost>$1599.99</cost>
</product>
```

# First JAX-RS Service

## JAX-RS Overview and Roadmap

JAX-RS is a framework that focuses on applying Java annotations to plain Java objects:

* It has **annotations** to bind specific URI patterns and HTTP operations to individual methods of your Java class. 
* It has **parameter injection** annotations so that you can easily pull in information from the HTTP request. 
* It has **message body readers and writers** that allow you to decouple data format marshalling and unmarshalling from your Java
data objects. 
* It has **exception mappers** that can map an application-thrown exception to an HTTP response code and message. 
* Finally, it has some nice facilities for HTTP **content negotiation**.

These are also roadmap to dive into JAX-RS.

## Bean class

``` [java]
Java bean class
public class Customer {
private int id;
private String firstName;
private String lastName;
private String street;
private String city;
private String state;
private String zip;
private String country;
......
```

## Resource class
``` [java]
@Path("/customers")
public class CustomerResource {
@GET
@Path("{id}")
@Produces("application/xml")
public StreamingOutput getCustomer(@PathParam("id") int id) {
final Customer customer = customerDB.get(id);
if (customer == null) {
throw new WebApplicationException(
Response.Status.NOT_FOUND);
}
return new StreamingOutput() {
public void write(OutputStream outputStream)
throws IOException, WebApplicationException {
outputCustomer(outputStream, customer);
}
};
}
```

## Deploy resources

Using Application class for deployment configuration.

``` [java]
public abstract class Application {
private static final Set<Object> emptySet = Collections.emptySet();
//Any JAX-RS service class returned by this method will
//follow the per-request model mentioned earlier
//a list of JAX-RS service objects as the application programmer, are responsible for
//creating and initializing these objects
public abstract Set<Class<?>> getClasses();
//Any JAX-RS service class returned by this method will
//follow the singleton mode.
public Set<Object> getSingletons() {
return emptySet;
}
}
```
Extend the Application class and configure it in web.xml.

``` [java]
<?xml version="1.0"?>
<web-app>
<display-name>Archetype Created Web Application</display-name>
<servlet>
<servlet-name>Rest</servlet-name>
<servlet-class>
com.jaxrs.vendor.JaxrsVendorServlet
</servlet-class>
<init-param>
<param-name>javax.ws.rs.Application</param-name>
<param-value>
com.restfully.shop.services.ShoppingApplication
</param-value>
</init-param>
</servlet>
<servlet-mapping>
<servlet-name>Rest</servlet-name>
<url-pattern>/*</url-pattern>
</servlet-mapping>
</web-app>
```
