#!/bin/bash
# lvs-dr-client服务必须在2，3，4，5运行级下被启动或关闭，启动的优先级是80，关闭的优先级是93
#chkconfig: 2345 80 93
#description: this script to start lvs client for the server
#version: 1.0
#setting variable
# 虚拟IP（注意修改，而且要和LVS服务器的虚拟IP相同）
VIP=192.168.83.100
# 数据出栈的虚拟IP的掩码（注意修改，而且不能和LVS的虚拟IP的掩码相同，否则数据无法出栈，会形成一个死循环）
MASK=255.255.255.255
# 数据出栈网卡名称（注意修改，可使用ifconfig命令查看）
NETWORK_IN_NAME=ens33
# 数据入栈网卡名称（注意修改，可使用ifconfig命令查看）
NETWORK_OUT_NAME=lo
# 数据出栈子网卡的序号（注意修改，8这个值可以随便起，不要重复即可）
NETWORK_OUT_INDEX=8
#functions
start(){
    ifconfig | grep $VIP >/dev/null 2>&1
    if [ $? -eq 0 ];then
        echo "LVS client program  already start"
        exit 0
    fi
    echo "1" > /proc/sys/net/ipv4/conf/$NETWORK_NAME/arp_ignore
    echo "1" > /proc/sys/net/ipv4/conf/all/arp_ignore
    echo "2" > /proc/sys/net/ipv4/conf/$NETWORK_NAME/arp_announce
    echo "2" > /proc/sys/net/ipv4/conf/all/arp_announce
    ifconfig ${NETWORK_OUT_NAME}:${NETWORK_OUT_INDEX} $VIP netmask $MASK up
}
stop(){
    ifconfig | grep $VIP >/dev/null 2>&1
    if [ $? -gt 0 ];then
        echo "LVS client program already stop"
        exit 1
    fi
    echo "0" > /proc/sys/net/ipv4/conf/$NETWORK_NAME/arp_ignore
    echo "0" > /proc/sys/net/ipv4/conf/all/arp_ignore
    echo "0" > /proc/sys/net/ipv4/conf/$NETWORK_NAME/arp_announce
    echo "0" > /proc/sys/net/ipv4/conf/all/arp_announce
    ifconfig ${NETWORK_OUT_NAME}:${NETWORK_OUT_INDEX} $VIP netmask $MASK down
}
#loop setting
case $1 in
start)
    start
    if [ $? -eq 0 ];then
        echo "LVS client program starting successful" /bin/true
    else
        echo "LVS client program starting successful" /bin/false
    fi
;;
stop)
    stop
    if [ $? -eq 0 ];then
        echo "LVS client program stoping successful" /bin/true
    else
        echo "LVS client program stoping successful" /bin/false
    fi
;;
status)
    ifconfig | grep $VIP >/dev/null 2>&1
    if [ $? -eq 0 ];then
        echo "LVS client program is startd" 
    else
        echo "LVS client program is stopd"
    fi
;;
restart)
    stop && { echo "LVS client program stoping successful" /bin/true ||
          echo "LVS client program stoping failed" /bin/false
        } 
    start&& { echo "LVS client program starting successful" /bin/true ||
          echo "LVS client program starting failed" /bin/false
        } 
;;
*)
    echo "Usage:$0 {start|stop|restart|status}"
;;
esac