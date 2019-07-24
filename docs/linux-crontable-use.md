#### 一、Crontab表达式语法简要说明（注意：Linux Crontab最小单位是分钟）
```bash
分钟（0-59）    小时（0-23）    日期（1-31）    月份（1-12）    星期（0-6）    年份（可选，就是可以不填）  
    *            *          *          *          *              *
-----------------------------------------------------------------------------------------
*（代表所有可能的值）
,（多个值以逗号隔开。比如在月份那个位置上写上 1,6 就是每年的1月和6月执行）   
-（定义范围。比如在月份那个位置上写上 1-6 就是每年的1到6月执行）
/（执行间隔时间。比如在分钟那个位置上写上 */6 就是每隔6分钟执行一次）
```

#### 二、Crontab服务启动和关闭（注意：Crontab服务是Linux默认安装和启动的。Crontab服务是分系统调度（只能root用户使用）和用户调度的，系统调度的配置文件是 /etc/crontab文件，用户调度的配置都在 /var/spool/cron目录）
```bash
$ systemctl start crond.service                # 启动  Crontab服务
$ systemctl stop crond.service                 # 停止  Crontab服务
$ systemctl restart crond.service              # 重启  Crontab服务
$ systemctl status crond.service               # 查看  Crontab服务状态信息
$ systemctl reload crond.service               # 重新加载 Crontab 服务配置信息
```

#### 三、Crontab服务命令简要说明
```bash
$ crontab -help                                # 查看 Crontab服务使用帮助
$ crontab -e 　                                                                                       # 创建一个定时任务（注意：这个命令执行后，会进入编辑状态，输入Crontab表达式和要执行的命令即可）
$ crontab -l                                   # 列出该当前用户所有的定时任务
$ crontab -u<用户名称> 　                                                              #  列出指定用户所有的定时任务
$ crontab -r                                   # 删除当前用户所有的定时任务
```

#### 四、测试创建[crontab -e]一个定时任务（任务说明：每隔1分钟往/home/crontab_test.log文件，写入 "测试测试"）
```bash
*/1 * * * * echo "测试测试" >> /home/crontab_test.log
```

#### 五、测试创建[crontab -e]一个定时任务，去执行某个脚本（任务说明：每隔1分钟执行一次/home/xtrabackup-all.sh脚本，将脚本执行的正常日志和错误日志打印到/home/xtrabackup-all.log文件）
```bash
*/1 * * * * /home/xtrabackup-all.sh > /home/xtrabackup-all.log 2>&1
```