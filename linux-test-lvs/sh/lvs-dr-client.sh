#!/bin/bash
#description:this script to start lvs client for the server
#version:1.0
#setting variable
# 虚拟IP注意修改，而且要和LVS服务器的虚拟IP相同
VIP=192.168.83.100
#functions
start(){
    ifconfig | grep $VIP >/dev/null 2>&1
    if [ $? -eq 0 ];then
        echo "LVS client program  already start"
        exit 0
    fi
    # 注意：ens33是当前机器的网卡名称，注意修改，可以使用ifconfig命令查看。all是指所有网卡
    echo "1" > /proc/sys/net/ipv4/conf/ens33/arp_ignore
    echo "1" > /proc/sys/net/ipv4/conf/all/arp_ignore
    echo "2" > /proc/sys/net/ipv4/conf/ens33/arp_announce
    echo "2" > /proc/sys/net/ipv4/conf/all/arp_announce
    # 配置数据包出栈的虚拟IP地址，lo表示出栈（可使用ifconfig命令查看），8这个值可以随便起，不要重复即可
    # 注意：数据出栈的虚拟IP的掩码 255.255.255.255 不能和LVS的虚拟IP的掩码相同，否则数据无法出栈，会形成一个死循环
    ifconfig lo:8 $VIP netmask 255.255.255.255 up
}
stop(){
    ifconfig | grep $VIP >/dev/null 2>&1
    if [ $? -gt 0 ];then
        echo "LVS client program already stop"
        exit 1
    fi
    # 注意：ens33是当前机器的网卡名称，注意修改，可以使用ifconfig命令查看。all是指所有网卡
    echo "0" > /proc/sys/net/ipv4/conf/ens33/arp_ignore
    echo "0" > /proc/sys/net/ipv4/conf/all/arp_ignore
    echo "0" > /proc/sys/net/ipv4/conf/ens33/arp_announce
    echo "0" > /proc/sys/net/ipv4/conf/all/arp_announce
    # 清除数据包出栈的虚拟IP地址，lo表示出栈（可使用ifconfig命令查看），8这个值可以随便起，不要重复即可
    ifconfig lo:8 $VIP netmask 255.255.255.255 down
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