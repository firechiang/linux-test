#### 一、[网络连接参数优化(影响服务器连接数)][1]
#### 二、[系统文件句柄数量优化(影响服务器连接数)][2]
#### 三、[numa说明以及优化(影响CPU使用率)][3]
#### 四、[资源限制][4]
#### 五、[磁盘IO调度策略(影响程序读写效率)][5]
#### 六、[Linux Crontab（定时执行）使用和说明][7]
#### 七、[网络数据包防火墙iptables使用说明（注意：是Linux内核的iptables）][9]
#### 八、[Shell脚本学习记录（注意：在字符串当中获取变量的值，建议使用双引号引起字符串，否则可能会有问题）][8]
#### 九、[Shell脚本操作MySQL相关，包括数据备份，Sheel脚本里面使用FTP上传文件][10]
#### 十、[使用Shell脚本模拟进程管理软件Supervisor（注意：这个里面有Sheel脚本各种各样的用法）][11]
#### 十一、[网卡和网络相关操作以及固定IP和DNS配置][12]
#### 十二、挂载新硬盘以及创建分区（注意：一块磁盘最多只能有4个分区，至少要有一个主分区，最多只能有一个扩展分区。主分区格式化之后就可以使用，扩展分区必须先划分逻辑分区，格式化所有的逻辑分区以后才能使用。主分区和扩展分区都可以安装系统。建议都创建主分区）
```bash
$ fdisk -l                               # 查看机器硬盘信息，找到新添加的硬盘名称
$ fdisk /dev/sdb                         # 管理磁盘

Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0x700dc500.

Command (m for help): n                  # 创建新的分区（n=创建新的分区，d=删除分区，p=列出分区列表，w=保存分区信息并退出，q=退出而不保存）
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p                    #（p=创建主分区，e=创建扩展分区）
Partition number (1-4, default 1): 1     # 当前磁盘的分区号（一块磁盘最多4个分区，所以最大是4，详情请看上面的注意事项）
First sector (2048-20971519, default 2048): 
Using default value 2048                 # 分区容量从磁盘容量的哪个位置开始
Last sector, +sectors or +size{K,M,G} (2048-20971519, default 20971519): 
Using default value 20971519             # 分区容量到磁盘容量的哪个位置结束
Partition 1 of type Linux and of size 10 GiB is set

Command (m for help): w                  # 保存分区信息并退出（n=创建新的分区，d=删除分区，p=列出分区列表，w=保存分区信息并退出，q=退出而不保存）
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.

$ fdisk -l                               # 查看机器硬盘信息，找到新添加的硬盘和分区名称
# $ mkfs.btrfs -f /dev/sdb1              # 格式化新建分区（将新建分区/dev/sdb1格式化成btrfs格式）
$ mkfs -t ext4 /dev/sdb1                 # 格式化新建分区（将新建分区/dev/sdb1格式化成ext4格式）

$ lsblk -f                               # 查看硬盘文件系统格式

# 修改/etc/fstab文件，将磁盘分区/dev/sdb1，永久的挂载到/mnt/test_data目录，磁盘格式是ext4
# 注意：要重启机器才能生效（命令：reboot）
$ echo /dev/sdb1 /mnt/test_data ext4 defaults 0 0 >> /etc/fstab

# 修改/etc/fstab文件，将磁盘分区/dev/sdb1，永久的挂载到/mnt/test_data目录，磁盘格式是btrfs
# 注意：要重启机器才能生效（命令：reboot）
#$ echo /dev/sdb1 /mnt/test_data btrfs defaults 0 0 >> /etc/fstab
```

#### 十三、修改时区（注意：建议系统安装时要设置好）
```bash
$ timedatectl list-timezones             # 查看系统所支持的所有时区
$ ls -l /etc/localtime                   # 查看系统当前时区
$ timedatectl set-timezone Asia/Shanghai # 修改为中国上海时区（注意：系统所支持的时区里面没有北京）
```

#### 十四、文件查找工具find简单使用
```bash
# -name                根据文件名查找
# -iname               根据文件名查找（忽略大小写）
# -perm                根据文件权限查找
# -prune               过滤掉某些目录（注意：这个要配合-path使用）
# -user                根据文件所属用户查找
# -group               根据文件所属组查找

# -nogroup             查找无有效属组的文件（一个组开始创建了很多文件，后来组被删除了，这些文件就是无有效属组的文件）
# -nouser              查找无有效属主的文件（一个用户开始创建了很多文件，后来用户被删除了，这些文件就是无有效属主的文件）
# -size                根据文件大小查找
# -mindepth n          从第n级子目录开始搜索
# -maxdepth n          最多查找到第n级目录

# -type f              根据文件类型查找（f=文件）
# -type d              根据文件类型查找（d=目录）
# -type c              根据文件类型查找（c=字符设备文件）
# -type b              根据文件类型查找（b=块设备文件）
# -type l              根据文件类型查找（l=链接文件）
# -type p              根据文件类型查找（p=管道文件）

# -print               打印查找后的结果（注意：这个参数是默认的）
# -exec                对查找后的结果进行其它命令操作

$ find / -name nginx                     # 从根目录开始查找nginx文件
$ find / -iname nginx                    # 从根目录开始查找nginx文件（忽略大小写）
$ find ./ -user root                     # 查找当前目录属于root用户的所有文件
$ find / -perm 776                       # 从根目录开始查找文件权限是777的文件

$ find ./ -type f                        # 查找当前目录下所有普通文件
$ find ./ -type d                        # 查找当前目录下所有文件夹

$ find ./ -size +1M                      # 查找当前目录大于lM的文件
$ find ./ -size -1M                      # 查找当前目录小于lM的文件
$ find ./ -size 1k                       # 查找当前目录等于lk的文件（注意：不能精确匹配大于等于1M（兆）的文件）

$ find -mtime -3                         # 查找3天之内修改过的所有文件
$ find -mtime +3                         # 查找3天之前修改过的所有文件
$ find -mtime 3                          # 查找修改天数等于3天的所有文件

$ find -mmin -3                          # 查找3分钟之内修改过的所有文件
$ find -mmin +3                          # 查找3分钟之前修改过的所有文件

$ find -mtime -3 -name '*.bd'            # 查找3天之内修改过，以bd结尾的所有文件
$ find -mtime +3 -user root              # 查找3天之前修改过，属于root的所有文件

# -o   表示或
# -a   表示与
# -not 表示非
# 从根目录开始查找*b文件，过滤掉/u目录下的所有文件和文件夹（-path /u -prune就是过滤/u目录，-o是并且的意思（就是后面的命令也会执行））
$ find / -path /u -prune -o -name *b  

# 从根目录开始查找*db文件，过滤掉/var和/usr目录下的所有文件和文件夹
$ find / -path /var -prune -o -path /usr -prune -o -name *db

# 查找当前目录比function_example_5.sh文件要新的文件
$ find ./ -newer function_example_5.sh

# -exec 查询结果后再执行其它操作
# -ok   查询结果后再执行其它操作（注意：这个在执行其它操作会有提示）
# 将查找到的文件再进行其它操作（这里是删除）{} 表示查找后的结果，\; 表示命令的结尾
$ find / -name test.db -exec rm -rf {} \;

# 将查找到的文件再进行其它操作（这里是复制）{} 表示查找后的结果，\; 表示命令的结尾
$ find ./test_fold -name '*.sh' -exec cp {} ./test_fold1 \;
```

#### 十五、文件查找工具locate命令简单使用，locate命令不是搜索整个磁盘而是搜索locate自带的数据库，数据库的信息会定时更新（注意：如果没有该命令请安装：yum install mlocate）（注意：不推荐使用）
 - locate自带的数据库信息文件：/var/lib/mlocate/mlocate.db
 - locate自带的数据库配置文件：/etc/updatedb.conf
 - locate命令在cron有定时任务定期执行
```bash
$ updatedb                               # 更新locate自带的数据信息
$ touch /home/test.db                    # 创建一个测试文件
$ locate test.db                         # 使用locate命令查找test.db文件所在目录（注意：应该是查不到的，因为locate数据库没有更新）
$ updatedb                               # 更新locate数据库
$ locate test.db                         # 再查找test.db文件，应该就有了
```

#### 十六、程序查找工具whereis命令简单使用
```bash
# -b 查找二进制文件
# -m 只返回帮助文档文件
# -s 只反回源代码文件
$ whereis mysql                          # 查找mysql程序所在文件目录 
$ whereis -b mysql                       # 查找mysql程序所在文件目录           
```

#### 十七、可执行程序查找工具which命令简单使用
```bash
# -b 只返回二进制文件
$ which mysql                            # 查找mysql可执行文件所在目录    
$ which -b mysql                         # 查找mysql可执行文件所在目录      
$ which java                             # 查找某个程序安装目录（这个命令找的是java的安装目录）   
```

#### 十八、新建用户和赋予root权限
```bash
$ su root                                # 切换到root账号，以便创建新的账号
$ adduser chiang-fire                    # 添加用户，名字叫 chiang-fire
$ passwd chiang-fire                     # 修改 chiang-fire 账户密码
Changing password for user chiang-fire.
New password: 
BAD PASSWORD: The password is shorter than 8 characters
Retype new password: 
passwd: all authentication tokens updated successfully.

$ cat /etc/passwd                        # 查看用户是否创建成功（如果成功了，在这个文件里面会有刚刚创建的那个用户信息）

$ id chiang-fire                         # 查看用户 chiang-fire 权限信息（注意：这个时候是没有root权限）
uid=1000(chiang-fire) gid=1000(chiang-fire) groups=1000(chiang-fire)

$ usermod -g root chiang-fire            # 赋予账号 root 权限给chiang-fire账户（其实就是将chiang-fire账户添加到root组里）

$ su chiang-fire                         # 切换到chiang-fire账户

$ id chiang-fire                         # 查看用户 chiang-fire 权限信息（gid=0(root) groups=0(root) 表示有root权限了）
uid=1000(chiang-fire) gid=0(root) groups=0(root)
```

#### 十九、其它命令用法
```bash
$ who                                    # 查看当前用户信息
$ type yum                               # 查看 yum 命令相关信息（一般会显示脚本所在路径）
$ yum -y install psmisc                  # 安装可以以树状图显示程序安装包详细信息工具（就是支持：pstree 命令）

$ chmod +x text.sh                       # 让 text.sh 脚本文件变成可自行文件（因为新建的脚本文件需要配合  bash 才能执行）

$ echo `hostname`                        # 获取hostname
$ echo $(hostname)                       # 获取hostname
$ echo $(date +%Y)                       # 获取当前年
$ echo `cat aaa.sh | cut -d "#" -f 1`    # 使用#号分割，取分割后第一个位置的数据（-d指定分隔符，-f指定获取位置）
$ echo $(cat aaa.sh | cut -d "#" -f 1)   # 使用#号分割，取分割后第一个位置的数据（-d指定分隔符，-f指定获取位置）
$ echo ${array[@]}                       # 获取数组变量array里面的所有元素
$ echo ${array[0]}                       # 获取数组变量array里面的第0个元素
$ scho $BASHPID                          # 获取到当前 bash 的父 bash 的ID，然后打印出来
$ echo $$                                # 查看当前 bash 进程ID
$ echo $?                                # 查看上一个命令是否执行成功，返回 0 标识成功，非 0 标识失败
$ echo ${aaa}4545                        # 取到变量 aaa变量的值以后再加上4545最后显示出来（注意：这是字符串拼接） 

$ ps -ef                                 # 查看系统所有进程
$ ps -ef | grep java | grep -v grep      # 查找某个进程是否存在（注意：这个命令也会启一个进程，同时也会被查出来。grep -v grep 就是过滤掉这个命令启动的进程）
$ ps -ef | grep crypto | wc -l           # 获取crypto进程的条数（注意：wc -l 就是统计数据的条数）

$ env|grep JAVA_OPTS                     # 查看环境变量JAVA_OPTS的值（注意：这个是前置匹配）

$ sh -x ./fn.sh                          # 执行脚本加 -x 参数，可以打印脚本的执行过程
$ cat /etc/passwd | cut -d: -f1          # 获取所有用户（说明：先获取到/etc/passwd里面的所有数据，再通过:号进行行分割，再获取每一行分割后的第一个位置的数据）
$ dd if=./ of=test.db bs=512k count=2    # 在当前目录生成一个test.db文件，大小是1M（大小=bs * count）

$ ${#array[@]}                           # 获取数组array的长度

$ glxinfo | grep OpenGL                  # 查看显卡驱动相关信息
$ glxgears                               # 测试显卡性能

$ rpm -qa | grep 软件名                   # 查看是否安装了某软件
$ rpm -ql nginx                          # 查看nginx安装的详细信息包括软件安装目录
$ rpm -e --nodeps 软件名                  # 强力删除，对相关依赖的文件也进行强力删除

$ lscpu                                  # 查看CPU配置相关信息
$ free -h                                # 查看机器内存相关信息

$ kill -l                                # 查看系统所有的信号量（就是 kill 命令所有参数的含义）
$ kill -15 PID                           # 优雅关闭进程
$ kill -9 PID                            # 强制关闭进程
$ kill -17 PID                           # 子进程给父进程发送信息
$ kill -1 PID                            # 要进程重读配置文件（注意：这个需要程序实现了这个功能）
```

#### 二十、Trojan代理服务搭建
```bash
# 生成证书私钥(注意：该命令需要填写密码，该密码要记住下面还要用)
$ openssl genrsa -des3 -out trojan-server.key 2048
# 生成CSR(证书签名请求)
# openssl req -new -key trojan-server.key -out trojan-server.csr -subj "/C=CN/ST=BeiJing/L=BeiJing/O=trjm/OU=trjm/CN=127.0.0.1"
$ openssl req -new -key trojan-server.key -out trojan-server.csr -subj "/C=CN/ST=BeiJing/L=BeiJing/O=组织名称(可以随便写)/OU=组织部门名称(可以随便写)/CN=服务器地址或IP"
# 去除私钥中的密码
$ openssl rsa -in trojan-server.key -out trojan-server.key
# 生成自签名SSL证书（自此证书就创建好了）
$ openssl x509 -req -days 3650 -in trojan-server.csr -signkey trojan-server.key -out trojan-server.crt

# 下载Trojan服务器文件
$ wget https://github.com/trojan-gfw/trojan/releases/download/v1.16.0/trojan-1.16.0-linux-amd64.tar.xz

# 下载好后解压找到config.json配置文件修改相关配置然后测试启动trojan服务
$ nohup /home/trojan/trojan -c "/home/trojan/config.json" -l "/home/trojan/logs/trojan.log" > /dev/null 1>&2 &

# 在/lib/systemd/system/目录下创建trojan.service文件并复制下面代码到文件中保存（该文件用于服务器自启动）
[Unit]
Description=trojan
After=network.target

[Service]
Type=simple
PIDFile=/home/trojan/pid/trojan.pid
ExecStart=/home/trojan/trojan -c "/home/trojan/config.json" -l "/home/trojan/logs/trojan.log"
ExecReload=
ExecStop=/home/trojan/trojan
PrivateTmp=true

[Install]
WantedBy=multi-user.target


# 启动Trojan服务
$ systemctl start trojan.service
# 设置开机启动Trojan服务
$ systemctl enable trojan.service  
```

[1]: https://github.com/firechiang/linux-test/tree/master/docs/ipv4-parameter-optimization.md
[2]: https://github.com/firechiang/linux-test/tree/master/docs/network-io-optimization.md
[3]: https://github.com/firechiang/linux-test/tree/master/docs/numa-explain.md
[4]: https://github.com/firechiang/linux-test/tree/master/docs/resources-limits.md
[5]: https://github.com/firechiang/linux-test/tree/master/docs/disk-io-strategy.md
[7]: https://github.com/firechiang/linux-test/tree/master/docs/linux-crontable-use.md
[8]: https://github.com/firechiang/linux-test/tree/master/docs/shell/index.md
[9]: https://github.com/firechiang/linux-test/tree/master/docs/iptables-doc.md
[10]: https://github.com/firechiang/linux-test/tree/master/docs/shell-mysql-operation.md
[11]: https://github.com/firechiang/linux-test/tree/master/docs/shell-supervisor-impl.md
[12]: https://github.com/firechiang/linux-test/tree/master/docs/network-ip.md
