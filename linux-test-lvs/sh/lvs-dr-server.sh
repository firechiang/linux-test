#!/bin/bash
# lvs-dr-server服务必须在2，3，4，5运行级下被启动或关闭，启动的优先级是80，关闭的优先级是93
#chkconfig: 2345 80 93
#description: this script to start lvs server for the server
#version: 1.0
#setting variable
# 虚拟IP（注意修改，最好和Keepalived的虚拟IP相同，以达到高可用）
VIP=192.168.83.100
# 数据出栈网卡名称（注意修改，可使用ifconfig命令查看）
NETWORK_IN_NAME=ens33
# 数据入栈子网卡的序号（注意修改，3这个值可以随便起，不要重复即可）
NETWORK_OUT_INDEX=3
# LVS绑定端口
BIN_PORT=8080
# 代理转发端口（注意修改，后端真实服务器端口）
FORWARD_PORT=8080
# 代理转发服务器地址（注意修改，后端真实服务器IP地址）
RIP=(
    192.168.83.144
    192.168.83.145
)
# 负载均衡模式（注意修改，默认是wlc（rr表示轮询，lc表示最少连接，wlc表示加权最小连接，sed表示最短期望延迟，LBLC基于本地的最少连接））
LOAD_BALANCE=rr
#functions
start(){
    ifconfig | grep $VIP >/dev/null 2>&1
    if [ $? -eq 0 ];then
        echo "LVS server program  already start"
        exit 0
    fi
    # 添加虚拟IP（24是指虚拟IP的掩码是 255.255.255.0）
    ifconfig ${NETWORK_IN_NAME}:${NETWORK_OUT_INDEX} ${VIP}/24 up
    # 开启IP数据包转发（0不开启，1开启。默认是0）
    echo "1" > /proc/sys/net/ipv4/ip_forward
    # 添加LVS服务，以供客户端访问
    ipvsadm -A -t ${VIP}:${BIN_PORT} -s ${LOAD_BALANCE}
    # 循环添加转发规则
    for((i=0;i<${#RIP[*]};i++))
    do
        ipvsadm -a -t ${VIP}:${BIN_PORT} -r ${RIP[$i]}:${FORWARD_PORT} -g -w 1
    done
}
stop(){
    ifconfig | grep $VIP >/dev/null 2>&1
    if [ $? -gt 0 ];then
        echo "LVS server program already stop"
        exit 1
    fi
    # 循环删除转发规则
    for((i=0;i<${#RIP[*]};i++))
    do
        ipvsadm -d -t ${VIP}:${BIN_PORT} -r ${RIP[$i]}:${FORWARD_PORT}
    done
    # 删除LVS服务，以禁止客户端访问
    ipvsadm -D -t ${VIP}:${BIN_PORT}
    # 删除虚拟IP
    ifconfig ${NETWORK_IN_NAME}:${NETWORK_OUT_INDEX} ${VIP} down
    # 关闭IP数据包转发（0不开启，1开启。默认是0）
    echo "0" > /proc/sys/net/ipv4/ip_forward
}
#loop setting
case $1 in
start)
    start
    if [ $? -eq 0 ];then
        echo "LVS server program starting successful" /bin/true
    else
        echo "LVS server program starting successful" /bin/false
    fi
;;
stop)
    stop
    if [ $? -eq 0 ];then
        echo "LVS server program stoping successful" /bin/true
    else
        echo "LVS server program stoping successful" /bin/false
    fi
;;
status)
    ifconfig | grep $VIP >/dev/null 2>&1
    if [ $? -eq 0 ];then
        echo "LVS server program is startd"
    else
        echo "LVS server program is stopd"
    fi
;;
restart)
    stop && { echo "LVS server program stoping successful" /bin/true ||
          echo "LVS server program stoping failed" /bin/false
        }
    start&& { echo "LVS server program starting successful" /bin/true ||
          echo "LVS server program starting failed" /bin/false
        }
;;
*)
    echo "Usage:$0 {start|stop|restart|status}"
;;
esac