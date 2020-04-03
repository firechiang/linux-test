#### 脚本里面第一行写（#! /bin/bash）的意思是：在当前 bash 下启动一个子 bash 执行脚本里面的命令，[第一个测试脚本](https://github.com/firechiang/linux-test/tree/master/sh/bash-test.sh)
#### 一、变量高级赋值
```bash
var=${str-expr}                           # str没有声明就表示：var=expr；str已声明但没有值就表示：var=；str已声明且有值就表示：var=$str
var=${str:-expr}                          # str没有声明就表示：var=expr；str已声明但没有值就表示：var=expr；str已声明且有值就表示：var=$str
var=${str+expr}                           # str没有声明就表示：var=；str已声明但没有值就表示：var=expr；str已声明且有值就表示：var=expr
var=${str:+expr}                          # str没有声明就表示：var=；str已声明但没有值就表示：var=；str已声明且有值就表示：var=expr
var=${str=expr}                           # str没有声明就表示：var=expr；str已声明但没有值就表示：var=；str已声明且有值就表示：var=$str
var=${str:=expr}                          # str没有声明就表示：var=expr；str已声明但没有值就表示：var=expr；str已声明且有值就表示：var=$str

$ aaa=(1 2 3)                             # 定义数组变量
$ echo $aaa                               # 打印 aaa 变量的值
$ echo ${aaa[0]}                          # 打印数组第0个位置的值
$ echo ${aaa[*]}                          # 打印数组里面的所有元素
$ echo ${aaa[@]}                          # 打印数组里面所有元素
```

#### 二、变量值替换（替换变量里面某一段的值和删除，相当于JAVA里面的replace和replaceAll函数）
```bash
${变量名#匹配规则}                           # 从变量开头进行匹配，将符合最短的数据删除
${变量名##匹配规则}                          # 从变量开头进行匹配，将符合最长的数据删除

${变量名%匹配规则}                           # 从变量尾部开始匹配，将符合最短的数据删除
${变量名%%匹配规则}                          # 从变量尾部开始匹配，将符合最长的数据删除

${变量名/旧字符串/新字符串}                   # 替换第一个匹配的数据
${变量名//旧字符串/新字符串}                  # 替换所有匹配的数据
----------------------------------------------------------------------

$ vara="1_ab_123_ab_1"                    # 变量的值  ：1_ab_123_ab_1
$ var1=${vara#*ab} && echo $var1          # 打印的结果：_123_ab_1
$ var1=${vara##*ab} && echo $var1         # 打印的结果：_1
$ var1=${vara%ab*} && echo $var1          # 打印的结果：1_ab_123_
$ var1=${vara%%ab*} && echo $var1         # 打印的结果：1_
$ var1=${vara/ab/xx} && echo $var1        # 打印的结果：1_xx_123_ab_1
$ var1=${vara//ab/xx} && echo $var1       # 打印的结果：1_xx_123_xx_1
```

#### 三、使用declare或typeset命令为变量声明类型
```bash
$ declare -r str="sda"                    # 声明str变量为只读
$ declare -i num=22                       # 声明num变量为整型数字
$ declare -a array=("sad" "ada")          # 声明数组变量array（注意：元素以空格分隔）
$ declare -x MAVEN_HOME=/home/maven       # 声明MAVEN_HOME变量为环境变量
$ declare -f                              # 显示此脚本前定义过的所有函数以及内容
$ declare -F                              # 仅显示此脚本前定义过的函数名
```

#### 四、字符串处理（长度/截取），[简单的字符串测试脚本](https://github.com/firechiang/linux-test/tree/master/sh/str_example.sh)
```bash
$ echo ${#str}                            # 获取字符串变量 str 的长度
$ expr length "$str"                      # 获取字符串变量 str 的长度
$ expr index "$str" "a"                   # 获取字符a在字符串变量str里面的位置（注意：这个只能查找单个字符）
$ expr match "$str" '.*144'               # 获取正则表达式 '.*144' 所匹配到的字符在字符串变量str里所占的长度
$ echo ${str:1}                           # 截取字符串变量str，从第1个位置开始截一直截到最后（注意：字符串从0开始计算）
$ echo ${str:1:2}                         # 截取字符串变量str，从第1个位置开始，截到第2个位置（注意：字符串从0开始计算）
$ echo ${str:-1}                          # 截取字符串变量str，从第1个位置开始，截到第2个位置（注意：字符串从0开始计算）
$ echo ${str: -3}                         # 截取字符串变量str，从右边开始截，截取3位（注意：-3和冒号之间是有空格的）
$ expr substr $str 1 2                    # 截取字符串变量str，从第1个位置开始，截到第2个位置（注意：字符串从1开始计算）
```

#### 五、使用expr关键字，对变量的运算、比较，简单使用（注意：运算只能针对整型数值，不能精确到浮点数），[expr关键字使用的测试脚本，里面包含整数的判断以及for循环的使用](https://github.com/firechiang/linux-test/tree/master/sh/sum_example.sh)
```bash
$ num1=1                                  # 定义变量（注意：等号两边不能有空格）
$ num2=2                                  # 定义变量（注意：等号两边不能有空格）

$ expr $num1 \% $num2                     # num1与num2求余（注意：\（反斜杠） 表示转义）
$ expr $num1 \* $num2                     # num1与num2相乘（注意：\（反斜杠） 表示转义）
$ expr $num1 / $num2                      # num1与num2相除
$ expr $num1 \> $num2                     # 比较num1是否大于num2（注意：如果比较为真直接返回 1，为假 返回 0但不会输出。 \（反斜杠） 表示转义） 
$ expr $num1 + $num2                      # 两个变量相加（注意：加号两边必须有空格）
$ expr $num1 - $num2                      # 两个变量相减（注意：减号两边必须有空格）
$ expr $num1 \| $num2                     # num1为空或是0，则返回num2，否则返回 num1（注意： \（反斜杠） 表示转义）
$ expr $num1 \& $num2                     # num1不为空，且不为0，则返回num1，否则返回 0（注意： \（反斜杠） 表示转义）
$ expr $num1 != $num2                     # num1是否不等于num2（注意：如果比较为真直接返回 1，为假 返回 0但不会输出。 \（反斜杠） 表示转义）

$ num3=`expr $num1 + $num2`               # 将num1与num2相加后，赋予num3变量 （注意：等号两边不能有空格，加号两边必须有空格）
$ num3=$(($num1+$num2))                   # 将num1与num2相加后，赋予num3变量

# 以上命令的简写（注意：简写的不需要加  \（反斜杠））
$ echo $(($num1 < $num2))                 # expr关键字的简写（注意：简写的不需要加  \（反斜杠））
$ num4=$(($num1 * $num2))                 # 将num1乘以num2的结果，赋予num4
$ num5=$(($num7 == $num8))                # 将判断$num7是否等于$num8的结果赋予num5（注意：简写的方式，判断相等要用2个等号）
```

#### 六、浮点数运算简单使用（注意：浮点数运算需要借助 bc 计算器），[bc浮点数运算的测试脚本](https://github.com/firechiang/linux-test/tree/master/sh/bc_example.sh)
```bash
$ yum install bc -y                       # 如果没有，安装 bc 计算器
$ bc                                      # 进入 bc 计算器（如果有直接写 "计算表达式" 即可运算）
$ 2 + 3                                   # 计算2+3，敲回车即可运算
$ scale=6                                 # 设置小数点精度（注意：等号两边不要加空格） 
$ 5 / 3                                   # 计算5/3
$ quit                                    # 退出bc计算器

$ echo "2+3" | bc                         # 将计算表达传给 bc 进行运算
$ echo "scale=4;3/5" | bc                 # 计算3/5（注意：scale 是指定小数点精度）
```

#### 七、函数定义和简单使用（注意：在函数里面定义变量建议使用local关键字修饰为局部变量（就是加 local 的变量只能在当前函数使用，没有加的默认是全局的，在当前 bash 里面可用））
 - [函数使用return返回值，只能返回0-255的整数（建议使用返回0调用成功，1调用失败），使用return返回值的简单测试脚本](https://github.com/firechiang/linux-test/tree/master/sh/function_example_2.sh)
 - [函数返回String类型的数据，简单测试脚本，里面有for in的用法和获取函数返回值的用法](https://github.com/firechiang/linux-test/tree/master/sh/function_example_3.sh)
 - [函数的测试脚本，里面有获取当前脚本执行的子进程ID](https://github.com/firechiang/linux-test/tree/master/sh/function_example.sh)
 - [函数接收参数简单测试脚本，里面有swith case简单使用](https://github.com/firechiang/linux-test/tree/master/sh/function_example_1.sh)
 - [函数库测试脚本（就是以依赖的方式供其它脚本调用，文件后缀名建议使用.lib，还有不要给执行权限）](https://github.com/firechiang/linux-test/tree/master/sh/base_function.lib)
 - [调用函数库的测试脚本（就是调用外部脚本里面的函数）](https://github.com/firechiang/linux-test/tree/master/sh/function_example_4.sh)
 - [打印系统运行参数的测试脚本（内存，磁盘 等信息）](https://github.com/firechiang/linux-test/tree/master/sh/function_example_5.sh)
 - [脚本执行时获取参数简单使用](https://github.com/firechiang/linux-test/tree/master/sh/param-test.sh)
```bash
test()
{
    AAA="a"
    local BBB="212"
    echo $AAA
    echo $BBB
    # 获取参数的个数
    echo $#        
    # 获取参数列表                         
    echo $*      
    # 获取参数列表                           
    echo $@
    # 获取第一个位置的参数（注意：$2就是获取第2个位置的参数）
    echo $1                          
}

test_echo()
{
    # 定义局部变量（注意：没有加local的所有变量都是全局变量，全局变量：既使是在函数外面也是可以使用的）
    local temp="test"
    # 可使用 $1,$2 的方式获取参数
    echo "第一种定义函数的方法"
}

function test_echo
{
    # 定义局部变量（注意：没有加local的所有变量都是全局变量，全局变量：既使是在函数外面也是可以使用的）
    local temp="test"
    # 可使用 $1,$2 的方式获取参数
    echo "第二种定义函数的方法"
}

$ test_echo "参数1" "参数2"           # 调用函数
```

#### 八、文本流重定向简单使用
```bash
# 输出文本流重定向
$ ls 1>> aaa                              # 将 ls 命令的结果，输出到 aaa 文件，1代表ls命令正常输出的数据，可以不写默认就是1（不会覆盖文件原有内容）  
$ ls 1> aaa                               # 将 ls 命令的结果，输出到 aaa 文件，1代表ls命令正常输出的数据，可以不写默认就是1（会覆盖文件所有内容）   
$ ls /wqwq 2>> bbb                        # 将 ls 命令的错误信息输出到 bbb 文件，2代表ls命令错误信息数据（不会覆盖文件原有内容）
$ ls / /lsdsd 1>> aaa  2>> bbb            # 将 / 的正常结果放到 aaa 文件，将 /lsdsd 错误信息放到 bbb 文件
$ ls / /dsdsd 1>>test.log 2>&1            # 将 / 的正常结果输出到 test.log 文件，将 /dsdsd 的错误信息输出到 1，而 1 又指向 test.log 文件，所以最后信息都会输出到test.log（&说明是文本流）
$ ls / /asds >& test.log2                 # 将命令 ls / /asds 的结果信息和错误信息都输出到 test.log2 文件（&说明是文本流，注意：这种写法只能覆盖文件，不能追加）
$ ls / /sdsdsd &>> test.log3              # 将命令 ls / /sdsdsd 的结果信息和错误信息都输出到 test.log3 文件（&说明是文本流，注意：这种写法可覆盖文件数据，也可追加数据）

# 输入文本流重定向
$ read aaa <<< "sadasda";                 # 在内存当中定义变量 aaa 值等于："sadasda"
$ echo $aaa                               # 查看内存当中 aaa 的值
$ cat << AAA                              # 执行该命令，然后输入数据，最后以 AAA 结束，最后的效果就是会输出 两个 AAA 之间的数据

# 文本流重定向示例
cd /proc/$$/fd                            # 定位到当前 bash 进程下
exec 8<> /dev/tcp/docs.r9it.com/80        # 创建一个网络输入输出流指向文件8
echo "GET -e /manual/java HTTP/1.0\n" 1>&8# 将信息 "GET -e /manual/java HTTP/1.0\n" 写入文件8，它会自动发起请求，返回的结果会写在文件8里面
cat 0>&8                                  # 定义文本流0，将文本流8里面的数据读取出来，放到0里面来，然后再显示出来
```

#### 九、export 使用（注意：在命令行，子 bash 会直接继承父 bash 的变量，但是在脚本文件里面想要获取父 bash 的变量值，需要在父 bash 里面 export 变量以后，才可获取到）
```bash
$ a=1212
$ echo $a
$ ecport a                                # 导出变量a（导出以后，在脚本文件里面就可以获取到变量a的值了了）
```

#### 十、引用和命令替换使用（单引号：弱引用，不可嵌套；双引号：强引用，参数扩展）
```bash
$ a=jiang
$ echo "$a"                               # 它会打印 jiang（双引号里面的会直接被当成命令来执行，但是不能包含花括号（就是{}））
$ echo '$a'                               # 它会打印 $a（单引号说明是字符串） 

$ echo "echo "jiang""                     # 它会打印  echo jiang
$ echo "`echo "jiang"`"                   # 它会打印  jiang（因为：bash 看到 ` 号，包起来的数据，会当成命令来预先执行，然后将结果推送回来，这个可以理解为命令替换）

$ a=$(ls /)                               # 定义变量，这个变量的值是命令
$ echo $a                                 # 先执行变量命令，然后再将结果推送回来，在打印出来
```

#### 十一、grep 和 egrep 过滤器简单使用
```bash
# 使用方法一：grep [option] [pattern] [file1,file2,..]
# 使用方法二：命令 | grep [option] [pattern] 
# option 包含以下值（注意：option 为可选参数）
# -v 不显示匹配行的信息（就是不高亮显示匹配信息）
# -i 搜索时忽略大小写
# -n 显示行号
# -r 递归搜索（当前目录下搜索所有文件）
# -E 支持扩展正则表达式
# -F 不按正则表达式匹配，按照字符串字面意思匹配
# -c 只显示匹配行的数量，不显示具体信息
# -w 匹配整词
# -x 匹配整行
# -l 只显示匹配的文件名，不显示具体匹配行的内容
$ grep -n 90 aaa                          # 查找 aaa 文件里面包含 90 的数据，并显示数据所在行号
$ grep -E "a | A" aaa                     # 查找 aaa 文件里面包含 a 或  A 的数据（因为 a | A 是扩展正则表达式，所以加了-E参数，也可以直接使用egrep）
$ grep -F "a.*" aaa                       # 查找 aaa 文件里面包含 a.* 的数据（因为 a.* 是正则表达式，但是我们要以字面意思匹配，所以加了-F 参数）
$ grep -r 90                              # 在当前目录下搜索所有文件，查找里面包含90的数据（注意：这个搜索结果里面会显示文件名）
$ netstat -ntlp | grep 25                 # 查询netstat -ntlp命令结果数据包含25的数据
```

#### 十二、[sed 文件流编辑器简单使用（修改删除文件里面的数据）](https://github.com/firechiang/linux-test/tree/master/docs/sed-simple-use.md)

#### 十三、[awk 文本处理工具以及报告生成器简单使用](https://github.com/firechiang/linux-test/tree/master/docs/awk-simple-use.md)
