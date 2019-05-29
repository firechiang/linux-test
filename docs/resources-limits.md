#### soft(警告限定)，hard(严格限定)，注意：软限制的值不能大于硬限制的值
```bash
$ ulimit -a                                                    # 查看所有资源限制

$ echo '* soft memlock unlimited' >> /etc/security/limits.conf # 允许程序最大锁定内存（unlimited=不限制）（警告限定）（谨慎修改，这个可以不修改）（查看默认值使用：ulimit -a 命令，找到 max locked memory 选项）
$ echo '* hard memlock unlimited' >> /etc/security/limits.conf # 允许程序最大锁定内存（unlimited=不限制）（严格限定），不限制（谨慎修改，这个可以不修改）（查看默认值使用：ulimit -a 命令，找到 max locked memory 选项）

$ echo '* soft nproc 10240' >> /etc/security/limits.conf       # 修改用户最大进程数（警告限定）（谨慎修改，这个可以不修改）（查看默认值使用：ulimit -a 命令，找到 max user processes 选项）
$ echo '* hard nproc 10240' >> /etc/security/limits.conf       # 修改用户最大进程数（严格限定）（谨慎修改，这个可以不修改）（查看默认值使用：ulimit -a 命令，找到 max user processes 选项）

$ echo 'admin soft cpu 1' >> /etc/security/limits.conf         # 限制admin用户使用一个CPU（警告限定）
$ echo 'admin hard cpu 1' >> /etc/security/limits.conf         # 限制admin用户使用一个CPU（严格限定）
```