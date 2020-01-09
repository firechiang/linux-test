#### 一、[Shell编程][6]
#### 二、[网络连接参数优化(影响服务器连接数)][1]
#### 三、[系统文件句柄数量优化(影响服务器连接数)][2]
#### 四、[numa说明以及优化(影响CPU使用率)][3]
#### 五、[资源限制][4]
#### 六、[磁盘IO调度策略(影响程序读写效率)][5]
#### 七、[Linux Crontab（定时执行）使用和说明][7]
#### 八、[Shell脚本学习记录][8]
#### 九、[网络数据包防火墙iptables使用说明（注意：是Linux内核的iptables）][9]
#### 十、挂载新硬盘以及创建分区（注意：一块磁盘最多只能有4个分区，至少要有一个主分区，最多只能有一个扩展分区。主分区格式化之后就可以使用，扩展分区必须先划分逻辑分区，格式化所有的逻辑分区以后才能使用。主分区和扩展分区都可以安装系统。建议都创建主分区）
```bash
$ fdisk -l                            # 查看机器硬盘信息，找到新添加的硬盘名称
$ fdisk /dev/sdb                      # 管理磁盘

Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0x700dc500.

Command (m for help): n               # 创建新的分区（n=创建新的分区，d=删除分区，p=列出分区列表，w=保存分区信息并退出，q=退出而不保存）
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p                 #（p=创建主分区，e=创建扩展分区）
Partition number (1-4, default 1): 1  # 当前磁盘的分区号（一块磁盘最多4个分区，所以最大是4，详情请看上面的注意事项）
First sector (2048-20971519, default 2048): 
Using default value 2048              # 分区容量从磁盘容量的哪个位置开始
Last sector, +sectors or +size{K,M,G} (2048-20971519, default 20971519): 
Using default value 20971519          # 分区容量到磁盘容量的哪个位置结束
Partition 1 of type Linux and of size 10 GiB is set

Command (m for help): w               # 保存分区信息并退出（n=创建新的分区，d=删除分区，p=列出分区列表，w=保存分区信息并退出，q=退出而不保存）
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.

$ fdisk -l                            # 查看机器硬盘信息，找到新添加的硬盘和分区名称
$ mkfs -t ext4 /dev/sdb1              # 格式化新建分区（将新建分区/dev/sdb1格式化成ext4格式）

# 修改/etc/fstab文件，将磁盘分区/dev/sdb1，永久的挂载到/mnt/test_data目录，磁盘格式是ext4
# 注意：要重启机器才能生效（命令：reboot）
$ echo /dev/sdb1 /mnt/test_data ext4 defaults 0 0 >> /etc/fstab                       
```

#### 十一、修改时区（注意：建议系统安装时要设置好）
```bash
$ timedatectl list-timezones             # 查看系统所支持的所有时区
$ ls -l /etc/localtime                   # 查看系统当前时区
$ timedatectl set-timezone Asia/Shanghai # 修改为中国上海时区（注意：系统所支持的时区里面没有北京）
```

#### 十二、其它命令用法
```bash
$ echo $?                                # 查看上一条命令的执行结果（0 表示执行成功，1 表示执行异常）
$ which java                             # 查找某个程序安装目录（这个命令找的是java的安装目录）
$ ps -ef | grep java | grep -v grep      # 查找某个进程是否存在（注意：这个命令也会启一个进程，同时也会被查出来。grep -v grep 就是过滤掉这个命令启动的进程）
$ ps -ef | grep java | wc -l             # wc -l 表示统计命令执行结果的条数

$ sh -x ./fn.sh                          # 执行脚本加 -x 参数，可以打印脚本的执行过程
$ cat /etc/passwd | cut -d: -f1          # 获取所有用户（说明：先获取到/etc/passwd里面的所有数据，再通过:号进行行分割，再获取每一行分割后的第一个位置的数据）
```

[1]: https://github.com/firechiang/linux-test/tree/master/docs/ipv4-parameter-optimization.md
[2]: https://github.com/firechiang/linux-test/tree/master/docs/network-io-optimization.md
[3]: https://github.com/firechiang/linux-test/tree/master/docs/numa-explain.md
[4]: https://github.com/firechiang/linux-test/tree/master/docs/resources-limits.md
[5]: https://github.com/firechiang/linux-test/tree/master/docs/disk-io-strategy.md
[6]: https://github.com/firechiang/linux-test/tree/master/docs/bash-simple-use.md
[7]: https://github.com/firechiang/linux-test/tree/master/docs/linux-crontable-use.md
[8]: https://github.com/firechiang/linux-test/tree/master/docs/shell/index.md
[9]: https://github.com/firechiang/linux-test/tree/master/docs/iptables-doc.md
