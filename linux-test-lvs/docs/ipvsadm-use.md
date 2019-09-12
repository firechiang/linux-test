#### 一、在LVS代理服务器上安装LVS管理工具Ipvsadm
```bash
$ yum install ipvsadm
```

#### 二、在LVS代理服务器上配置LVS虚拟IP和开启IP数据包转发
```bash
# 查看网卡和IP信息
$ ifconfig

# 配置虚拟IP
# 注意1：ens33是网卡不能错，:3可以随便起只要不重复即可，ip最好和当前机器ip处于同一网段，但不要使用已使用的IP
# 注意2：/24是指虚拟IP 192.168.83.100的掩码是 255.255.255.0
$ ifconfig ens33:3 192.168.83.100/24

# 开启IP数据包转发（0不开启，1开启。默认是0）
$ echo "1" > /proc/sys/net/ipv4/ip_forward
# 永久开启IP数据包转发，服务器重启也生效
$ echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
```

#### 三、在所有被代理的服务器上配置请求响应级别和数据包出栈的虚拟IP地址（注意：以下命令在所有被代理的服务器上执行）
```bash
# 配置请求响应级别，默认是 0 （0 只要本地配置有相应的地址，就给予响应。1 仅在请求的目标（MAC）地址，到达本机接口对应的地址上（因为可能有多个地址），才给予响应）
# 注意：ens33是当前机器的网卡名称，可以使用ifconfig命令查看。all是指所有网卡
$ echo 1 > /proc/sys/net/ipv4/conf/ens33/arp_ignore && \
  echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore
# 永久修改请求响应级别
$ echo 'net.ipv4.conf.ens33.arp_ignore = 1' >> /etc/sysctl.conf && \
  echo 'net.ipv4.conf.all.arp_ignore = 1' >> /etc/sysctl.conf

# 配置自己的地址向外通告的级别，默认是0（注意：ens33是当前机器的网卡名称，可以使用ifconfig命令查看。all是指所有网卡）
# 0 本地任何接口上的任何地址向外通告
# 1 试图仅向目标网络通告与其网络匹配的地址
# 2 仅向与本地接口上地址匹配的网络进行通告
$ echo 2 > /proc/sys/net/ipv4/conf/ens33/arp_announce && \
  echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce
# 永久修改自己的地址向外通告的级别
$ echo 'net.ipv4.conf.ens33.arp_announce = 2' >> /etc/sysctl.conf && \
  echo 'net.ipv4.conf.all.arp_announce = 2' >> /etc/sysctl.conf

# 查看网卡和IP信息
$ ifconfig

# 配置数据包出栈的虚拟IP地址，lo表示出栈（可使用ifconfig命令查看），8这个值可以随便起，不要重复即可
# 注意1：这个虚拟IP一定要和LVS的虚拟IP相同，因为数据入栈的IP是LVS的虚拟IP，出栈也要是这个，否则客户端无法接受到数据
# 注意2：数据出栈的虚拟IP的掩码 255.255.255.255 不能和LVS的虚拟IP的掩码相同，否则数据无法出栈，会形成一个死循环
# 注意3：一定要执行完上面的命令之后才执行这个命令，因为这个命令执行完成以后，这条虚拟IP信息就会根据上面配置的级别广播出去
$ ifconfig lo:8 192.168.83.100 netmask 255.255.255.255
```


#### 四、在LVS代理服务器上配置监听地址和端口（注意：配置监听地址和端口就是配置客户端访问的地址和端口）
```bash
# 添加监听地址和端口命令说明
# [-A|-E|-D] -A表示添加监听端口信息，-E 表示修改监听端口的信息，-D 表示删除监听端口信息
# [-t|-u|-f] -t表示tcp协议，-u表示udp协议，-f表示FWM防火墙标记，
# hostname:port 表示监听的地址和端口
# [-s scheduler] -s表示指定负载均衡模式，默认是wlc（rr表示轮询，lc表示最少连接，wlc表示加权最小连接，sed表示最短期望延迟，LBLC基于本地的最少连接）
# ipvsadm [-A|-E|-D] [-t|-u|-f] hostname:port [-s scheduler]

# 添加监听端口
$ ipvsadm -A -t 192.168.83.100:8080 -s rr

# 修改监听端口的负载均衡模式（注意：修改也只能修改负载均衡模式）
$ ipvsadm -E -t 192.168.83.100:8080 -s lc

# 删除监听端口（注意：删除不需要指定负载均衡模式）
$ ipvsadm -D -t 192.168.83.100:8080

# 查看所有的监听端口信息
$ ipvsadm -Ln
```

#### 五、在LVS代理服务器上配置转发规则
```bash
# 配置转发规则命令说明
# [-a|-e|-d] -a 表示转发规则信息，-e 表示修改转发规则信息，-d 表示删除转发规则信息
# [-t|-u|-f] -t 表示tcp协议，-u 表示udp协议，-f 表示FWM防火墙标记，
# server:port 表示LVS监听的地址和端口
# [-r service:port] -r表示指定要代理的服务地址和端口
# [-g|-i|-m] -g表示DR转发模型（效率好，推荐使用），-m表示NAT模型，-i表示TUNNEL模型，
# [-w 1] -w表示指定权重值，默认值1
# ipvsadm [-a|-e|-d] [-t|-u|-f] server:port [-r service:port] [-g|-i|-m] [-w 1]

# 添加转发规则（注意：LVS监听的地址和端口一定要先添加好，否则会报错）
$ ipvsadm -a -t 192.168.83.100:8080 -r 192.168.83.144:8080 -g -w 1
$ ipvsadm -a -t 192.168.83.100:8080 -r 192.168.83.145:8080 -g -w 1

# 修改转发规则（注意：修改也只能修改权重和转发模型）
$ ipvsadm -e -t 192.168.83.100:8080 -r 192.168.83.144:8080 -g -w 10

# 修改转发规则（注意：删除不需要指定权重和转发模型）
$ ipvsadm -d -t 192.168.83.100:8080 -r 192.168.83.144:8080

# 查看所有转发规则信息
$ ipvsadm -ln

# 查看所有连接转发的信息
$ ipvsadm -lnc

# 查看所有请求的连接信息（注意：在LVS服务器上应该所是没有请求连接信息的，所有的请求连接信息应该在目标服务器上）
$ netstat -natp
```
