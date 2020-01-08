#!/bin/bash
#
while true
do
	# 将命令行输入的值，赋给变量 num （注意：-p 是指定输入提示）
	read -p "请输入一个正整数：" num
	
	# 将命令行输入的值加1，结果重定向到/dev/null（注意：如果命令行输入的不是整数，加1是会报错的）
	expr $num + 1 &> /dev/null
	
	# $? 是上一条命令的执行结果（成功是 0 失败为非0）
	if [ $? -eq 0 ];then
	    # num大于0表示正整数
	    if [ `expr $num \> 0` -eq 1 ];then
	        for((i=1;i<=$num;i++))
	        do
	            res=`expr $res + $i`
	        done
	        # 输出最后的结果
	        echo "1+2+3...+$num = $res"
	        # 退出程序
	        exit
	    fi
	fi
    echo "输入数值非法，请重新输入"
    # 退出当次循环
done