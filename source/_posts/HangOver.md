title: HangOver
id: 418
categories:
  - 分享
date: 2011-07-09 16:50:36
tags:
---

[![ACM](http://files.blogcn.com/wp01/M00/01/51/wKgKCk4YFwwAAAAAAAB7wGAKY28199.png "acm-background")](http://zhangmin.name/wp-content/uploads/2011/07/wKgKCk4YFwwAAAAAAABVZF8Jg_k584.png)
Problem：http://poj.org/problem?id=1003
`#include&lt;stdio.h&gt;
/*
* ACM poj.org 1003
**/
int main(){
float length = 0.0;
scanf("%f",&amp;length);
while(0.00 != length){
float sum = 0.0;
int n = 2;
while(1){
sum+=1.0/n;
if(length -sum &lt; 0.001){
printf("%d card(s)n",n-1);
break;
}
else
n++;
}
scanf("%f",&amp;length);
}
return 0;`
}