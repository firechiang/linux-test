### ubuntu基础命令

##### 常用其它命令 
```bash
$ shutdown -h now               # 现在立即关机
$ shutdown -r now               # 现在立即重启
$ ifconfig                      # 查看ip
$ source /etc/profile           # 重新装载配置文件，也就是配了环境变量不需要从新登陆
```

##### apt-get包管理器相关命令
```bash
$ sudo apt-get update                     # 更新程序安装包
$ sudo aptitude update                    # 更新程序安装包
$ sudo apt-get install <packagename>      # 安装程序
$ sudo aptitude install <packagename>     # 安装程序
$ sudo apt-get install openjdk-7-jdk      # 安装 以防 hadoop jps命令 报错
$ apt-get remove openjdk                  # 卸载默认jdk安装包<以root运行>
```

##### ssh相关命令
```bash
$ service ssh status            # 检查ssh状态
$ ps -e | grep sshd             # 查看ssh是否已装好
$ /etc/init.d/ssh start         # 启动ssh
$ /etc/init.d/ssh restart       # 重新启动ssh
```

##### 服务（service）相关命令
```bash
$ service ssh status            # 检查ssh服务的状态
```

##### 用户相关命令
```bash
$ useradd jiang                 # 创建用户jiang
$ passwd jiang                  # 为用户jiang创建密码
$ gpasswd -a jiang wheel        # 赋予 jiang root权限
$ id jiang                      # 查看用户（jiang）信息
$ userdel -rf jiang             # 彻底删除用户jiang
$ vi /etc/sudoers               # 修改/etc/sudoers文件添加：jiang   ALL=(ALL)       ALL 可使用sudo命令提权
$ sudo su jiang                 # 权限切换到jiang并赋予root权限，<也可用jiang登陆，再执行：sudo su jiang 获取root权限>前提必须要有上面那一步
$ sudo su                       # 切换到root账号
$ su jiang                      # 以普通模式切换到jiang账号
$ sudo passwd root              # 为root账号配置密码
$ usermod -g root jiang         # 为jiang添加root权限
```

##### 添加用户组和用户
```bash
$ sudo addgroup hadoop 
$ sudo adduser --ingroup hadoop hduser
$ sudo adduser hduser sudo
```

##### 文件解压相关命令
```bash
.xz文件解压                      # 先执行 "xz -d 文件名" 会变成 tar 文件，再执行  "tar -xvf 文件名" 解压
$ tar -zxvf a.zip               # 解压a.zip文件到当前目录

```

##### 权限相关命令
```bash
$ chmod +x 文件名               # 为文件添加一个执行权限
$ chmod 755 文件名              # 修改文件夹权限为755 
```

##### 查看文件内容相关命令
```bash
$ tail -111f 文件名              # 动态显示文件内容（最多显示 111 行）
$ more a.text                   # 查看文件内容（分段显示）
$ cat a.text                    # 正叙查看文件内容
$ tac a.text                    # 倒叙查看文件内容
```

##### 文件复制以及名字修改相关命令
```bash
$ scp -r /home/a.text /usr      # 复制home目录下a.text文件到 usr目录下 <-r 是包括子目录>
$ cp -a hive.temp hive.xml      # 复制文件hive.temp内容，生成新文件hive.xml
$ mv zo.cfg z.cfg               # 将文件名 zo.cfg 改成 z.cfg
```

##### 文件目录操作相关命令
```bash
$ pwd                           # 查看当前目录
$ ~                             # 根目录就是root目录
$ ls                            # 查看目录下文件和文件夹
$ ll -a                         # 查看目录下文件和文件夹包括隐藏文件
$ mkdir java                    # 创建文件夹名字为java
$ touch a.txt                   # 建立文件a.txt
$ rm -rf java                   # 删除java文件夹及子目录和文件
$ ln -sf /home/hadoop /home/h   # 创建快捷方式 从/home/hadoop 到 /home/h
```

##### vi命令 
```bash
按esc进入命令模式
按a进入编辑模式
$ dd                            # 删除一行
$ dw                            # 删除一个单词
$ o 和 O                        # 插入一行<向上向下>
$ x                             # 删除一个字
$ /name                         # 搜索名字叫name的位置


$ ZZ                            # 保存文件退出
$ :wq                           # 保存文件退出
$ :wq!                          # 强制保存退出<用于只读文件的修改>
$ :w                            # 保存编辑文件 但不退出
$ :q                            # 退出编辑 如果没保存  提示  No write since last change （use ! to overrides）
$ :q!                           # 放弃修改退出
$ :set nu                       # 显示行号
$ :.,$d                         # 删除从当前行到最后一行的所有数据（光标停留的位置为当前行）
```

##### netstat网络资源占用相关命令
```bash
$ netstat -ntlp                 # 查看端口占用情况
$ netstat -nplt | grep 端口号    # 查看每个端口是否在用
$ netstat -nplt | grep 服务名    # 查看每个服务名是否监听端口
```

##### ubuntu防火墙相关命令
```bash
$ sudo ufw status               # ubuntu查看防火墙状态
$ sudo ufw disable              # ubuntu系统下关闭防火墙(重启生效)
$ sudo ufw enable               # ubuntu系统启用防火墙(重启生效)
$ service iptables stop         # 关闭防火墙
$ sudo apt-get remove ufw       # ubuntu卸载防火墙
```

##### 进程相关命令
```bash
$ kill -9 进程号                 # 杀死进程
$ ps -A | grep nginx            # 查询进程 名字为  nginx
```

##### 程序查找相关命令
```bash
$ which ffserver                # 查找ffserver程序安装目录，没有找到要找的命令，可以试试whereis
$ rpm -qa | grep 名称                              # 查找以安装的软件
$ echo $JAVA_HOME               # 查询是否有 JAVA_HOME 环境变量
```

##### 磁盘相关命令
```bash
$ df -h                         # 查看各个磁盘的分区情况，容量，挂载点
```

##### cygdrive专用命令
```bash
$ sc delete 服务名              # window删除服务<服务名空格，将服务名用双引号包起来>            
$ cd /cygdrive                  # 进入电脑根目录
```

##### 安装配置java环境变量[vi /etc/profile]在文件末加入如下配置
```bash
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64 
export PATH=$JAVA_HOME/bin:$PATH 
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar 


$ source /etc/profile           # 重新装载配置文件，也就是配了环境变量不需要从新登陆
$ which java                    # 查找java程序安装目录
$ java -version                 # 查看java是否安装成功
```

##### 配置默认JDK（自带的）
```bash
$ sudo update-alternatives --config java                                                                 # 检查
 
$ sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.8.0_112/bin/java 300           # 一次执行以下命令
$ sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk1.8.0_112/bin/javac 300  
$ sudo update-alternatives --install /usr/bin/jar jar /usr/lib/jvm/jdk1.8.0_112/bin/jar 300   
$ sudo update-alternatives --install /usr/bin/javah javah /usr/lib/jvm/jdk1.8.0_112/bin/javah 300   
$ sudo update-alternatives --install /usr/bin/javap javap /usr/lib/jvm/jdk1.8.0_112/bin/javap 300
```
