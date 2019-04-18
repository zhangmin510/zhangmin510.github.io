title: ' Largest Number'
tags:
  - 数据结构与算法
  - ''
categories:
  - 数据结构与算法
  - ''
author: ZhangMin.name
date: 2019-04-16 18:45:00
---
# 179. Largest Number

求输入非负数数组能够组成的最大数，返回的是个字符串。


## 官方求解思路

如果一个数是最大的数， 那么这个数的高位应该是数组中的最大值的元素。

这样，这道题的解题思路就是将输入的非负整数转化成字符串数组，然后按降序顺序排序。

但是有个问题，如果输入的非负整数数组中有`3`和`30`, 就会导致排序后的组成的数不是最大的数，如`9534303`，因为更大的数是`9534330`。

为了解决这个问题，需要在比较数组中的两个字符串时，将这两个字符串的两种连接方式组成的字符串来进行排序，如对于`3`和`30`, 比较的是`330`和`303`, 最后的顺序应该是`330`。


另外还需要处理边界条件，即最高位为0的情况，以及输入数组为null或者大小为0的情况。

## 代码实现如下


```
class Solution {
    public String largestNumber(int[] nums) {
        if (nums == null || nums.length == 0) {
            return "0";
        }

        int len = nums.length;
        String[] numsStr = new String[len];
        for (int i = 0; i < len; i++) {
            numsStr[i] = Integer.toString(nums[i]);
        }

        Arrays.sort(numsStr, new Comparator<String>() {
            @Override
            public int compare(String o1, String o2) {
                String s1 = o1 + o2;
                String s2 = o2 + o1;
                return s2.compareTo(s1);
            }
        });

        if (numsStr[0].equals("0")) {
            return "0";
        }

        StringBuilder sb = new StringBuilder();
        for (String s : numsStr) {
            sb.append(s);
        }
        return sb.toString();
    }
}
```


# 参考资料
1. https://leetcode.com/problems/largest-number/