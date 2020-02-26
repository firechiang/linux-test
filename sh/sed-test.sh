#!/bin/bash

FILE_NAME=/home/grep/my.conf
# 获取所有的段
function get_all_segment
{
    # 打印输出/home/grep/my.conf文件里面以[开头，后面跟0个或多个任意任意字符，最后以]结尾的数据,再将数据里面的 [] 替换掉，再输出（注意：\ 表示转义）
    echo "`sed -n '/\[.*\]/p' $FILE_NAME  | sed -n -e 's/\[//g' -e 's/\]//g;p'`"
}

# 统计每个段的行数
function count_items_in_segment
{
    # 输出/home/grep/my.conf文件里面从$1参数值开始到以[.*]正则表达式匹配到的字符串结束
    # 再过滤掉以#号开头的行
    # 再过滤掉空行
    # 再过滤掉以[.*]正则表达式匹配到的字符串
    # 最后统计匹配到的行数
    count="`sed -n '/\['$1'\]/,/\[.*\]/p' $FILE_NAME | grep -v ^# | grep -v '^\s*$' | grep -v '\[.*\]' | grep -c '.*'`"
    echo $1 $count
}
# 循环迭代get_all_segment函数所返回的每一行数据
for seg in `get_all_segment`
do
    # 调用 count_items_in_segment 函数，统计每个段落的行数
    count_items_in_segment $seg
done