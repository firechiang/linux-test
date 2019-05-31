#### 脚本里面第一行写（#! /bin/bash）的意思是：在当前 bash 下启动一个子 bash 执行脚本里面的命令
#### [第一个测试脚本][1]
#### 简单测试命令使用
```bash
$ yum -y install psmisc               # 安装可以以树状图显示程序安装包详细信息工具（就是支持：pstree 命令）
$ echo $$                             # 查看当前 bash 进程ID
$ type yum                            # 查看 yum 命令相关信息（一般会显示脚本所在路径）
$ chmod +x text.sh                    # 让 text.sh 脚本文件变成可自行文件（因为新建的脚本文件需要配合  bash 才能执行）
$ ps -ef                              # 查看系统所有进程
```

#### 文本流输出重定向
```bash
$ ls 1>> aaa                          # 将 ls 命令的结果，输出到 aaa 文件，1代表ls命令正常输出的数据，可以不写默认就是1（不会覆盖文件原有内容）  
$ ls 1> aaa                           # 将 ls 命令的结果，输出到 aaa 文件，1代表ls命令正常输出的数据，可以不写默认就是1（会覆盖文件所有内容）   
$ ls /wqwq 2>> bbb                    # 将 ls 命令的错误信息输出到 bbb 文件，2代表ls命令错误信息数据（不会覆盖文件原有内容）
$ ls / /lsdsd 1>> aaa  2>> bbb        # 将 / 的正常结果放到 aaa 文件，将 /lsdsd 错误信息放到 bbb 文件
$ ls / /dsdsd 1>>test.log 2>&1        # 将 / 的正常结果输出到 test.log 文件，将 /dsdsd 的错误信息输出到 1，而 1 又指向 test.log 文件，所以最后信息都会输出到test.log（&说明是文本流）
$ ls / /asds >& test.log2             # 将命令 ls / /asds 的结果信息和错误信息都输出到 test.log2 文件（&说明是文本流，注意：这种写法只能覆盖文件，不能追加）
$ ls / /sdsdsd &>> test.log3          # 将命令 ls / /sdsdsd 的结果信息和错误信息都输出到 test.log3 文件（&说明是文本流，注意：这种写法可覆盖文件数据，也可追加数据）
```

#### 文本流输入重定向
```bash
$ read aaa <<< "sadasda";             # 在内存当中定义变量 aaa 值等于："sadasda"
$ echo $aaa                           # 查看内存当中 aaa 的值
$ cat << AAA                          # 执行该命令，然后输入数据，最后以 AAA 结束，最后的效果就是会输出 两个 AAA 之间的数据
```

[1]: https://github.com/firechiang/linux-test/tree/master/sh/bash-test.sh
