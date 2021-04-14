#### TCP端口范围（默认值 32768 60999）
```bash
$ sysctl net.ipv4.ip_local_port_range                                   # 查看 TCP 端口范围
$ echo 'net.ipv4.ip_local_port_range = 1024 65535' >> /etc/sysctl.conf  # 修改 TCP 端口范围为 1024 65535
```

#### 内核分配给TCP连接的内存，单位是Page，1 Page = 4096 Bytes（默认值 4096）
```bash
$ getconf PAGESIZE                                                      # 查看内核分配给 TCP 连接的内存
$ sysctl net.ipv4.tcp_mem                                               # 查看内核分配给TCP连接的内存

# 第一个数字表示，当 tcp 使用的 page 少于 196608 时，kernel 不对其进行任何的干预
# 第二个数字表示，当 tcp 使用了超过 262144 的 pages 时，kernel 会进入 “memory pressure” 压力模式
# 第三个数字表示，当 tcp 使用的 pages 超过 393216 时（相当于1.6GB内存），就会报：Out of socket memory
$ echo 'net.ipv4.tcp_mem = 196608 262144 393216' >> /etc/sysctl.conf    # 适用于4GB内存的机器
$ echo 'net.ipv4.tcp_mem = 524288 699050 1048576' >> /etc/sysctl.conf   # 适用于8GB内存的机器（TCP连接最多约使用4GB内存）
```

#### 每个TCP连接分配的读、写缓冲区内存大小，单位是Byte（谨慎修改，一般默认值即可）
```bash
$ sysctl net.ipv4.tcp_rmem                                              # 查看每个TCP连接读的缓冲区内存大小
$ sysctl net.ipv4.tcp_wmem                                              # 查看每个TCP连接读的缓冲区内存大小

# 第一个数字表示，为TCP连接分配的最小内存
# 第二个数字表示，为TCP连接分配的缺省内存
# 第三个数字表示，为TCP连接分配的最大内存
# 一般按照缺省值分配，上面的例子就是读写均为8KB，共16KB
# 1.6GB TCP内存能容纳的连接数，约为  1600MB/16KB = 100K = 10万
# 4.0GB TCP内存能容纳的连接数，约为  4000MB/16KB = 250K = 25万
$ echo 'net.ipv4.tcp_rmem = 4096 87380 6291456' >> /etc/sysctl.conf     # 修改读的缓冲区内存大小
$ echo 'net.ipv4.tcp_wmem = 4096 16384 4194304' >> /etc/sysctl.conf     # 修改写的缓冲区内存大小
```

#### 是否允许将TIME-WAIT sockets重新用于新的TCP连接，建议使用默认值（只对客户端起作用，开启后客户端在1s内回收），0 不开启，1 开启（默认值都是：0）
```bash
$ sysctl net.ipv4.tcp_tw_reuse                                          # 查看

$ echo 'net.ipv4.tcp_tw_reuse = 1' >> /etc/sysctl.conf                  # 修改
```

#### 是否开启TCP连接中TIME-WAIT sockets的快速回收，建议使用默认值（ 对客户端和服务器同时起作用，开启后在 3.5*RTO 内回收，RTO 200ms~ 120s 具体时间视网络状况，优点就是能够回收服务端的TIME_WAIT数量），0 不开启，1 开启（默认为0）
```bash
$ sysctl net.ipv4.tcp_tw_recycle                                        # 查看

$ echo 'net.ipv4.tcp_tw_recycle = 1' >> /etc/sysctl.conf                # 修改
```

#### TCP Keepalive（检测连接是否应该保持，建议优化修改）
```bash
$ sysctl tcp_keepalive_time                                             # 查看连接成功，多久以后发送第一次检测数据包
$ echo 'tcp_keepalive_time = 60' >> /etc/sysctl.conf                    # 修改连接成功，多久以后发送第一次检测数据包（单位秒）

$ sysctl tcp_keepalive_intvl                                            # 查看检测连接是否应该保持的间隔时间
$ echo 'tcp_keepalive_intvl = 60' >> /etc/sysctl.conf                   # 修改检测连接是否应该保持的间隔时间（单位秒）

$ sysctl tcp_keepalive_probes                                           # 查看检测连接是否应该保持的检测总次数
$ echo 'tcp_keepalive_probes = 5' >> /etc/sysctl.conf                   # 修改检测连接是否应该保持的检测总次数（单位秒）
```

### -----------------------------------------以下是可选优化-------------------------------------------------

#### 最大孤儿套接字(orphan sockets)数，单位是个（默认值 8192）（注意：当cat /proc/net/sockstat看到的orphans数量达到net.ipv4.tcp_max_orphans的约一半时，就会报：Out of socket memory）
```bash
$ sysctl net.ipv4.tcp_max_orphans                                       # 查看最大孤儿套接字(orphan sockets)数
$ echo 'net.ipv4.tcp_max_orphans = 65536' >> /etc/sysctl.conf           # 修改最大孤儿套接字(orphan sockets)数
```

#### 孤儿socket废弃前重试的次数，重负载web服务器建议调小，建议使用默认值（默认值 0），设置较小的数值，可以有效降低orphans的数量，设置为0并不是想像中的不重试
```bash
$ sysctl net.ipv4.tcp_orphan_retries                                    # 查看孤儿socket废弃前重试的次数

$ echo 'net.ipv4.tcp_orphan_retries = 1' >> /etc/sysctl.conf            # 修改孤儿socket废弃前重试的次数
```

#### 活动TCP连接重传次数，超过次数视为掉线，放弃连接。默认值：15，建议设为 2或者3
```bash
$ sysctl net.ipv4.tcp_retries2                                          # 查看活动TCP连接重传次数

$ echo 'net.ipv4.tcp_retries2 = 3' >> /etc/sysctl.conf                  # 修改活动TCP连接重传次数
```

#### Linux作为客户端发起TCP三次握手的syn/ack阶段，重试次数，默认值：6，建议设为2-3
```bash
$ sysctl net.ipv4.tcp_syn_retries                                       # 查看TCP三次握手的syn/ack阶段，重试次数

$ echo 'net.ipv4.tcp_syn_retries = 3' >> /etc/sysctl.conf               # 修改TCP三次握手的syn/ack阶段，重试次数
```

#### Linux作为服务端接收TCP三次握手的syn/ack阶段，重试次数，默认值：5，建议设为2-3
```bash
$ sysctl net.ipv4.tcp_synack_retries                                    # 查看TCP三次握手的syn/ack阶段，重试次数

$ echo 'net.ipv4.tcp_synack_retries = 3' >> /etc/sysctl.conf            # 修改TCP三次握手的syn/ack阶段，重试次数
```

#### FIN_WAIT状态的TCP连接的超时时间（如果套接字由本端要求关闭，这个参数决定了它保持在FIN-WAIT-2状态的时间），建议使用默认值（默认值：60）
```bash
$ sysctl net.ipv4.tcp_fin_timeout                                       # 查看FIN_WAIT状态的TCP连接的超时时间

$ echo 'net.ipv4.tcp_fin_timeout = 30' >> /etc/sysctl.conf              # 修改FIN_WAIT状态的TCP连接的超时时间
```

#### TCP连接SYN队列大小，值越大可建立的TCP连接数越多（默认值：2048）
```bash
$ sysctl net.ipv4.tcp_max_syn_backlog                                   # 查看TCP连接SYN队列大小

$ echo 'net.ipv4.tcp_max_syn_backlog = 4096' >> /etc/sysctl.conf        # 修改TCP连接SYN队列大小
```

#### 网络设备的收发包的队列大小（默认值：1000）
```bash
$ sysctl net.core.netdev_max_backlog                                    # 网络设备的收发包的队列大小

$ echo 'net.core.netdev_max_backlog = 2048' >> /etc/sysctl.conf         # 修改网络设备的收发包的队列大小
```

#### TCP SYN Cookies，防范DDOS攻击，防止SYN队列被占满，建议使用默认值（默认值：1）
```bash
$ sysctl net.ipv4.tcp_syncookies                                        # 查看 TCP SYN Cookies

$ echo 'net.ipv4.tcp_syncookies = 1' >> /etc/sysctl.conf                # 修改 TCP SYN Cookies
```
