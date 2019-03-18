### centos基础命令

##### 常用其它命令 
```bash
$ ip addr                                                    # 查看ip命令
$ shutdown -h now                                            # 现在立即关机
$ shutdown -r now                                            # 现在立即重启
```


##### 文件目录操作相关命令
```bash
$ ls -a                                                      # 查看所有文件以及隐藏文件
```

##### 权限相关命令
```bash
$ chmod -r 777 文件夹名                                                                                                      # 将文件夹的权限设置为777，这样在这个文件夹里面就有写的权限了
```

#### 全局防火墙相关命令
```bash
$ chkconfig iptables on                                      # 开启防火墙
$ chkconfig iptables off                                     # 关闭防火墙，永久性生效，重启后不会复原
```

##### firewall 防火墙相关命令
```bash
$ firewall-cmd --state                                       # 查看防火墙状态
$ firewall-cmd --list-ports                                  # 查看已经开放的端口

$ firewall-cmd --zone=public --add-port=80/tcp --permanent   # 开放80端口
                                                             # 命令含义：如下
                                                             # zone #作用域
                                                             # add-port=80/tcp #添加端口，格式为：端口/通讯协议
                                                             # permanent #永久生效，没有此参数重启后失效


$ firewall-cmd --reload                                      # 重启加载 firewall 配置
$ systemctl start firewalld.service                          # 开启 firewall  防火墙<系统默认>
$ systemctl stop firewalld.service                           # 关闭 firewall
$ systemctl disable firewalld.service                        # 禁止firewall开机启动
```
##### iptables 防火墙相关命令
```bash
$ /sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT        # 开放80端口
$ /sbin/iptables -I INPUT -p tcp --dport 22 -j ACCEPT        # 开放22
$ /sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT      # 开放8080端口

$ /etc/rc.d/init.d/iptables save                             # 保存开发端口信息
$ /etc/init.d/iptables status                                # 查看已开放的端口

$ service iptables start                                     # 开启
$ service iptables stop                                      # 关闭
```

##### JDK安装配置
```bash
$ sudo mkdir /usr/lib/jvm                                    # 创建 目录
$ scp ./jdk-8u112-linux-x64.tar.gz /usr/lib/jvm              # 复制文件
$ cd /usr/lib/jvm                                            # 跳转目录
$ tar -zxvf jdk-8u112-linux-x64.tar.gz                       # 解压
$ rm -rf jdk-8u112-linux-x64.tar.gz                          # 删除

$ vi ~/.bashrc                                               # 配置环境变量 （以后以当前账号登陆才有jdk）添加如下内容
# set oracle jdk environment
export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_171
export JRE_HOME=${JAVA_HOME}/jre  
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib  
export PATH=$PATH:${JAVA_HOME}/bin

$ source ~/.bashrc                                           # 重读配置，使环境变量生效
$ java  -version                                             # 测试java是否安装成功

```


