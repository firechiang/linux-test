#!/bin/bash
#
this_pid=$$
function is_nginx_running
{
    ps -ef | grep nginx | grep -v grep | grep -v $this_pid &> /dev/null
    if [ $? -eq 0 ];then
        # 返回0（注意：return 可以不写）
        return 0
    else
        # 返回0（注意：return 可以不写）
        return 1
    fi        
}
# 调用函数
is_nginx_running && echo "Nginx正在运行" || echo "Nginx 已经停了"
