#### 脚本里面第一行写（#! /bin/bash）的意思是：在当前 bash 下启动一个子 bash 执行脚本里面的命令
#### [第一个测试脚本][1]
#### 测试命令
```bash
$ yum -y install psmisc               # 安装可以以树状图显示程序安装包详细信息工具（就是支持：pstree 命令）
$ echo $$                             # 查看当前 bash 进程ID
$ type yum                            # 查看 yum 命令相关信息（一般会显示脚本所在路径）
$ chmod +x text.sh                    # 让 text.sh 脚本文件变成可自行文件（因为新建的脚本文件需要配合  bash 才能执行）
```
[1]: https://github.com/firechiang/linux-test/tree/master/sh/bash-test.sh
