#### 一、在LVS代理服务器上安装LVS管理工具Ipvsadm
```bash
$ yum install ipvsadm
```

#### 二、在LVS代理服务器上安装Keepalived
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

#### 三、修改Keepalived[vi /usr/local/keepalived/etc/init.d/keepalived]开机启动脚本
```bash
# 将 /etc/sysconfig/keepalived 替换为如下内容（其实就是修改了 keepalived 系统配置文件所在目录）
/usr/local/keepalived/etc/sysconfig/keepalived
```

#### 四、备份Keepalived默认配置文件
```bash
$ cp /usr/local/keepalived/etc/keepalived/keepalived.conf /usr/local/keepalived/etc/keepalived/keepalived1.conf
$ rm -f /usr/local/keepalived/etc/keepalived/keepalived.conf
```

#### 五、修改[vi /usr/local/keepalived/etc/keepalived/keepalived.conf]配置文件
```bash
! Configuration File for keepalived

global_defs {
  router_id server006                             ## 节点ID，通常为hostname（注意：主从节点不能一样）
}

# 以下为具体节点的一些配置
vrrp_instance VI_1 {
  state MASTER                                    ## 主节点为MASTER，备份节点为BACKUP
  interface ens33                                 ## 绑定虚拟IP的网络接口（网卡），与本机IP地址所在的网络接口相同（Centos7默认：ens33）
  virtual_router_id 51                            ## 虚拟路由ID号，可以随便起（注意：主从节点必须相同,取值0-255。但是同一内网中不应有相同virtual_router_id的集群）
  priority 100                                    ## 优先级配置，越大优先级越高，抢占IP成功率越高，主节点最好设置的比从节点大（0-254的值）
  advert_int 1                                    ## 节点间组播信息发送间隔（心跳检测时间，单位秒），默认1s（注意：主从节点需一致）
  nopreempt                                       ## 优先级高的节点挂了之后，重新启动不抢占虚拟IP
  # 心跳检测时所使用的密码
  authentication {
    auth_type PASS                                ## 密码类型
    auth_pass 1111                                ## 密码
  }
  # 虚拟IP要和真实IP的网段一致，可以指定多个（注意：主从节点需一致）
  virtual_ipaddress {
    192.168.83.100
    #192.168.229.17
    #192.168.229.18
  }
}

# 为LVS的虚拟IP定义集群服务
virtual_server 192.168.83.100 8080 {
    delay_loop 6
    lb_algo rr
    lb_kind DR                                  ## 轮询模式
    persistence_timeout 50
    protocol TCP

    sorry_server 192.168.200.200 1358

    real_server 192.168.200.2 1358 {
        weight 1
        HTTP_GET {
            url {
              path /testurl/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            url {
              path /testurl2/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            url {
              path /testurl3/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            connect_timeout 3
            retry 3
            delay_before_retry 3
        }
    }

    real_server 192.168.200.3 1358 {
        weight 1
        HTTP_GET {
            url {
              path /testurl/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334c
            }
            url {
              path /testurl2/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334c
            }
            connect_timeout 3
            retry 3
            delay_before_retry 3
        }
    }
}
```