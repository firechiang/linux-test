```bash
$ sysctl fs.file-max                                  # 查看系统所有进程一共可以打开的文件数量
$ echo 'fs.file-max=2000000' >> /etc/sysctl.conf      # 修改系统所有进程一共可以打开的文件数量，一般为内存大小（KB）的10%来计算（系统的限制，并不是针对用户）

$ sysctl fs.aio-max-nr                                # 查看同时拥有异步I/O请求的数目
$ echo 'fs.aio-max-nr = 1048576' >> /etc/sysctl.conf  # 修改同时拥有异步I/O请求的数目，Oracle推荐的值为1048576（1024×1024），也就是1024Kb个

$ sysctl fs.nr_open                                   # 查看单个进程最多同时打开的文件句柄数量
$ echo 'fs.nr_open = 1048576' >> /etc/sysctl.conf     # 修改单个进程最多同时打开的文件句柄数量（建议使用默认值）

# 查询文件句柄数信息(这个只能做查询)，三个值，分别是：系统中已分配的文件句柄数量，已分配但没有使用的文件句柄数量，最大的文件句柄号
$ sysctl fs.file-nr    

# 查看所有文件句柄数描述信息
$ ulimit -a                                                              
```