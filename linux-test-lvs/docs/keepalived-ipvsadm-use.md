#### 一、安装LVS管理工具Ipvsadm（注意：所有的LVS代理服务器上都要安装）
```bash
$ yum install ipvsadm
```

#### 二、安装Keepalived（注意：任选一台LVS代理服务器上安装，再将安装包转发到其它服务器上即可）
```bash
$ cd /home/tools
$ sudo yum install gcc openssl-devel
# 备用下载地址：https://github.com/firechiang/mq-test/raw/master/rabbitmq/data/keepalived-2.0.16.tar.gz
$ wget https://www.keepalived.org/software/keepalived-2.0.16.tar.gz
$ tar -zxvf keepalived-2.0.16.tar.gz -C ./
$ cd keepalived-2.0.16
$ sudo ./configure --prefix=/usr/local/keepalived && sudo make && sudo make install
$ scp -r /home/tools/keepalived-2.0.16/keepalived/etc/init.d /usr/local/keepalived/etc
```

#### 三、修改 [vi /usr/local/keepalived/etc/init.d/keepalived] Keepalived开机启动脚本
```bash
# 将 /etc/sysconfig/keepalived 替换为如下内容（其实就是修改了 keepalived 系统配置文件所在目录）
/usr/local/keepalived/etc/sysconfig/keepalived
```

#### 四、备份Keepalived默认配置文件
```bash
$ cp /usr/local/keepalived/etc/keepalived/keepalived.conf /usr/local/keepalived/etc/keepalived/keepalived1.conf
$ rm -f /usr/local/keepalived/etc/keepalived/keepalived.conf
```

#### 五、修改 [vi /usr/local/keepalived/etc/keepalived/keepalived.conf] 配置文件
```bash
! Configuration File for keepalived

global_defs {
  router_id server006                             # 节点ID，通常为hostname（注意：主从节点不能一样）
}

# 以下为具体节点的一些配置
vrrp_instance VI_1 {
  state MASTER                                    # 主节点为MASTER，备份节点为BACKUP
  interface ens33                                 # 绑定虚拟IP的网络接口（网卡），与本机IP地址所在的网络接口相同（Centos7默认：ens33）
  virtual_router_id 51                            # 虚拟路由ID号，可以随便起（注意：主从节点必须相同,取值0-255。但是同一内网中不应有相同virtual_router_id的集群）
  priority 100                                    # 优先级配置，越大优先级越高，抢占IP成功率越高，主节点最好设置的比从节点大（0-254的值）
  advert_int 1                                    # 节点间组播信息发送间隔（心跳检测时间，单位秒），默认1s（注意：主从节点需一致）
  nopreempt                                       # 优先级高的节点挂了之后，重新启动不抢占虚拟IP
  # 心跳检测时所使用的密码
  authentication {
    auth_type PASS                                # 密码类型
    auth_pass 1111                                # 密码
  }
  # 虚拟IP要和真实IP的网段一致，可以指定多个（注意：主从节点需一致）
  # /24就是指定掩码为255.255.255.0。如果是/32就是指定掩码为255.255.255.255
  virtual_ipaddress {
    192.168.83.100/24
    #192.168.229.17/24
    #192.168.229.18/24
  }
}

# 为LVS的虚拟IP定义集群服务
virtual_server 192.168.83.100 8080 {
    delay_loop 6
    lb_algo rr                                    # 轮询模式
    lb_kind DR                                    # 转发模式
    #persistence_timeout 50                       # 记录client的请求信息到lvs的hash表里，信息的过期时间（过期时间内请求分发到同一台机器），单位秒（注意：这个一般不配置）
    protocol TCP

    #sorry_server 192.168.200.200 1358            # 错误服务器（注意：这个一般不配置）

    real_server 192.168.83.145 8080 {
        weight 1
        # 当前real_server的健康检查（注意：TCP_CHECK方式的健康检查只是向后台服务转发一些TCP报文，只要有相应就说明是健康的）
        # 注意：健康检查还可以配置Http的地址，可参考/usr/local/keepalived/etc/keepalived/keepalived1.conf配置文件
        TCP_CHECK {
            connect_port 8080
            connect_timeout 3
        }
    }

    real_server 192.168.83.145 8080 {
        weight 1
        # 当前real_server的健康检查（注意：TCP_CHECK方式的健康检查只是向后台服务转发一些TCP报文，只要有相应就说明是健康的）
        # 注意：健康检查还可以配置Http的地址，可参考/usr/local/keepalived/etc/keepalived/keepalived1.conf配置文件
        TCP_CHECK {
            connect_port 8080
            connect_timeout 3
        }
    }
}
```

#### 六、分发安装包到从节点
```bash
$ scp -r /usr/local/keepalived root@server007:/usr/local
```

#### 七、修改 [vi /usr/local/keepalived/etc/keepalived/keepalived.conf] 从节点配置文件（注意：每个从节点都要配置）
```bash
global_defs {
  router_id server007                               # 节点ID，通常为hostname（注意：主从节点不能一样）
}

# 以下为具体节点的一些配置
vrrp_instance VI_1 {
  state BACKUP                                      # 主节点为MASTER，备份节点为BACKUP
  interface ens33                                   # 绑定虚拟IP的网络接口（网卡），与本机IP地址所在的网络接口相同（Centos7默认：ens33）
  priority 90                                       # 优先级配置，越大优先级越高，主节点最好设置的比从节点大（0-254的值）
}
```

#### 八、配置防火墙开启VRRP协议（注意：每个Keepalived节点都要配置）
```bash
#$ sudo firewall-cmd --direct --permanent --add-rule ipv4 filter INPUT 0 --in-interface em1 --destination 192.168.229.132 --protocol vrrp -j ACCEPT
$ sudo firewall-cmd --direct --permanent --add-rule ipv4 filter INPUT 0 --protocol vrrp -j ACCEPT
$ firewall-cmd --reload                             # 加载防火墙配置
```

#### 九、修改 Keepalived 配置文件和日志文件所在目录（注意：每个Keepalived节点都要配置）
##### 9.1，修改[vi /usr/local/keepalived/etc/sysconfig/keepalived]
```bash
# -f 指定配置文件目录，-S 15 表示 local9.* 具体的还需要看一下/etc/rsyslog.conf文件
KEEPALIVED_OPTIONS="-f /usr/local/keepalived/etc/keepalived/keepalived.conf -D -S 9"
```

##### 9.2，修改[vi /etc/rsyslog.conf]添加如下内容
```bash
local9.*                                                /var/log/keepalived.log
```

#### 十、拷贝开机启动脚本到init.d目录（注意：每个Keepalived节点都要配置）
```bash
$ chmod +x /usr/local/keepalived/etc/sysconfig/keepalived
$ cp /usr/local/keepalived/etc/init.d/keepalived /etc/init.d/keepalived
$ ln -s /usr/local/keepalived/sbin/keepalived /sbin/
```

#### 十一、启动和停止 Keepalived
```bash
$ sudo chkconfig keepalived on                      # 开启 keepalived 开机启动
$ sudo chkconfig keepalived off                     # 关闭 keepalived开机启动
$ service keepalived start                          # 启动 
$ service keepalived restart                        # 重启
$ service keepalived stop                           # 停止
$ service keepalived status                         # 查看状态

$ ps -ef | grep keepalived                          # 查看 keepalived 进程信息
```

#### 十二、在LVS代理服务器上查看是否有我们在Keepalived里面配置的LVS转发规则（注意：这些规则是Keepalived自动帮我们配的而且还有健康检查，如果后端服务宕机了，Keepalived会自动删除转发规则，如果健康了就会自动添加好规则）
```bash
$ ipvsadm -L -n
# 以下为打印内容
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  192.168.83.100:8080 rr
  -> 192.168.83.144:8080          Route   1      0          0         
  -> 192.168.83.145:8080          Route   1      0          0
```
