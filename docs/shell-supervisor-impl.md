#### 
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
function get_app_process
{
    for g in `get_all_group`;
    do
        # 匹配 process.cfg 文件里面以[.*]到下一个[.*]结尾的数据，再将 带[.*]标签和空行的数据替换掉
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
    # 进程运行状态
    pro_status="STOPED"
    # cpu占用率
    pro_cpu="0.0"
    # 内存占用率
    pro_mem="0.0"
    # 进程启动时间
    pro_start_time="0.0"
    # 如果进程存在
    if [ `ps -ef | awk -v pid=$1 '$2==pid {print}' | wc -l` -eq 1 ];then
        pro_status="RUNNING"
        pro_cpu=`ps -aux | awk -v pid=$1 '$2==pid {print $3}'`
        pro_mem=`ps -aux | awk -v pid=$1 '$2==pid {print $4}'`
        pro_start_time=`ps -p $1 -o lstart | grep -v STARTED`
    fi
    echo $pro_status $pro_cpu $pro_mem $pro_start_time
}

# 根据进程名称获取进程相关信息
function get_process_info
{
    echo "1"
}


if [ ! -e $home_dir/$config_file ];then
    echo "${home_dir}/${config_file} 配置文件不存在"
    exit 1
fi

get_process_info_by_pid 6720
```