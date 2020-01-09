#!/bin/bash
#
function sys_load
{
    echo "内存使用信息"
    echo 
    free -m
    echo
    
    echo "磁盘使用信息"
    echo
    df -h
    echo
}

sys_load