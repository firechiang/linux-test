#### 一、变量高级赋值
```bash
var=${str-expr}                      # str没有声明就表示：var=expr；str已声明但没有值就表示：var=；str已声明且有值就表示：var=$str
var=${str:-expr}                     # str没有声明就表示：var=expr；str已声明但没有值就表示：var=expr；str已声明且有值就表示：var=$str
var=${str+expr}                      # str没有声明就表示：var=；str已声明但没有值就表示：var=expr；str已声明且有值就表示：var=expr
var=${str:+expr}                     # str没有声明就表示：var=；str已声明但没有值就表示：var=；str已声明且有值就表示：var=expr
var=${str=expr}                      # str没有声明就表示：var=expr；str已声明但没有值就表示：var=；str已声明且有值就表示：var=$str
var=${str:=expr}                     # str没有声明就表示：var=expr；str已声明但没有值就表示：var=expr；str已声明且有值就表示：var=$str
```

#### 二、变量值替换（替换变量里面某一段的值和删除，相当于JAVA里面的replace和replaceAll函数）
```bash
${变量名#匹配规则}                    # 从变量开头进行匹配，将符合最短的数据删除
${变量名##匹配规则}                   # 从变量开头进行匹配，将符合最长的数据删除

${变量名%匹配规则}                    # 从变量尾部开始匹配，将符合最短的数据删除
${变量名%%匹配规则}                   # 从变量尾部开始匹配，将符合最长的数据删除

${变量名/旧字符串/新字符串}            # 替换第一个匹配的数据
${变量名//旧字符串/新字符串}           # 替换所有匹配的数据
----------------------------------------------------------------------

$ vara="1_ab_123_ab_1"               # 变量的值  ：1_ab_123_ab_1
$ var1=${vara#*ab} && echo $var1     # 打印的结果：_123_ab_1
$ var1=${vara##*ab} && echo $var1    # 打印的结果：_1
$ var1=${vara%ab*} && echo $var1     # 打印的结果：1_ab_123_
$ var1=${vara%%ab*} && echo $var1    # 打印的结果：1_
$ var1=${vara/ab/xx} && echo $var1   # 打印的结果：1_xx_123_ab_1
$ var1=${vara//ab/xx} && echo $var1  # 打印的结果：1_xx_123_xx_1
```
