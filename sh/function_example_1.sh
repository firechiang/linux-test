#!/bin/bash
#
function calcu
{
    # case 第二个参数的值
    case $2 in
            +)
	            echo "`expr $1 + $3`"
                ;;
            -)
	            echo "`expr $1 - $3`" 
                ;;
            # 这个 * 号 有问题，匹配不到    
            \*)
                echo "乘法"
                # \（反斜杠）表示转义    
	            echo "`expr $1 \* $3`"
                ;;
            /)
                echo "除法"
	            echo "`expr $1 / $3`"
                ;;
    esac
}
# 执行脚本立即执行calcu脚本
calcu $1 $2 $3
