#### [LVS DR转发模型常规搭建和使用（推荐测试使用，且里面有各个参数说明）][1]
#### [LVS DR转发模型脚本搭建和使用（推荐生产使用）][2]
#### [LVS 加 Keepalived 高可用搭建和使用（推荐生产使用）][3]

#### LVS（Linux Virtual Server）组成部分
 - Ipvs 工作在内核空间，实现集群服务的调度；借鉴了iptables实现
 - Ipvsadm 工作在用户空间，负责为ipvs内核框架编写规则，定义谁是集群服务，谁是后端服务（就是管理工具）
 
#### LVS（Linux Virtual Server）转发模型
 - NAT模型：数据入栈时修改目标IP地址为后端实际服务器的IP地址，数据出栈时修改源IP地址为客户端IP地址。这种模式因为数据出入栈都要经过LVS所以在大并发场景下存在性能瓶颈，故不推荐使用
 - DR模型：数据入栈修改目标MAC地址为后端实际服务器的MAC地址，数据出栈直接由后端实际服务器返回。这种方式效率高推荐生产使用（注意：LVS Server和被代理服务器必须在同一个网段，否则无法使用LVS转发）
 - TUNNEL：隧道模式（就是数据包套着数据包，里面的那个数据包才是真实的数据包和目的地）较少使用，常用于异地容灾
 
#### LVS（Linux Virtual Server）相关术语
 - Director Server LVS服务器，即负载均衡器
 - Real Server 真实服务器，即后端服务器
 - VIP 直接面向用户的IP地址，通常为公网IP地址
 - Director Server IP 主要用于和内部主机通信的IP地址
 - Client IP 客户端IP，就是发起请求的IP地址
 
#### OSI七层网络模型说明（注意：1-7是数据解码过程，7-1是数据编码过程）
 - 1，物理层（Physical）：建立，维护，断开物理连接
 - 2，数据链路层（Data Link）：建立逻辑连接，进行硬件地址寻址，差错校验（就是MAC地址寻址）
 - 3，网络层（NetWork）：进行逻辑地址寻址，实现不同网络之间的路径选择（就是IP地址寻址）
 - 4，传输层（Transport）：定义传输数据的协议和端口号（注意：协议一般是指TCP或UDP等，如果是TCP的话还会有流控和差错检验）
 - 5，会话层（Session）：远端主机建立连接和管理终止会话
 - 6，表示层（Presentation）：应用层所使用的数据表示形式，是否需要压缩，是否需要加密等等
 - 7，应用层（Application）：网络服务最终的应用程序
 ```bash
-----------------------|---------------------|------------------------------------------|
OSI七层网络模型         |  TCP/IP四层概念模型  |  对应的网络协议                           |
-----------------------|---------------------|------------------------------------------|
物理层（Physical）      |  数据链路层          |  IEEE 802.1A，IEEE 802.2 到 IEEE 802.11  |
                        |                     |------------------------------------------|
数据链路层（Data Link） |                     |  FDDI，Ethernet，Arpanet，PDN，SLIP，PPP  |
-----------------------|---------------------|------------------------------------------|
网络层（NetWork）       |  网络层             |  IP，ICMP，ARP，RARP，AKP，UUCP           |
-----------------------|---------------------|------------------------------------------|
传输层（Transport）     |  传输层             |  TCP，UDP                                |
-----------------------|---------------------|------------------------------------------|
会话层（Session）       |                     |  SMTP，DNS                               |
                        |                     |------------------------------------------| 
表示层（Presentation）  |  应用层              |  Telnet，Rlogin，SNMP，Gopher            |
                        |                     |------------------------------------------|
应用层（Application）   |                     |  HTTP，TFTP，FTP，NFS，WAIS，SMTP         |
-----------------------|---------------------|------------------------------------------|
 ```
#### TCP/IP分层协议模型
![object](https://github.com/firechiang/linux-test/blob/master/linux-test-lvs/image/tcp-ip.svg)
#### TCP三次握手简要
 - 第一次握手客户端向服务端发送syn请求建立连接报文而且会携带一个seq数值（seq=x）
 - 第二次握手服务端向客户端发送syn确认建立连接报文而且会携带seq和ack数值（seq=y，ack=客户端发来的seq数值加1），客户端检查ack值是否是加1以后的
 - 第三次握手客户端向服务端发送ack确认建立连接报文而且会携带一个ack数值（ack=服务端发来的seq数值加1），服务端检查ack值是否是加1以后的
![object](https://github.com/firechiang/linux-test/blob/master/linux-test-lvs/image/tcp-shake.svg)
#### TCP四次挥手简要（注意：挥手主要用于关闭连接）
![object](https://github.com/firechiang/linux-test/blob/master/linux-test-lvs/image/tcp-wave.svg)


[1]: https://github.com/firechiang/linux-test/tree/master/linux-test-lvs/docs/ipvsadm-use.md
[2]: https://github.com/firechiang/linux-test/tree/master/linux-test-lvs/sh
[3]: https://github.com/firechiang/linux-test/tree/master/linux-test-lvs/docs/keepalived-ipvsadm-use.md
