#!/bin/bash

str="The Apache Hadoop software library is a framework Hadoop that allows for the Hadoop distributed processing of large data sets across"

# 使用帮助
function print_tips 
{
    echo "*******************************"
    echo "(1)打印str的长度"
    echo "(2)删除字符串中所有的Hadoop"
    echo "(3)替换第一个Hadoop为Mapreduce"
    echo "(4)替换全部Hadoop为Mapreduce"
    echo "(q)退出程序"
    echo "*******************************"
}

# 打印str的长度
function print_str_length 
{
    echo ${#str}
}

# 删除字符串str当中的所有Hadoop
function print_del_hadoop
{
    echo ${str//Hadoop/''}
}

# 替换第一个Hadoop为Mapreduce
function print_replace_m
{
    echo ${str/Hadoop/Mapreduce}
}

# 替换全部Hadoop为Mapreduce
function print_replace_m_all
{
    echo ${str//Hadoop/Mapreduce}
}

# 死循环
while true
	do
	    echo "[str=$str]"
	    echo 
	    # 执行函数
	    print_tips
	    # 将命令行输入的值，赋给choice变量
	    read -p "请输入对应的数字（1|2|3|4|[q|Q]）：" choice
	    
	    case $choice in
	        1)
	            print_str_length
	            ;;
	        2)
	            print_del_hadoop
	            ;;
	        3)
	            print_replace_m
	            ;;
	        4)
	            print_replace_m_all
	            ;;   
	        q|Q)
	            exit
	            ;; 
	        *)
	            echo "输入错误"
	            ;; 
	    esac        
	      
	done
