```bash
$ sysctl fs.file-max                                       # 查看系统所有进程一共可以打开的文件句柄数量
$ echo 'fs.file-max=2000000' >> /etc/sysctl.conf           # 修改系统所有进程一共可以打开的文件句柄数量，一般为内存大小（KB）的10%来计算（系统的限制，并不是针对用户）

$ sysctl fs.aio-max-nr                                     # 查看系统同时可以拥有的的异步IO请求数目
$ echo 'fs.aio-max-nr = 1048576' >> /etc/sysctl.conf       # 修改系统同时可以拥有的的异步IO请求数目，Oracle推荐的值为1048576（1024×1024），也就是1024Kb个

$ sysctl fs.nr_open                                        # 查看单进程最大打开文件句柄数量
$ echo 'fs.nr_open = 1048576' >> /etc/sysctl.conf          # 修改单进程最大打开文件句柄数量（进程限制）（建议使用默认值）


# 修改单进程最大打开网络连接文件句柄数量（注意：/etc/ssh/sshd_config 配置文件里面，须有 UsePAM yes 配置（这个配置一般默认都是有的），否则限制无法生效）
$ ulimit -n                                                # 查看单进程最大打开网络连接文件句柄数量
$ echo '* soft nofile 655350' >> /etc/security/limits.conf # 修改单进程（警告限定）最大打开网络连接文件句柄数量，不能大于 hard nofile（严格限定） 的值，建议值： 655350
$ echo '* hard nofile 655350' >> /etc/security/limits.conf # 修改单进程（严格限定）最大打开网络连接文件句柄数量，不能大于 fs.nr_open 的值

# 查询文件句柄数信息(这个只能做查询)，三个值，分别是：系统中已分配的文件句柄数量，已分配但没有使用的文件句柄数量，最大的文件句柄号
$ sysctl fs.file-nr    

# 查看所有文件句柄数描述信息
$ ulimit -a                                                              
```
