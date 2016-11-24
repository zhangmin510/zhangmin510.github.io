title: nodejs菜鸟需跨过的坎
date: 2015-12-02 13:57:10
categories:
- nodejs
tags:
- nodejs
---
### 作用域
javascript的作用域是函数作用域，不是以大括号为起始的块级作用域。在一个函数中定义的变量只在这个函数的内部可见。在函数中引用变量时，会一级一级去搜索变量，直到全局作用域。

在访问未定义的变量或者未初始化的变量获得的值是undefined。

    var scope = 'global'
	    var f = function() {
			        console.log(scope) // undefined
						        var scope = 'f'
								    }
    f();

	javascript 的作用域是静态作用域，即在定义时决定的，而不是在调用时决定的。

	    var scope = 'top'
		    var f1 = function() {
				        console.log(scope) // global
							    }
    var f2 = function() {
		        scope = 'f2';
				        f1();
						    }
    f2(); //top

	全局作用域的变量在任何地方都可以直接引用。全局变量满足一下三点：

	* 在最外层定义的变量
	* 全局对象global的属性
	* 未定义直接赋值的变量

	不通过var声明的就是属于上面的第三种全局变量。通过var声明的是局部变量。


### 闭包

	闭包是由函数（环境）以及其封闭的自由变量组成的集合体。当一个函数返回一个它内部定义的函数时，就产生了一个闭包，闭包不但包含返回的参数，还包括这个函数的定义环境。

	    var genClosure = function() {
			        var count = 0;
					        var get = function() {
								            count++;
											            return count;
														        }
							        return get;
									    }
    var c1 = genClosure();
	    var c2 = genClosure();
		    console.log(c1());//1
			    console.log(c2());//1
				    console.log(c1());//2
					    console.log(c2());//2

						genClosure 返回get函数时，将get可能引用到的变量也返回了，并在内存中生成了一个副本。c1和c2就是相互独立的了。

						闭包主要有两个用途：

						* 实现嵌套回调函数。
						* 隐藏对象的细节。

### 上下文对象this
						this表示被调用函数所处的环境。this的作用就是在一个函数内部引用调用它的对象本身。Javascript任何函数都是某个对象调用的，包括全局对象。
						函数类型的变量是指向函数实体的一个引用,引用之间的赋值不会复制整个对象。this指针永远是这个引用所属的对象。

						    var someuse = {
								       name: 'javascript',
											        func: function() {
														          console.log(this.name);
																         }
											     }
    var foo = {
		        name = 'foo'
					    }
    someuser.func();// javascript
	    foo.func = someuser.func;
		    foo.func();//foo
			    name = 'global'
				    func = someuser.func;
					    func();//global


#### call和apply
						这两个函数的作用就是以不同的对象作为上下文来调用某个函数。简而言之，就是允许一个对象去掉用另外一个对象的成员函数。
						call与apply的差别就是call以参数表来接受调用的参数，而apply以数组来接受被调用函数的参数。

						     func.call(thisArg[, arg1[, arg2,[...]]])
	     func.apply(thisArg[, argsArray])

	func是函数的引用，thisArg是func的被调用时的上下文对象，arg1,arg2和argsArray是传入func的参数。

	    var someuse = {
			       name: 'say',
						        func: function(word) {
									          console.log(this.name + ' ' + word);
											         }
						     }
    var foo = {
		        name = 'foo'
					    }

    someuse.func.apply(foo, 'hello');// foo hello

	bind方法可以永久绑定上下文，这样其无论被谁调用，上下文都是固定的。

	    func.bind(thisArg[, arg1[, arg2[, ....]]])

	bind还可以绑定参数列表，从而省略重复的参数。

	    var someuser = {
			       name: 'i',
						        func: function(act,word) {
									          console.log(this.name + ' ' +  act + ' ' + word);
											         }
						     }
    someuser.func('love', 'you');//i love you
	    lfunc = someuser.func.bind(someuser, 'loves');
		    lfunc('her');//i love her

### 循环

			    var js
				    var hello
### 原型


### 编程风格

					* 缩进。两格，因为函数嵌套较多。
					* 行宽。最佳80。在任何设备都能方便阅读。
					* 语句分隔符。分号';'。
					* 变量定义。一行一个变量定义。
					* 变量名。小驼峰式命名。youNameIs。
					* 函数。构造函数大驼峰，一般小驼峰。
					* 引号。统一用单引号，双引号和单引号语义上一样，但是JSON和XML都规定了双引号，这样便于无歧义直接引用。
					* 关联数组初始化。var = {放在一行，下面没对键值一行。
						* 等号。尽量使用三个=而不是两个=来判断相等。==包含了隐式类型转换。
							* 命名函数。尽量给构造函数和回调函数命名，这样可以更清楚的追溯调用栈。
							回调函数的第一个参数是err，如果没有为undefined。
							* 对象定义。尽量将所所有成员函数使用原型定义，将属性在构造函数内定义，然后对构造函数使用new关键词创建对象。
							* 继承。避免复杂继承，使用util的inherits函数。

							(...待续...）
### *参考文献*

							 1.《Node.js开发开发指南》 郭家宝
