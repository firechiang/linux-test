#### 一、创建[vi /home/lesson/9.1/app-status.sh]进程管理脚本（注意：这个脚本其实就是把你想要管理状态的进程写到配置文件里面，然后脚本读取配置文件，输出进程相关信息）
```bash
#!/bin/bash
#
# 程序主目录
home_dir="/home/lesson/9.1"
# 配置文件名称
config_file="process.cfg"
# 当前脚本执行时的pid（定义在这个，主要原因是下面要过滤掉它）
this_pid=$$
# 获取 process.cfg 配置文件里面获取所有的进程组
function get_all_group
{
    # 匹配process.cfg文件里面以[开头，后面跟0个或多个任意任意字符，最后以]结尾的数据，再将 [] 替换掉
    echo `sed -n '/\[.*\]/p' ${home_dir}/${config_file} | sed -n -e 's/\[//g' -e 's/\]//g;p'`
}

# 获取 process.cfg 配置文件里面获取所有的进程
function get_all_process
{
    for g in `get_all_group`;
    do
        # 匹配 process.cfg 文件里面以[.*]到下一个[.*]结尾的数据，再将 带[.*]标签和空行的数据替换掉（注意：^$ 是过滤空行）
        # 注意：每循环一次都会将结果放到echo栈里面，最后全部返回
        echo `sed -n "/\[${g}\]/,/\[.*\]/p" ${home_dir}/${config_file} | egrep -v "(^$|\[.*\])"`
    done
}

# 根据进程名称获取进程pid
function get_process_pid_by_name
{
    # 如果参数的个数不是1
    if [ $# -ne 1 ];then
        # 非正常返回
        return 1
    fi
    # $0 表示执行当前脚本的命令（注意等号两边不要加空格，否则报错）
    pids=`ps -ef | grep $1 | grep -v grep | grep -v $this_pid | grep -v $0 | awk '{print $2}'`
    echo $pids
}

# 根据进程pid获取进程相关信息
function get_process_info_by_pid
{
    # 如果进程存在
    if [ `ps -ef | awk -v pid=$1 '$2==pid {print}' | wc -l` -eq 1 ];then
        # 进程运行状态
        pro_status="RUNNING"
        # cpu占用率
        pro_cpu=`ps -aux | awk -v pid=$1 '$2==pid {print $3}'`
        # 内存占用率
        pro_mem=`ps -aux | awk -v pid=$1 '$2==pid {print $4}'`
        # 进程启动时间
        pro_start_time=`ps -p $1 -o lstart | grep -v STARTED`
    fi
}

# 根据进程组判断该组是否在配置文件里面
function is_group_in_config
{
    for g in `get_all_group`;do
        if [ "$g" == "$1" ];then
            return
        fi
    done
    return 1
}

# 根据进程组名称获取组里面的所有进程名称
function get_process_by_group
{
    is_group_in_config $1
    # $? 表示上面函数的返回结果
    if [ $? -eq 1 ];then
        echo "进程组 $1 不在配置文件 ${home_dir}/${config_file}里面"
    fi
    # 找到配置文件里面进程组下面的所有进程名称（注意：^$ 是过滤空行，^# 是过滤以#号开头的行，\[.*\]表示过滤掉带中括号的数据）
    p_list=`sed -n "/\[$1\]/,/\[.*\]/p" ${home_dir}/${config_file} | egrep -v "(^$|^#|\[.*\])"`
    echo $p_list
}

# 根据进程名称获取进程组名称
function get_group_by_process_name
{
    # 遍历所有的进程组
    for gn in `get_all_group`;do
        # 遍历根据进程组名称获取到的所有进程名称
        for pn in `get_process_by_group $gn`;do
            if [ "$1" == "$pn" ];then
                echo "$gn"
            fi
        done
    done
}

# 格式化输出进程信息（接收两个参数）
function print_process_info
{
    # 判断进程名称手否存在（注意：$0 表示执行当前脚本的命令）
    ps -ef | grep $1 | grep -v grep | grep -v $this_pid | grep -v $0 &> /dev/null
    # 如果进程存在（注意：$?表示上面的命令运行结果）
    if [ $? -eq 0 ];then
        # 遍历根据进程名称获取pid列表 
        for pid in `get_process_pid_by_name $1`;do
            # 根据pid获取进程相关信息（注意：这个函数调完以后相关的变量会赋值）
            get_process_info_by_pid $pid
            # 打印输出信息
            awk -v pon="$1" -v pog="$2" -v pid="$pid" -v pos="$pro_status" -v poc="$pro_cpu" -v pom="$pro_mem" -v post="$pro_start_time" \
                'BEGIN{printf "%-20s%-10s%-10s%-10s%-10s%-10s%-15s\n",pon,pog,pos,pid,poc,pom,post}'
        done
    # 如果进程不存在
    else
        # 打印输出信息
        awk -v pon="$1" -v pog="$2" -v pos="STOPED" 'BEGIN{printf "%-20s%-10s%-10s%-10s%-10s%-10s%-15s\n",pon,pog,pos,"NULL","0.0","0.0","NULL"}'
    fi
}

if [ ! -e $home_dir/$config_file ];then
    echo "${home_dir}/${config_file} 配置文件不存在"
    exit 1
fi

awk 'BEGIN{printf "%-16s%-7s%-6s%-8s%-8s%-6s%-14s\n","进程名称","进程组","进程状态","进程PID","CPU占用","内存占用","进程启动时间"}'

# 如果参数的个数大于零
if [ $# -gt 0 ];then
    # 如果第一个参数是-g
    if [ "$1" == "-g" ];then
        # 注意：这个代码的意思是将第一个参数移除（就是把-g移除）
        shift
    fi
    # 遍历所有参数，就是进程组名（注意：这个里面是不包含-g的）
    for gn in $@;do
        is_group_in_config $1
	     # 如果进程组在我们的配置文件里面（$? 表示上面函数的返回结果）
	     if [ $? -eq 0 ];then
	         # 遍历根据进程组名称获取到的子进程名称
	         for pn in `get_process_by_group $gn`;do
	             print_process_info $pn $gn
	         done
	     fi
    done
# 如果参数的个数等于零
else
	# 遍历配置文件里面的所有进程名称
	for pn in `get_all_process`;do
	    print_process_info $pn `get_group_by_process_name $pn`
	done
fi
```

#### 二、创建[vi /home/lesson/9.1/process.cfg]进程管理配置文件
```bash
[HADOOP]
YARN
namenode
datanode

[WEB]
httpd
nginx
[SYS]
UnixLauncher
```

#### 三、测试进程状态管理脚本（注意：这个脚本其实就是把你想要管理状态的进程写到配置文件里面，然后脚本读取配置文件，输出进程相关信息）
```bash
$ cd /home/lesson/9.1

# 查看配置文件里面所有进程的状态
$ ./app-status.sh

# 查看配置文件里面SYS进程组下所有子进程的状态
$ ./app-status.sh -g SYS

# 查看配置文件里面SYS和HADOOP进程组下所有子进程的状态
$ ./app-status.sh -g SYS HADOOP
```