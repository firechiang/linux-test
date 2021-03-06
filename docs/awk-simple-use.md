#### 一、awk 命令说明
```bash
# commands1=处理文本之前需要执行的命令，pattern=需要匹配的正则表达式，commands2=处理文本需要执行的命令，commands3=处理文本完成以后需要执行的命令
# 注意：可以同时操控多个文件
$ awk 'BEGIN {commands1} pattern {commands2} END {commands3}' file_name1 file_name2

# awk 的内置command（命令）
|---------|----------------------------------------------|
|print    | 打印输出                                      
|---------|----------------------------------------------|

# awk 的内置变量
|---------|----------------------------------------------|
|$0       | 整行内容                                      
|---------|----------------------------------------------|
|$1-$n    | 当前行的第1-n个字段（就是第1-n列）             
|---------|----------------------------------------------|
|NF       | 当前行的字段个数（也就是有多少个列）           
|---------|----------------------------------------------|
|NR       | 当前行的行号（从1开始记数）                   
|---------|----------------------------------------------|
|FNR      | 多文件处理时，每个文件行号单独记数，都是从1开始
|---------|----------------------------------------------|
|FS       | 输入字符串分隔符（默认使用空格或Tab键分割）        
|---------|----------------------------------------------|
|RS       | 输入行分隔符（默认回车换行）                   
|---------|----------------------------------------------|
|OFS      | 输出字段分隔符（默认空格）                     
|---------|----------------------------------------------|
|ORS      | 输出行分隔符（默认回车换行）                    
|---------|----------------------------------------------|
|FILENAME | 当前输入的文件名称                    
|---------|----------------------------------------------|
|ARGC     | 命令行参数个数          
|---------|----------------------------------------------|
|ARGV     | 命令行参数数组         
|---------|----------------------------------------------|

# printf 函数格式说明符
|---------|----------------------------------------------|
|%s       | 打印字符串                                 
|---------|----------------------------------------------|
|%d       | 打印整型数字                                
|---------|----------------------------------------------|
|%f       | 打印浮点数字                                
|---------|----------------------------------------------|
|%x       | 打印十六进制数字                                
|---------|----------------------------------------------|
|%o       | 打印八进制数字                                
|---------|----------------------------------------------|
|%e       | 打印科学计数法形式的数字                                
|---------|----------------------------------------------|
|%c       | 打印单个字符的ASCII码                                
|---------|----------------------------------------------|

# printf 函数修饰说明符
|---------|----------------------------------------------|
|-        | 左对齐                                
|---------|----------------------------------------------|
|+        | 右对齐（默认值）                                
|---------|----------------------------------------------|
|#0       | 打印8进制                          
|---------|----------------------------------------------|
|#x       | 打印16进制                              
|---------|----------------------------------------------|
```

#### 二、awk的输出函数print和printf函数简单使用
```bash
$ awk '{print $0}' aaa                   # 打印aaa文件里面每一行数据（注意：print是打印命令，$0是内置变量表示整行内容，BEGIN和END块以及pattern都省略了）
$ awk 'BEGIN {FS=","} {print $1}' aaa    # 打印aaa文件里面每一行以逗号分割后，第1个位置的数据（FS=","表示以逗号分割，$1就是取分割后第1个位置的数据，END和pattern都省略了）
$ awk 'BEGIN {FS=","} {print $2}' aaa    # 打印aaa文件里面每一行以逗号分割后，第2个位置的数据（FS=","表示以逗号分割，$2就是取分割后第2个位置的数据，END和pattern都省略了）

$ awk 'BEGIN {FS=","} {print NF}' aaa    # 打印aaa文件里面每一行以逗号分割后，段落的个数（FS=","表示以逗号分割，NF就是取分割后段落的个数，END和pattern都省略了）
$ awk '{print NR}' aaa bbb               # 打印aaa和bbb文件里面每一行的行号（注意：NR变量两个文件行号会叠加，print是打印命令，NR是内置变量表示当前行的行号，BEGIN和END块以及pattern都省略了）
$ awk '{print FNR}' aaa bbb              # 打印aaa和bbb文件里面每一行的行号（注意：FNR变量两个文件行号不会叠加，会分开打印，print是打印命令，FNR是内置变量表示当前行的行号，BEGIN和END块以及pattern都省略了）

# 使用printf格式化输出，不指定换行（输出的数据只有一行）（说明：printf("%s -- %s",$1,$2)）
$ awk 'BEGIN {FS=","} {printf "%s -- %s",$1,$2}' aaa
# 使用printf格式化输出，指定换行（输出的数据会有多行）（说明：printf("%s -- %s",$1,$2)）
$ awk 'BEGIN {FS=","} {printf "%s -- %s\n",$1,$2}' aaa
# 使用printf格式化输出，指定换行（输出的数据会有多行）（注意：20表示在前面加20个空字符，右对齐）
$ awk 'BEGIN {FS=","} {printf "%20s -- %s\n",$1,$2}' aaa
# 使用printf格式化输出，指定换行（输出的数据会有多行）（注意：20表示在前面加20个空字符，-号表示左对齐）
$ awk 'BEGIN {FS=","} {printf "%-20s %s\n",$1,$2}' aaa
# 使用printf格式化输出浮点数，并且指定换行（输出的数据会有多行）（注意：0.2表示保留小数点后2位（默认是6位））
$ awk 'BEGIN {FS=","} {printf "%0.2f %s\n",$1}' bbb

# 打印a文件里面以|号分割行，以,号分割列之后的每一行数据（FS指定字符串分隔符，RS指定行分隔符）
$ awk 'BEGIN {FS=",";RS="|"} {print $0}' a
# 打印a文件里面以|号分割行，以,号分割列之后的每一行数据。输出时使用\n进行行分割，使用-进行字符串分割
# 注意：FS=输入字符串分隔符，RS=输入行分隔符，ORS=输出行分隔符，OFS=输出字符串分隔符（就是$1和$2的分隔符））
$ awk 'BEGIN {FS=",";RS="|";ORS="\n";OFS="-"} {print $1,$2}' a

# 打印aaa文件里面，查找到包含 root 的每一行
$ awk '/root/ {print $0}' aaa
# 打印aaa文件里面，查找到以 df 开头的每一行
$ awk '/^df/ {print $0}' aaa
```

#### 三、awk逻辑判断简单使用
```bash
# 打印aaa文件里面，查找到以逗号分割后的第3个字段的值大于50的每一行
$ awk 'BEGIN {FS=","} $3 > 50 {print $0}' aaa
# 打印aaa文件里面，查找到以逗号分割后的第3个字段的值等于51的每一行
$ awk 'BEGIN {FS=","} $3 == 51 {print $0}' aaa
# 打印aaa文件里面，查找到以逗号分割后的第3个字段的值大于等于51的每一行
$ awk 'BEGIN {FS=","} $3 >= 51 {print $0}' aaa
# 打印aaa文件里面，查找到以逗号分割后的第3个字段的值不等于51的每一行
$ awk 'BEGIN {FS=","} $3 != 51 {print $0}' aaa
# 打印aaa文件里面，查找到以逗号分割后的第2个字段的值等于dfd的每一行
$ awk 'BEGIN {FS=","} $2 == "dfd" {print $0}' aaa

# 打印aaa文件里面，查找到以逗号分割后的第2个字段的值等于dfd并且第3个字段的值大于等于51的每一行
$ awk 'BEGIN {FS=","} $2 == "dfd" && $3 >= 51 {print $0}' aaa
# 打印aaa文件里面，查找到以逗号分割后的第2个字段的值等于dfd或者第3个字段的值大于等于51的每一行
$ awk 'BEGIN {FS=","} $2 == "dfd" || $3 >= 51 {print $0}' aaa
# 打印aaa文件里面，查找到以逗号分割后的第2个字段的值不等于dfd的每一行（注意：! 是取反）
$ awk 'BEGIN {FS=","} !($2 == "dfd") {print $0}' aaa
```

#### 四、awk的变量定义以及运算符简单使用
```bash
$ awk 'BEGIN {var1=20;var2="ssdfds";print var1,var2}'
# 直接打印var1,var2,var3的值（注意：如果var1没有定义，则默认就是0）
$ awk 'BEGIN {var1=20;var2=10;var3=var1+var2;print var1,var2,var3}'
# 直接打印var1,var2的值（注意：如果var1没有定义，则默认就是0）
$ awk 'BEGIN {var1=20;var2=var1+1;print var1,var2}'
# 直接打印var1,var2的值（注意：var1会等于21，var2等于20。原因：先赋值再加加（和java里面的一样））
$ awk 'BEGIN {var1=20;var2=var1++;print var1,var2}'
# 直接打印var1,var2的值（注意：var1和var2都是等于21。原因：先加加再赋值（和java里面的一样））
$ awk 'BEGIN {var1=20;var2=++var1;print var1,var2}'
# 直接打印var1,var2的值（注意：var1会等于19，var2等于20。原因：先赋值再减减（和java里面的一样））
$ awk 'BEGIN {var1=20;var2=var1--;print var1,var2}'
# 直接打印 var1除以var2，保留2位小数，之后换行
$ awk 'BEGIN {var1=20;var2=10;printf "%0.2f\n",var1 / var2}'
# 直接打印 var1乘以var2，保留2位小数，之后换行
$ awk 'BEGIN {var1=20;var2=10;printf "%0.2f\n",var1 * var2}'
# 直接打印 var1的var2次方（10和个20相乘），保留2位小数，之后换行
$ awk 'BEGIN {var1=20;var2=10;printf "%0.2f\n",var1 ** var2}'
# 直接打印 var1的var2次方（10和个20相乘），保留2位小数，之后换行
$ awk 'BEGIN {var1=20;var2=10;printf "%0.2f\n",var1 ^ var2}'
```

#### 五、awk匹配查找简单使用
```bash
# 打印aaa文件里面，查找到以逗号分割后的第3个字段的值是0-9且出现次数大于等于2的每一行
# 注意：~ 后跟着的是正则表达式（用这个正则表达式去匹配前面的值）
$ awk 'BEGIN {FS=","} $3~/[0-9]{2,}/ {print $0}' aaa 
# 打印aaa文件里面，查找到以逗号分割后的第3个字段的值不是（0-9且出现次数大于等于2）的每一行
# 注意：!~ 是取反的意思（就是要不能匹配到正则表达式的数据）
$ awk 'BEGIN {FS=","} $3!~/[0-9]{2,}/ {print $0}' aaa 
# 打印aaa文件里面，查找到以逗号分割后的第3个字段的值是0-9且出现次数大于等于2或者第3个字段的值是dfd的每一行
$ awk 'BEGIN {FS=","} $3~/[0-9]{2,}/ || $2 == "dfd" {print $0}' aaa 


# 统计aaa文件里面包含33的行数（统计开始count=0，每匹配到一行count就是加加，最后打印count）
$ awk 'BEGIN {count=0} /33/ {count++} END {print count}' aaa
# 统计aaa文件里面以逗号分割后，后3个字段的平均值，最后保留4个小数打印出来
$ awk 'BEGIN {FS=","} {total=$2+$3+$4;avg=total/4;printf "%0.4f\n",avg}' aaa
# 统计aaa文件里面以逗号分割后，后3个字段的平均值，最后将3个字段和保留4个小数的平均值打印出来
$ awk 'BEGIN {FS=","} {total=$2+$3+$4;avg=total/4;printf "%d,%d,%d,平均值: %0.4f\n",$2,$3,$4,avg}' aaa
# 统计aaa文件里面以逗号分割后，后3个字段的平均值，最后将3个字段和保留4个小数的平均值打印出来
$ awk 'BEGIN {FS=",";printf "%s,%s,%s,%s\n","语文","数学","英语","平均分"} {total=$2+$3+$4;avg=total/4;printf "%d,%d,%d,%0.4f\n",$2,$3,$4,avg}' aaa
```

#### 六、awk条件以及循环语句简单使用（复杂的awk命令或脚本建议写在一个awk脚本文件里面）
 - 条件语句的使用
```bash
# 打印aaa文件里面，每行以逗号分割后的第2个字段的值大于50并且小于100的所有行
$ awk 'BEGIN {FS=","} {if($2>50 && $2<100) print $0}' aaa
# 打印aaa文件里面，每行以逗号分割后的第2个字段的值大于50或者小于100的所有行
$ awk 'BEGIN {FS=","} {if($2>50 || $2<100) {print $0}}' aaa
# 打印aaa文件里面，每行以逗号分割后的第2个字段的值大于50就打印"大于"，小于50就打印"小于"
$ awk 'BEGIN {FS=","} {if($2>50) {print "大于"} else {print "小于"}}' aaa
# 打印aaa文件里面，每行以逗号分割后的第2个字段的值，打印小于50，大于100，50-100之间
$ awk 'BEGIN {FS=","} {if($2 < 50) {print "小于50"} else if($2 > 100) {print "大于100"} else {print "50-100之间"}}' aaa
# do while循环简单使用
```

 - 条件语句脚本简单使用（注意：'EOF' 加单引号，可使创建文件时，里面的$符号不会被删除，下面有使用例子）
```bash
# 创建awk命令文件（注意：BEGIN后面的大括号不能换行，否则报错；还有 \$2的反斜杠是为了转义$符号，因为不转义的话，$符号不能无法使用cat命令写入文件（也可以使用 'EOF' 加单引号来解决这个问题））
$ cat > test.awk <<EOF
BEGIN {
    FS=","
}
{
    if(\$2 < 50) {
        print "小于50"
    }else if(\$2 > 100) {
        print "大于100"
    }else{
        print "50-100之间"
    }
}
EOF

# 执行命令（注意：-f表示指定awk命令所在文件，aaa表示要处理的数据所在文件）
$ awk -f test.awk aaa
```
 
 - while循环简单使用（注意：这里是计算 1+2+3+...+100 的值，还有awk脚本的END语句块没有写，默认是省略掉的，还有BEGIN后面的大括号不能换行，否则报错）
```bash
# 创建awk脚本（注意：i和sum变量没有定义，默认就是0）
$ cat > whileeach.awk << EOF
BEGIN {
    while(i<=100){
        sum+=i
        i++
    }
    print sum
}
EOF

# 执行awk脚本文件
$ awk -f whileeach.awk
```

 - do while 循环简单使用（注意：这里是计算 1+2+3+...+100 的值，还有awk脚本的END语句块没有写，默认是省略掉的，还有BEGIN后面的大括号不能换行，否则报错）
```bash
# 创建awk脚本（注意：i和sum变量没有定义，默认就是0）
$ cat > dowhileeach.awk << EOF
BEGIN {
    do {
        sum+=i
        i++
    } while(i<=100)
    print sum
}
EOF

# 执行awk脚本文件
$ awk -f dowhileeach.awk
```

 - for循环简单使用（注意：这里是计算 1+2+3+...+100 的值，还有awk脚本的END语句块没有写，默认是省略掉的，还有BEGIN后面的大括号不能换行，否则报错）
```bash
# 创建awk脚本（注意：sum变量没有定义，默认就是0）
$ cat > foreach.awk << EOF
BEGIN {
    for(i=0;i<=100;i++) {
        sum+=i
    }
    print sum
}
EOF

# 执行awk脚本文件
$ awk -f foreach.awk
```

 - 使用awk脚本输出文件里面平均分大于90的数据 和 累加每一列的值（注意：BEGIN后面的大括号不能换行，否则报错）
```bash
# 创建数据文件
$ cat > student.data << EOF
Name Aa Dd Fd Fk
Alle 80 10 20 10
Msad 93 98 92 91
Maom 86 89 68 92
Ha   78 99 88 100
Lo   88 56 89 25
EOF

# 创建awk脚本（注意：'EOF' 有单引号，表示创建文件时，里面的$符号不会被删除）
$ cat > student.awk << 'EOF'
BEGIN {
    # %-10s：%s 表示取字符串变量，10 表示在前面加10个空字符，- 表示表示左对齐
    printf "%-10s%-10s%-10s%-10s%-10s%-10s\n","Name","Aa","Dd","Fd","Fk","平均分"
}

{   # 把一行的所有分数相加（$2表示取第2列的值，$3表示取第3列的值）
    total=$2+$3+$4+$5
    # 平均分
    avg=total/4
    if(avg>90) {
        # 打印 名称，分数，平均分（%-10s：%s 表示取字符串变量，10 表示在前面加10个空字符，- 表示表示左对齐）
        printf "%-10s%-10d%-10d%-10d%-10d%-0.2f\n",$1,$2,$3,$4,$5,avg
        
      # 累加平均分大于90的每一列（注意：变量没有定义默认就是0，$2表示取第2列的值，$3表示取第3列的值）
	   total_Aa+=$2
	   total_Dd+=$3
	   total_Fd+=$4
	   total_Fk+=$5
	   total_avg+=avg
    }
}

END {
    # 打印每一列的总和
    printf "%-10s%-10d%-10d%-10d%-10d%-0.2f\n","总和",total_Aa,total_Dd,total_Fd,total_Fk,total_avg

}
EOF

# 执行awk脚本处理文件
$ awk -f student.awk student.data
```

#### 七、awk里面常用的字符串函数
 - 字符串函数对照表
```bash
---------------------|-----------------------------------------------------------------------------------------
  function           |  说明
---------------------|----------------------------------------------------------------------------------------- 
length(str)          |  字符串长度
index(str1,str2)     |  在str1中找str2的位置
tolower(str)         |  转为小写
toupper(str)         |  转大写
substr(str,m,n)      |  从str的m个字符开始截取n位
split(str,arr,fs)    |  按fs切割字符串，结果保存到arr数组里面，返回切割后子串的个数（默认使用空格分割）
match(str,RE)        |  在str中按照RE查找，返回位置（注意：RE是正则表达式）
sub(RE,RepStr,str)   |  在str中搜索符合RE的子串，将其替换为RepStr（替换一个）（注意：RE是正则表达式），最后返回替换的个数
gsub(RE,RepStr,str)  |  在str中搜索符合RE的子串，将其替换为RepStr（替换所有）（注意：RE是正则表达式），最后返回替换的个数
---------------------|-----------------------------------------------------------------------------------------
```

- 字符串函简单使用（注意：'EOF' 有单引号，表示创建文件时不会转义字符）
```bash
# 创建数据文件
$ cat > str_fn.data << 'EOF'
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
EOF

# 创建一个输出每一行以冒号分割后，子串的长度的awk脚本
$ cat > str_fn.awk << 'EOF'
BEGIN{
    # 以冒号分割一行字符串 
    FS=":"
}
# 注意：这里面的代码是每一行数据执行一次
{
    i=1
    # NF 表示分割后子串的个数
    while(i<=NF){
        # 打印子串的长度
        printf "%d",length($i)
        if(i != NF){
            printf ":"
        }
        i++
    }
    print ""

}
EOF

# 执行脚本
$ awk -f str_fn.awk str_fn.data

# 将字符串分割后装到一个数组里面，最后输出数组的第一个元素（注意：arr没有定义默认就是一个没有元素的数组）
$ awk 'BEGIN{str="Hadoop Kafka Strom YARN";split(str,arr," ");print arr[1]}'

# 将字符串分割后装到一个数组里面，最后遍历输出数组的每一个元素（注意：arr没有定义默认就是一个没有元素的数组）
$ awk 'BEGIN{str="Hadoop Kafka Strom YARN";split(str,arr," ");for(a in arr){print arr[a]}}'
```

#### 八、awk 常用选项
```bash
-----------|--------------------------------------------------------
option     |  说明
-----------|--------------------------------------------------------
-v         |  传递外部变量或初始化变量到awk中使用
-----------|--------------------------------------------------------
-f         |  指定脚本文件
-----------|--------------------------------------------------------
-F         |  指定分隔符（注意：这个和在BEGIN里面，指定分隔符的意义是一样的）
-----------|--------------------------------------------------------
-V         |  查看awk的版本号
-----------|--------------------------------------------------------

# 查看awk 版本
$ awk -V

# 传递外部变量到awk中使用（注意：取变量赋值是最好使用双引号包起来）
$ num=10
$ var="moamoa"
$ awk -v num1=$num -v name="$var" 'BEGIN{print num1,name}'

# 初始化变量到awk中使用
$ awk -v num1=20 -v name="天天" 'BEGIN{print num1,name}'

# 直接使用-F指定分隔符（注意：BEGIN和END块可以直接省略掉，不写）
$ awk -F ":" 'BEGIN{} {print $1} END{}' /etc/passwd
```

#### 九、awk中数组简单使用（注意：awk中数组元素从1开始，而且数据结构类似于JAVA的Map，而且还能做运算。最后注意：\ 反斜杠表示命令换行）
```bash
# 数组的定义和赋值（注意：因为是直接命令行执行所以每一行后面要写分号，如果把命令写到脚本文件里面就不用写了）
$ awk 'BEGIN {                                       \
      # 定义数组 sites，并给runoob和google下标赋值                       \
      sites["runoob"]="www.runoob.com";              \
      sites["google"]="www.google.com";              \
      print sites["runoob"] "\n" sites["google"];    \
      # 删除数组下标为google的元素                                                                   \
      delete sites["google"];                        \
      print "删除后再打印";                            \
      print sites["runoob"] "\n" sites["google"]     \
  }'
  
# 数组的运算（注意：因为是直接命令行执行所以每一行后面要写分号，如果把命令写到脚本文件里面就不用写了） 
$ awk 'BEGIN {                                       \
      # 定义数组 sites，并给runoob和google下标赋值                       \
      sites["runoob"]= 1;                            \
      sites["google"]= 10;                           \
      print sites["runoob"] "\n" sites["google"];    \
      # 数组下标为runoob的元素的值加100                  \
      sites["runoob"]+=100;                          \
      print "运算后再打印";                            \
      print sites["runoob"] "\n" sites["google"]     \
  }'  


# 将字符串分割后装到一个数组里面，最后遍历输出数组的每一个元素（注意：arr没有定义默认就是一个没有元素的数组）
$ awk 'BEGIN{str="Hadoop Kafka Strom YARN";split(str,arr," ");for(a in arr){print arr[a]}}'
```

#### 十、awk复杂脚本使用
```bash
# 创建数据文件
$ cat > complex.data << 'EOF'
2020-01-22 00:56:30 1 Batches: user allen insert 22498 records into database:product table:detail, insert 20771 records successfully,failed 1727 records
2020-01-22 00:45:22 1 Batches: user moamoa insert 154515 records into database:product table:detail, insert 10258 records successfully,failed 144257 records
2020-01-22 00:23:32 1 Batches: user tianitna insert 101012 records into database:product table:detail, insert 20545 records successfully,failed 80467 records
2020-01-22 00:10:10 1 Batches: user wenjuan insert 454545 records into database:product table:detail, insert 21548 records successfully,failed 432997 records
2020-01-22 00:56:30 1 Batches: user allen insert 22498 records into database:product table:detail, insert 20771 records successfully,failed 1727 records
2020-01-22 00:45:22 1 Batches: user moamoa insert 154515 records into database:product table:detail, insert 10258 records successfully,failed 144257 records
2020-01-22 00:23:32 1 Batches: user tianitna insert 101012 records into database:product table:detail, insert 20545 records successfully,failed 80467 records
2020-01-22 00:10:10 1 Batches: user wenjuan insert 454545 records into database:product table:detail, insert 21548 records successfully,failed 432997 records
EOF

# 分别输出每个用户共插入的数据数量
$ cat > complex.awk1 << 'EOF'
BEGIN{
    printf "%-10s%-10s","User","Total Records\n"
}
{
    # 定义数组，下标使用用户名表示，值是第8列的值
    # 注意：这个数组可以看成是JAVA里面的Map，键是用户名，值是用户名相同的所有行第8列的值相加（就是所有Key相同的值相加），最后得到一个Map式的数组
    USER[$6]+=$8
}
END{
    # 遍历数组Map
    for(u in USER) {
        printf "%-10s%-10d\n",u,USER[u]
    }
}
EOF

$ awk -f complex.awk1 complex.data
```