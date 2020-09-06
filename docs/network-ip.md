#### 一、使用ifconfi命令所看到的网卡说明（注意：这个命令可能需要安装 net-tools 工具才能使用）
```bash
# ens33（入网（就是想要访问这台机器就需要经过这个网卡）网卡名称，ens一般代表以太网（就是网线网卡））
# inet（ipv4的IP地址），netmask（子网掩码），broadcast（子网广播地址，注意：一般网段最大的那个就是广播地址，当然也有可能不是）
# inet6（ipv6的IP地址）
# ether（网卡物理地址（就是我们常说的MAC地址））
ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.229.141  netmask 255.255.255.0  broadcast 192.168.229.255
        inet6 fe80::bb56:6856:e4ba:7384  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:07:05:86  txqueuelen 1000  (Ethernet)
        RX packets 9317  bytes 12284813 (11.7 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 2351  bytes 199229 (194.5 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
# lo（出网（就是数据要重这台机器出去就需要经过这个网卡）网卡名称）
# inet（ipv4的IP地址），netmask（子网掩码）
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 32  bytes 2592 (2.5 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 32  bytes 2592 (2.5 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

#### 二、使用 more /etc/sysconfig/network-scripts/ifcfg-ens33 命令查看网卡配置文件信息说明以及固定IP配置
```bash
TYPE="Ethernet"                                 # 以太网（就是网线网口），当然还有其它类型
PROXY_METHOD="none"                             # 代理方式（none=关闭状态）
BROWSER_ONLY="no"                               # 是否只是浏览
BOOTPROTO="dhcp"                                # 是否自动获取IP（none=自动获取，static=自定义IP，dhcp=通过dhcp自动获取IP）
DEFROUTE="yes"                                  # 是否默认路由
IPV4_FAILURE_FATAL="no"                         # 是否开启IPV4致命错误检测
IPV6INIT="yes"                                  # IPV6是否自动初始化
IPV6_AUTOCONF="yes"                             # IPV6是否自动配置
IPV6_DEFROUTE="yes"                             # IPV6是否使用默认路由
IPV6_FAILURE_FATAL="no"                         # 是否开启IPV6致命错误检测
IPV6_ADDR_GEN_MODE="stable-privacy"             # IPV6地址生成模型：stable-privacy [这只一种生成IPV6的策略]
NAME="ens33"                                    # 网卡物理设备名称
UUID="f4a92a89-39b0-4ffb-add7-7cbbdf99c23b"     # 唯一识别码
DEVICE="ens33"                                  # 网卡设备名称（必须和  NAME 值一样）
ONBOOT="yes"                                    # 是否随网络服务启动（就是是否开机启动）

# 固定IP相关配置（注意：要把上面的BOOTPROTO配置成static）
# 虚拟机配置桥接网络只要将NETMASK（子网掩码），GATEWAY（默认网关），DNS（域名解析）和宿主机配置相同即可，当然固定IP须在同一网段
IPADDR="172.20.10.10"                           # 固定IP（注意：不要和 broadcast 子网广播地址一致）
NETMASK="255.255.255.240"                       # 子网掩码
GATEWAY="172.20.10.1"                           # 默认网关（一般都是IP段的第一个，也可以不配置（如果是虚拟器配置桥接网络就要配置））
DNS1="172.20.10.1"                              # DNS（一般和网关一致）

# 重启网络服务使固定IP生效
$ service network restart                      
```

#### 三、使用ifconfig临时添加虚拟网卡和修改IP，机器重启就没有了（注意：一台机器上有多个网卡一般只能一个网卡起作用，要都启作用需要额外配置）
```bash
# 修改网卡ens33的IP和子网掩码，子网掩码可以不写会默认配置（注意：这个命令不要轻易使用，因为它直接把IP改了）
$ ifconfig ens33 192.168.229.141 netmask 255.255.255.0

# 虚拟一个网卡名称叫ens33:0，IP是192.168.230.141，子网掩码可以不写会默认配置
$ ifconfig ens33:0 192.168.230.141

# 删除虚拟网卡ens33:0
$ ifconfig ens33:0 down
```

#### 四、查看机器网络详细信息和修改DNS服务器地址
```bash
$ nmcli conn show -a                            # 获取机器网卡信息
$ nmcli conn show chiang-fire                   # 查看chiang-fire详细的网络信息，包括IP，网关，DNS，子网掩码等信息（注意：chiang-fire可使用（nmcli conn show -a）命令获取，取NAME字段）

$ more /etc/resolv.conf                         # 单独查看所有的DNS服务地址
$ vi /etc/resolv.conf                           # 修改DNS服务地址

$ ip route show                                 # 单独查看网关地址
```
