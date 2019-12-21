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

#### 三、使用declare或typeset命令为变量声明类型
```bash
$ declare -r str="sda"               # 声明str变量为只读
$ declare -i num=22                  # 声明num变量为整型数字
$ declare -a array=("sad" "ada")     # 声明数组变量array（注意：元素以空格分隔）
$ declare -x MAVEN_HOME=/home/maven  # 声明MAVEN_HOME变量为环境变量
$ declare -f                         # 显示此脚本前定义过的所有函数以及内容
$ declare -F                         # 仅显示此脚本前定义过的函数名
```

#### 四、字符串处理（长度/截取），[简单的字符串测试脚本](https://github.com/firechiang/linux-test/tree/master/sh/str_example.sh)
```bash
$ echo ${#str}                       # 获取字符串变量 str 的长度
$ expr length "$str"                 # 获取字符串变量 str 的长度
$ expr index "$str" "a"              # 获取字符a在字符串变量str里面的位置（注意：这个只能查找单个字符）
$ expr match "$str" '.*144'          # 获取正则表达式 '.*144' 所匹配到的字符在字符串变量str里所占的长度
$ echo ${str:1}                      # 截取字符串变量str，从第1个位置开始截一直截到最后（注意：字符串从0开始计算）
$ echo ${str:1:2}                    # 截取字符串变量str，从第1个位置开始，截到第2个位置（注意：字符串从0开始计算）
$ echo ${str:-1}                     # 截取字符串变量str，从第1个位置开始，截到第2个位置（注意：字符串从0开始计算）
$ echo ${str: -3}                    # 截取字符串变量str，从右边开始截，截取3位（注意：-3和冒号之间是有空格的）
$ expr substr $str 1 2               # 截取字符串变量str，从第1个位置开始，截到第2个位置（注意：字符串从1开始计算）
```

#### 其它、动态命令以及一些高级用法
```bash
$ echo `hostname`
$ echo $(hostname)
$ echo $(date +%Y)                    # 获取当前年
$ echo `cat aaa.sh | cut -d "#" -f 1` # 使用#号分割，取分割后第一个位置的数据（-d指定分隔符，-f指定获取位置）
$ echo $(cat aaa.sh | cut -d "#" -f 1)# 使用#号分割，取分割后第一个位置的数据（-d指定分隔符，-f指定获取位置）
$ ps -ef | grep crypto | wc -l        # 获取crypto进程的条数（注意：wc -l 就是统计数据的条数）
$ echo ${array[@]}                    # 获取数组变量array里面的所有元素
$ echo ${array[0]}                    # 获取数组变量array里面的第0个元素
$ ${#array[@]}                        # 获取数组array的长度
```