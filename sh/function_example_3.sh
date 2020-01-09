#!/bin/bash
#
this_pid=$$

function get_users
{
    # 先获取到/etc/passwd里面的所有数据，再通过:号进行行分割，再获取每一行分割后的第一个位置的数据
    users=`cat /etc/passwd | cut -d: -f1`
    # 返回数据
    echo $users
}
# 调用函数，并获取返回值
user_list=`get_users`

index=0
size=1
for u in $user_list
do
    index=`expr $index + $size`
    # 打印所有的用户
    echo "第$index用户是：$u"
done