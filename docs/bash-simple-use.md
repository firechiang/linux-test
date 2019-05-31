#### 脚本里面第一行写（#! /bin/bash）的意思是：在当前 bash 下启动一个子 bash 执行脚本里面的命令
#### [第一个测试脚本][1]
#### 简单测试命令使用
```bash
$ yum -y install psmisc                     # 安装可以以树状图显示程序安装包详细信息工具（就是支持：pstree 命令）
$ echo $$                                   # 查看当前 bash 进程ID
$ type yum                                  # 查看 yum 命令相关信息（一般会显示脚本所在路径）
$ chmod +x text.sh                          # 让 text.sh 脚本文件变成可自行文件（因为新建的脚本文件需要配合  bash 才能执行）
$ ps -ef                                    # 查看系统所有进程
$ echo $$                                   # 接收 bash 的ID（不一定是当前 bash 的，可能是父 bash 的ID），让后打印出来
$ scho $BASHPID                             # 获取到当前 bash 的父 bash 的ID，然后打印出来
$ echo $?                                   # 查看上一个命令是否执行成功，返回 0 标识成功，非 0 标识失败

# 字符串拼接
$ aaa="123"
$ echo ${aaa}4545                           # 取到变量 aaa 的值以后再加上4545最后显示出来 
```

#### 文本流输出重定向
```bash
$ ls 1>> aaa                                # 将 ls 命令的结果，输出到 aaa 文件，1代表ls命令正常输出的数据，可以不写默认就是1（不会覆盖文件原有内容）  
$ ls 1> aaa                                 # 将 ls 命令的结果，输出到 aaa 文件，1代表ls命令正常输出的数据，可以不写默认就是1（会覆盖文件所有内容）   
$ ls /wqwq 2>> bbb                          # 将 ls 命令的错误信息输出到 bbb 文件，2代表ls命令错误信息数据（不会覆盖文件原有内容）
$ ls / /lsdsd 1>> aaa  2>> bbb              # 将 / 的正常结果放到 aaa 文件，将 /lsdsd 错误信息放到 bbb 文件
$ ls / /dsdsd 1>>test.log 2>&1              # 将 / 的正常结果输出到 test.log 文件，将 /dsdsd 的错误信息输出到 1，而 1 又指向 test.log 文件，所以最后信息都会输出到test.log（&说明是文本流）
$ ls / /asds >& test.log2                   # 将命令 ls / /asds 的结果信息和错误信息都输出到 test.log2 文件（&说明是文本流，注意：这种写法只能覆盖文件，不能追加）
$ ls / /sdsdsd &>> test.log3                # 将命令 ls / /sdsdsd 的结果信息和错误信息都输出到 test.log3 文件（&说明是文本流，注意：这种写法可覆盖文件数据，也可追加数据）
```

#### 文本流输入重定向
```bash
$ read aaa <<< "sadasda";                   # 在内存当中定义变量 aaa 值等于："sadasda"
$ echo $aaa                                 # 查看内存当中 aaa 的值
$ cat << AAA                                # 执行该命令，然后输入数据，最后以 AAA 结束，最后的效果就是会输出 两个 AAA 之间的数据
```

#### 文本流重定向示例
```bash
cd /proc/$$/fd                              # 定位到当前 bash 进程下
exec 8<> /dev/tcp/docs.r9it.com/80          # 创建一个网络输入输出流指向文件8
echo "GET -e /manual/java HTTP/1.0\n" 1>&8  # 将信息 "GET -e /manual/java HTTP/1.0\n" 写入文件8，它会自动发起请求，返回的结果会写在文件8里面
cat 0>&8                                    # 定义文本流0，将文本流8里面的数据读取出来，放到0里面来，然后再显示出来
```

#### 函数使用(注意：加 local 的变量只能在当前函数使用，没有加的默认是局部的，在当前 bash 里面可用)[脚本执行时获取参数](https://github.com/firechiang/linux-test/tree/master/sh/param-test.sh)
```bash
# 创建函数 test
test(){
    AAA="a"
    local BBB="212"
    echo $AAA
    echo $BBB
    echo $#                                 # 获取参数的个数
    echo $*                                 # 获取参数列表
    echo $@                                 # 获取参数列表
}

# 调用 test 函数
$ test

# 带参数的函数
test1(){
    echo $1
    sleep 10                                # 线程睡10秒
    echo $2
}
# 执行函数test1
$ test1
```

#### 数组使用(注意：数组是以逗号分隔的)
```bash
$ aaa=(1 2 3)                               # 定义数组变量
$ echo $aaa                                 # 打印 aaa 变量的值
$ echo ${aaa[0]}                            # 打印数组第0个位置的值
$ echo ${aaa[*]}                            # 打印数组里面的所有元素
$ echo ${aaa[@]}                            # 打印数组里面所有元素
```

#### export 使用（注意：在命令行，子 bash 会直接继承父 bash 的变量，但是在脚本文件里面想要获取父 bash 的变量值，需要在父 bash 里面 export 变量以后，才可获取到）
```bash
$ a=1212
$ echo $a
$ ecport a                                  # 导出变量a（导出以后，在脚本文件里面就可以获取到变量a的值了了）
```

#### 引用和命令替换使用（单引号：弱引用，不可嵌套；双引号：强引用，参数扩展）
```bash
$ a=jiang
$ echo "$a"                                 # 它会打印 jiang（双引号里面的会直接被当成命令来执行，但是不能包含花括号（就是{}））
$ echo '$a'                                 # 它会打印 $a（单引号说明是字符串） 

$ echo "echo "jiang""                       # 它会打印  echo jiang
$ echo "`echo "jiang"`"                   # 它会打印  jiang（因为：bash 看到 ` 号，包起来的数据，会当成命令来预先执行，然后将结果推送回来，这个可以理解为命令替换）

$ a=$(ls /)                                 # 定义变量，这个变量的值是命令
$ echo $a                                   # 先执行变量命令，然后再将结果推送回来，在打印出来
```

[1]: https://github.com/firechiang/linux-test/tree/master/sh/bash-test.sh
