#!/bin/bash
# 
read -p "请输入要运算的第一个数值" num1
read -p "请输入要运算的第二个数值" num2

# scale 是指定小数点的精度
num3=`echo "scale=3;$num1 / $num2" | bc`
echo "计算结果：$num3"