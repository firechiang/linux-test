#!/bin/bash
# $$ 表示获取当前脚本执行的子进程ID
this_pid=$$

while true
do
    sleep 3
	# grep -v grep 是过滤掉这个命令执行时所产生的进程，grep -v $this_pid 是过滤掉当前这个脚本执行时所产生的进程
	ps -ef | grep nginx | grep -v grep | grep -v $this_pid &> /dev/null
	
	# $? 是上一条命令的执行结果（成功是 0 失败为非0）
	if [ $? -eq 0 ];then
	    echo "nginx 正在执行"
	else
	    echo "nginx 宕了，正在重启。。。"
	fi
done