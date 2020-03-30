#### 一、[Shell编程][6]
#### 二、[网络连接参数优化(影响服务器连接数)][1]
#### 三、[系统文件句柄数量优化(影响服务器连接数)][2]
#### 四、[numa说明以及优化(影响CPU使用率)][3]
#### 五、[资源限制][4]
#### 六、[磁盘IO调度策略(影响程序读写效率)][5]
#### 七、[Linux Crontab（定时执行）使用和说明][7]
#### 八、[Shell脚本学习记录][8]
#### 九、[网络数据包防火墙iptables使用说明（注意：是Linux内核的iptables）][9]
#### 十、挂载新硬盘以及创建分区（注意：一块磁盘最多只能有4个分区，至少要有一个主分区，最多只能有一个扩展分区。主分区格式化之后就可以使用，扩展分区必须先划分逻辑分区，格式化所有的逻辑分区以后才能使用。主分区和扩展分区都可以安装系统。建议都创建主分区）
```bash
$ fdisk -l                               # 查看机器硬盘信息，找到新添加的硬盘名称
$ fdisk /dev/sdb                         # 管理磁盘

Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0x700dc500.

Command (m for help): n                  # 创建新的分区（n=创建新的分区，d=删除分区，p=列出分区列表，w=保存分区信息并退出，q=退出而不保存）
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p                    #（p=创建主分区，e=创建扩展分区）
Partition number (1-4, default 1): 1     # 当前磁盘的分区号（一块磁盘最多4个分区，所以最大是4，详情请看上面的注意事项）
First sector (2048-20971519, default 2048): 
Using default value 2048                 # 分区容量从磁盘容量的哪个位置开始
Last sector, +sectors or +size{K,M,G} (2048-20971519, default 20971519): 
Using default value 20971519             # 分区容量到磁盘容量的哪个位置结束
Partition 1 of type Linux and of size 10 GiB is set

Command (m for help): w                  # 保存分区信息并退出（n=创建新的分区，d=删除分区，p=列出分区列表，w=保存分区信息并退出，q=退出而不保存）
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.

$ fdisk -l                               # 查看机器硬盘信息，找到新添加的硬盘和分区名称
$ mkfs -t ext4 /dev/sdb1                 # 格式化新建分区（将新建分区/dev/sdb1格式化成ext4格式）

# 修改/etc/fstab文件，将磁盘分区/dev/sdb1，永久的挂载到/mnt/test_data目录，磁盘格式是ext4
# 注意：要重启机器才能生效（命令：reboot）
$ echo /dev/sdb1 /mnt/test_data ext4 defaults 0 0 >> /etc/fstab                       
```

#### 十一、修改时区（注意：建议系统安装时要设置好）
```bash
$ timedatectl list-timezones             # 查看系统所支持的所有时区
$ ls -l /etc/localtime                   # 查看系统当前时区
$ timedatectl set-timezone Asia/Shanghai # 修改为中国上海时区（注意：系统所支持的时区里面没有北京）
```

#### 十二、文件查找工具find简单使用
```bash
# -name                根据文件名查找
# -iname               根据文件名查找（忽略大小写）
# -perm                根据文件权限查找
# -prune               过滤掉某些目录（注意：这个要配合-path使用）
# -user                根据文件所属用户查找
# -group               根据文件所属组查找

# -nogroup             查找无有效属组的文件（一个组开始创建了很多文件，后来组被删除了，这些文件就是无有效属组的文件）
# -nouser              查找无有效属主的文件（一个用户开始创建了很多文件，后来用户被删除了，这些文件就是无有效属主的文件）
# -size                根据文件大小查找
# -mindepth n          从第n级子目录开始搜索
# -maxdepth n          最多查找到第n级目录

# -type f              根据文件类型查找（f=文件）
# -type d              根据文件类型查找（d=目录）
# -type c              根据文件类型查找（c=字符设备文件）
# -type b              根据文件类型查找（b=块设备文件）
# -type l              根据文件类型查找（l=链接文件）
# -type p              根据文件类型查找（p=管道文件）

# -print               打印查找后的结果（注意：这个参数是默认的）
# -exec                对查找后的结果进行其它命令操作

$ find / -name nginx                     # 从根目录开始查找nginx文件
$ find / -iname nginx                    # 从根目录开始查找nginx文件（忽略大小写）
$ find ./ -user root                     # 查找当前目录属于root用户的所有文件
$ find / -perm 776                       # 从根目录开始查找文件权限是777的文件

$ find ./ -type f                        # 查找当前目录下所有普通文件
$ find ./ -type d                        # 查找当前目录下所有文件夹

$ find ./ -size +1M                      # 查找当前目录大于lM的文件
$ find ./ -size -1M                      # 查找当前目录小于lM的文件
$ find ./ -size 1k                       # 查找当前目录等于lk的文件（注意：不能精确匹配大于等于1M（兆）的文件）

$ find -mtime -3                         # 查找3天之内修改过的所有文件
$ find -mtime +3                         # 查找3天之前修改过的所有文件
$ find -mtime 3                          # 查找修改天数等于3天的所有文件

$ find -mmin -3                          # 查找3分钟之内修改过的所有文件
$ find -mmin +3                          # 查找3分钟之前修改过的所有文件

$ find -mtime -3 -name '*.bd'            # 查找3天之内修改过，以bd结尾的所有文件
$ find -mtime +3 -user root              # 查找3天之前修改过，属于root的所有文件

# -o   表示或
# -a   表示与
# -not 表示非
# 从根目录开始查找*b文件，过滤掉/u目录下的所有文件和文件夹（-path /u -prune就是过滤/u目录，-o是并且的意思（就是后面的命令也会执行））
$ find / -path /u -prune -o -name *b  

# 从根目录开始查找*db文件，过滤掉/var和/usr目录下的所有文件和文件夹
$ find / -path /var -prune -o -path /usr -prune -o -name *db

# 查找当前目录比function_example_5.sh文件要新的文件
$ find ./ -newer function_example_5.sh

# -exec 查询结果后再执行其它操作
# -ok   查询结果后再执行其它操作（注意：这个在执行其它操作会有提示）
# 将查找到的文件再进行其它操作（这里是删除）{} 表示查找后的结果，\; 表示命令的结尾
$ find / -name test.db -exec rm -rf {} \;

# 将查找到的文件再进行其它操作（这里是复制）{} 表示查找后的结果，\; 表示命令的结尾
$ find ./test_fold -name '*.sh' -exec cp {} ./test_fold1 \;
```

#### 十三、文件查找工具locate命令简单使用，locate命令不是搜索整个磁盘而是搜索locate自带的数据库，数据库的信息会定时更新（注意：如果没有该命令请安装：yum install mlocate）（注意：不推荐使用）
 - locate自带的数据库信息文件：/var/lib/mlocate/mlocate.db
 - locate自带的数据库配置文件：/etc/updatedb.conf
 - locate命令在cron有定时任务定期执行
```bash
$ updatedb                               # 更新locate自带的数据信息
$ touch /home/test.db                    # 创建一个测试文件
$ locate test.db                         # 使用locate命令查找test.db文件所在目录（注意：应该是查不到的，因为locate数据库没有更新）
$ updatedb                               # 更新locate数据库
$ locate test.db                         # 再查找test.db文件，应该就有了
```

#### 十四、程序查找工具whereis命令简单使用
```bash
# -b 查找二进制文件
# -m 只返回帮助文档文件
# -s 只反回源代码文件
$ whereis mysql                          # 查找mysql程序所在文件目录 
$ whereis -b mysql                       # 查找mysql程序所在文件目录           
```

#### 十五、可执行程序查找工具which命令简单使用
```bash
# -b 只返回二进制文件
$ which mysql                            # 查找mysql可执行文件所在目录    
$ which -b mysql                         # 查找mysql可执行文件所在目录         
```

#### 十六、grep 和 egrep 过滤器简单使用
```bash
# 使用方法一：grep [option] [pattern] [file1,file2,..]
# 使用方法二：命令 | grep [option] [pattern] 
# option 包含以下值（注意：option 为可选参数）
# -v 不显示匹配行的信息（就是不高亮显示匹配信息）
# -i 搜索时忽略大小写
# -n 显示行号
# -r 递归搜索（当前目录下搜索所有文件）
# -E 支持扩展正则表达式
# -F 不按正则表达式匹配，按照字符串字面意思匹配
# -c 只显示匹配行的数量，不显示具体信息
# -w 匹配整词
# -x 匹配整行
# -l 只显示匹配的文件名，不显示具体匹配行的内容
$ grep -n 90 aaa                         # 查找 aaa 文件里面包含 90 的数据，并显示数据所在行号
$ grep -E "a | A" aaa                    # 查找 aaa 文件里面包含 a 或  A 的数据（因为 a | A 是扩展正则表达式，所以加了-E参数，也可以直接使用egrep）
$ grep -F "a.*" aaa                      # 查找 aaa 文件里面包含 a.* 的数据（因为 a.* 是正则表达式，但是我们要以字面意思匹配，所以加了-F 参数）
$ grep -r 90                             # 在当前目录下搜索所有文件，查找里面包含90的数据（注意：这个搜索结果里面会显示文件名）
$ netstat -ntlp | grep 25                # 查询netstat -ntlp命令结果数据包含25的数据
```

#### 十七、sed 文件流编辑器简单使用（修改删除文件里面的数据）（注意：sed命令处理是以文件里面的行为单位的，它是一行一行匹配处理的）
 - [sed 文件流编辑器的测试脚本，统计和过滤文件里面的段落（里面有删除注释行和空行）](https://github.com/firechiang/linux-test/tree/master/sh/sed-test.sh)
```bash
# 使用方法一：sed [option] "pattern command" file
# 使用方法二：命令 | sed [option] "pattern command"
# option 包含以下值（注意：option 为可选参数）
# -n 只打印模式匹配行（就是只打印，已有的数据，不会重复打印（默认是打印已有数据和匹配的数据，这样一行数据就会打印两次））
# -e 直接在命令行进行sed编辑（其实就是可以跟多个匹配）（这个也是默认选项）
# -f 编辑动作保存在文件中，指定文件执行（就是操作命令写在文件里面，指定一个文件里面有操作命令）
# -r 支持扩展正则表达式
# -i 直接修改文件内容

# pattern 用法（注意：command 表示命令，比如 p等；pattern 表示正则表达式）
# 10command                              # 匹配到第10行
# 10,20command                           # 匹配从第10行开始，到20行结束
# 10,+5command                           # 匹配从第10行开始，到16行结束
# /pattern1/command                      # 匹配到pattern1的行
# /pattern1/,/pattern2/command           # 匹配到pattern1开始，pattern2结束
# /pattern1/,$command                    # 匹配到pattern1开始，最后一行结束（注意：$ 表示最后一行）
# 10/pattern1/command                    # 匹配从第10行开始，到pattern1结束       
# /pattern1/10command                    # 匹配从pattern1开始，到第10行结束      

# command（命令） 包含以下值
# p 打印
# a 行后追加
# i 行前追加
# r 外部文件读入，行后追加
# w 匹配行写到外部文件
# d 删除
# = 打印行号
# s/pattern/string/                      # 将匹配到的pattern字符串修改成string（注意：这个只修改第一个）
# s/pattern/string/g                     # 将匹配到的pattern字符串修改成string（注意：这个是修改所有的）
# s/pattern/string/ig                    # 将匹配到的pattern字符串修改成string（注意：i 表示匹配时忽略大小写，这个是修改所有的）
# s/pattern/string/2g                    # 将匹配到的pattern字符串修改成string（注意：每一行，修改前两个）
# s/pattern/string/3g                    # 将匹配到的pattern字符串修改成string（注意：每一行，修改前三个）

$ sed -n 'p' aaa                         # 打印输出aaa文件里面的每一行（注意：'p' 就是打印输出的意思，-n 是只打印已有数据，不会重复打印）
$ sed -n '=;p' aaa                       # 打印输出aaa文件里面的每一行（注意：多个命令用分号隔开，'=' 表示显示行号的意思 ，p 表示打印输出，-n 是只打印已有数据，不会重复打印）
$ sed -n '2,5p' aaa                      # 打印输出aaa文件第2行到第5行的数据（注意：'p' 就是打印输出的意思，-n 是只打印已有数据，不会重复打印）
$ sed -n '/00000/ p' aaa                 # 打印输出aaa文件里面能匹配到00000的每一行数据（注意：/00000/ 表示正则表达式，'p' 就是打印输出的意思，-n 是只打印已有数据，不会重复打印）
$ sed -n -r '/aa|AA/ p' aaa              # 打印输出aaa文件里面能匹配到aa或AA的每一行数据（注意：'p' 就是打印输出的意思，-r 支持扩展正则表达式（aa|AA就是扩展的正则表达式），-n 是只打印已有数据，不会重复打印）
$ sed -n '/\[.*\]/p' aaa                 # 打印输出aaa文件里面以[开头，后面跟0个或多个任意任意字符，最后以]结尾的数据（注意：\ 表示转义）
$ sed -n -e '/00/ p' aaa -e '/30/ p' aaa # 对多个文件进行匹配搜索打印（-e 就是指定多个匹配项和文件（注意：每个匹配项都要加上-e））

# 打印输出aaa文件里面以[开头，后面跟0个或多个任意任意字符，最后以]结尾的数据（注意：\ 表示转义）
# 再将 [] 替换掉，再输出
$ sed -n '/\[.*\]/p' aaa | sed -n -e 's/\[//g' -e 's/\]//g;p'

$ sed -n 's/kommo/qqq/g' aaa             # 将文件aaa里面的kommo修改为qqq，不会修改原文件（注意：s 表示修改，g 表示修改所有；这样不会修改源文件，也不会有输出）
$ sed -n 's/kommo/qqq/g;p' aaa           # 将文件aaa里面的kommo修改为qqq，不会修改原文件（注意：s 表示修改，g 表示修改所有，p表示打印修改后的结果；这样不会修改源文件，但是会将修改后的信息输出出来）
$ sed -i 's/kommo/qqq/' aaa              # 修改文件aaa里面的kommo修改为qqq，直接修改原文件（注意：只会修改每一行的第一个，s 表示修改；这个是直接将文件里面的内容改了）
$ sed -i 's/kommo/qqq/g' aaa             # 修改文件aaa里面的kommo修改为qqq，直接修改原文件（注意：s 表示修改，g 表示修改所有；这个是直接将文件里面的内容改了）

$ sed -i '5,10s/kommo/qqq/g' aaa         # 修改aaa文件里面的5-10行，将kommo修改为qqq，直接修改原文件（注意：s 表示修改，g 表示修改所有；这个是直接将文件里面的内容改了）
$ sed -i '/^root/,10s/kommo/qqq/g' aaa   # 修改aaa文件里面从root开头的行到第10行，将kommo修改为qqq，直接修改原文件（注意：s 表示修改，g 表示修改所有；这个是直接将文件里面的内容改了）
$ sed -i '/dsfsdfds/s/fds/qqq/g' aaa     # 修改aaa文件里面匹配到dsfsdfds的所有行，将fds修改为qqq，直接修改原文件（注意：s 表示修改，g 表示修改所有；这个是直接将文件里面的内容改了）
$ sed -i '/sdfs/,/qqqssd/s/ssd/AAA/g' aaa# 修改aaa文件里面匹配sdfs到qqqssd的所有行，将ssd修改为AAA，直接修改原文件（注意：s 表示修改，g 表示修改所有；这个是直接将文件里面的内容改了）

$ sed -i "s/${AAA}/S/g" aaa              # 修改aaa文件，将AAA变量的值修改为S（注意：使用变量建议将整个表达式使用双引号包起来）
$ sed -i 's/${AAA}/'$AAA'/g' aaa         # 修改aaa文件，将${AAA}修改为AAA变量的值（注意：使用变量可以将获取变量的部分用单引号包起来）

$ sed -i '/444\/444\/44/a DD' aa         # 修改文件aa，在文件里面找到444/444/44所在行（\ 表示转义），在它下面新建一行，数据为DD（注意：是所有匹配行都会加）
$ sed -i '/444444444444/a DD' aa         # 修改文件aa，在文件里面找到444444444444所在行，在它下面新建一行，数据为DD（注意：是所有匹配行都会加）
$ sed -i '/444444444444/i DD' aa         # 修改文件aa，在文件里面找到444444444444所在行，在它上面新建一行，数据为DD（注意：是所有匹配行都会加）

$ sed -i '/DD/r add.txt' aa              # 修改文件aa，在文件里面找到DD所在行，在它下面新建一行，将add.txt文件里面的数据加进去（注意：是所有匹配行都会加）
$ sed -i '20r add.txt' aa                # 修改文件aa，在文件的第20行下面新建一行，将add.txt文件里面的数据加进去
$ sed -i '/^root/,20r add.txt' aa        # 修改文件aa，从root开头的行开始到第20行，每一行下面新建一行，将add.txt文件里面的数据加进去
$ sed -i '/^root/,/jiang$/r add.txt' aa  # 修改文件aa，从root开头的行开始到以jiang的行结束，每一行下面新建一行，将add.txt文件里面的数据加进去

$ sed -i '/DD/w /home/grep/add1.txt' aa  # 将aa文件里面包含DD的行数据，保存到/home/grep/add1.txt文件中
$ sed -i '/^root/,/ji$/w /h/g/a1.txt' aa # 将aa文件从root开始的行到ji结尾的行行数据，保存到/h/g/a1.txt文件中

$ sed -n '1d' aa                         # 删除aa文件里面的第1行数据（注意：这个不会修改文件）
$ sed -n '1d;p' aa                       # 删除aa文件里面的第1行数据，并打印修改后的数据（注意：这个不会修改文件）
$ sed -i '1d' aa                         # 删除aa文件里面的第1行数据（注意：这个会修改文件）
$ sed -i '1,10d' aa                      # 删除aa文件里面的第1行到第10行的数据（注意：这个会修改文件）
$ sed -i '1,+5d' aa                      # 删除aa文件里面的第1行到第（1+5=6）行的数据（注意：这个会修改文件）
$ sed -i '/43/d' aa                      # 删除aa文件里面包含43的行数据（注意：这个会修改文件）
$ sed -i '/ff/,/67/d' aa                 # 删除aa文件里面的数据，从包含ff的行数据开始到包含67行数据结束（注意：这个会修改文件）
$ sed -i '/[:blank:]*#/d;/^$/d' aa       # 删除aa文件里面，以空格开头后面跟着0个或多个空格再跟着一个#号的行数据（注意：多个命令可以;号隔开，:blank:就是匹配空格，这个可以看作是注释行的匹配）

# 高级用法，反向引用简单使用（将正则表达式匹配到的字符串作为变量使用，使用 &或\1 获取该值）
# 修改文件aa里面的内容（匹配到以ma开头，后面跟2个任意字符（.表示匹配任意字符），以n结尾的字符串。在这些字符串后面加上QQ字符）
# 注意：& 表示正则表达式匹配到的字符串
$ sed -i 's/ma..n/&QQ/g' aa 
# 修改aa文件将里面非#号开头的行，前面加入*号（[^#] 表示非#号，& 表示正则表达式匹配到的字符串）   
$ sed -i 's/^[^#]/\*&/g' aa
# 注意：\1 表示正则表达式匹配到的字符串，使用\1的时候必须把正则表达式用括号括起来，而且括号也需要用\转义
$ sed -i 's/\(ma..n\)/\1QQ/g' aa
# 注意：使用 \1 更加灵活，\1只获取括号里面匹配到的值，就是整个正则表达式，我们可以用括号括起其中一段，用\1获取该段所匹配到的值（如下列子\1获取到的就是QQ两个字符） 
$ sed -i 's/ma...\(QQ\)/\1AA/g' aa
```

#### 十八、awk 文本处理工具以及报告生成器简单使用
```bash
# commands1=处理文本之前需要执行的命令，pattern=需要匹配的正则表达式，commands2=处理文本需要执行的命令，commands3=处理文本完成以后需要执行的命令
# 注意：可以同时操控多个文件
$ awk 'BEGIN {commands1} pattern {commands2} END {commands3}' file_name1 file_name2

# awk 的内置command（命令）
|---------|----------------------------------------------|
|print    | 打印输出                                      
|---------|----------------------------------------------|

# awk 的内置变量
|---------|----------------------------------------------|
|$0       | 整行内容                                      
|---------|----------------------------------------------|
|$1-$n    | 当前行的第1-n个字段（就是第1-n列）             
|---------|----------------------------------------------|
|NF       | 当前行的字段个数（也就是有多少个列）           
|---------|----------------------------------------------|
|NR       | 当前行的行号（从1开始记数）                   
|---------|----------------------------------------------|
|FNR      | 多文件处理时，每个文件行号单独记数，都是从1开始
|---------|----------------------------------------------|
|FS       | 输入字符串分隔符（默认使用空格或Tab键分割）        
|---------|----------------------------------------------|
|RS       | 输入行分隔符（默认回车换行）                   
|---------|----------------------------------------------|
|OFS      | 输出字段分隔符（默认空格）                     
|---------|----------------------------------------------|
|ORS      | 输出行分隔符（默认回车换行）                    
|---------|----------------------------------------------|
|FILENAME | 当前输入的文件名称                    
|---------|----------------------------------------------|
|ARGC     | 命令行参数个数          
|---------|----------------------------------------------|
|ARGV     | 命令行参数数组         
|---------|----------------------------------------------|

# printf 函数格式说明符
|---------|----------------------------------------------|
|%s       | 打印字符串                                 
|---------|----------------------------------------------|
|%d       | 打印整型数字                                
|---------|----------------------------------------------|
|%f       | 打印浮点数字                                
|---------|----------------------------------------------|
|%x       | 打印十六进制数字                                
|---------|----------------------------------------------|
|%o       | 打印八进制数字                                
|---------|----------------------------------------------|
|%e       | 打印科学计数法形式的数字                                
|---------|----------------------------------------------|
|%c       | 打印单个字符的ASCII码                                
|---------|----------------------------------------------|

# printf 函数修饰说明符
|---------|----------------------------------------------|
|-        | 左对齐                                
|---------|----------------------------------------------|
|+        | 右对齐（默认值）                                
|---------|----------------------------------------------|
|#0       | 打印8进制                          
|---------|----------------------------------------------|
|#x       | 打印16进制                              
|---------|----------------------------------------------|

$ awk '{print $0}' aaa                   # 打印aaa文件里面每一行数据（注意：print是打印命令，$0是内置变量表示整行内容，BEGIN和END块以及pattern都省略了）
$ awk 'BEGIN {FS=","} {print $1}' aaa    # 打印aaa文件里面每一行以逗号分割后，第1个位置的数据（FS=","表示以逗号分割，$1就是取分割后第1个位置的数据，END和pattern都省略了）
$ awk 'BEGIN {FS=","} {print $2}' aaa    # 打印aaa文件里面每一行以逗号分割后，第2个位置的数据（FS=","表示以逗号分割，$2就是取分割后第2个位置的数据，END和pattern都省略了）

$ awk 'BEGIN {FS=","} {print NF}' aaa    # 打印aaa文件里面每一行以逗号分割后，段落的个数（FS=","表示以逗号分割，NF就是取分割后段落的个数，END和pattern都省略了）
$ awk '{print NR}' aaa bbb               # 打印aaa和bbb文件里面每一行的行号（注意：NR变量两个文件行号会叠加，print是打印命令，NR是内置变量表示当前行的行号，BEGIN和END块以及pattern都省略了）
$ awk '{print FNR}' aaa bbb              # 打印aaa和bbb文件里面每一行的行号（注意：FNR变量两个文件行号不会叠加，会分开打印，print是打印命令，FNR是内置变量表示当前行的行号，BEGIN和END块以及pattern都省略了）

# 使用printf格式化输出，不指定换行（输出的数据只有一行）（说明：printf("%s -- %s",$1,$2)）
$ awk 'BEGIN {FS=","} {printf "%s -- %s",$1,$2}' aaa
# 使用printf格式化输出，指定换行（输出的数据会有多行）（说明：printf("%s -- %s",$1,$2)）
$ awk 'BEGIN {FS=","} {printf "%s -- %s\n",$1,$2}' aaa
# 使用printf格式化输出，指定换行（输出的数据会有多行）（注意：20表示在前面加20个空字符，右对齐）
$ awk 'BEGIN {FS=","} {printf "%20s -- %s\n",$1,$2}' aaa
# 使用printf格式化输出，指定换行（输出的数据会有多行）（注意：20表示在前面加20个空字符，-号表示左对齐）
$ awk 'BEGIN {FS=","} {printf "%-20s %s\n",$1,$2}' aaa
# 使用printf格式化输出浮点数，并且指定换行（输出的数据会有多行）（注意：0.2表示保留小数点后2位（默认是6位））
$ awk 'BEGIN {FS=","} {printf "%0.2f %s\n",$1}' bbb

# 打印a文件里面以|号分割行，以,号分割列之后的每一行数据（FS指定字符串分隔符，RS指定行分隔符）
$ awk 'BEGIN {FS=",";RS="|"} {print $0}' a
# 打印a文件里面以|号分割行，以,号分割列之后的每一行数据。输出时使用\n进行行分割，使用-进行字符串分割
# 注意：FS=输入字符串分隔符，RS=输入行分隔符，ORS=输出行分隔符，OFS=输出字符串分隔符（就是$1和$2的分隔符））
$ awk 'BEGIN {FS=",";RS="|";ORS="\n";OFS="-"} {print $1,$2}' a

# 打印aaa文件里面，查找到包含 root 的每一行
$ awk '/root/ {print $0}' aaa
# 打印aaa文件里面，查找到以 df 开头的每一行
$ awk '/^df/ {print $0}' aaa

# 打印aaa文件里面，查找到以逗号分割后的第3个字段的值大于50的每一行
$ awk 'BEGIN {FS=","} $3 > 50 {print $0}' aaa
# 打印aaa文件里面，查找到以逗号分割后的第3个字段的值等于51的每一行
$ awk 'BEGIN {FS=","} $3 == 51 {print $0}' aaa
# 打印aaa文件里面，查找到以逗号分割后的第3个字段的值大于等于51的每一行
$ awk 'BEGIN {FS=","} $3 >= 51 {print $0}' aaa
# 打印aaa文件里面，查找到以逗号分割后的第3个字段的值不等于51的每一行
$ awk 'BEGIN {FS=","} $3 != 51 {print $0}' aaa
# 打印aaa文件里面，查找到以逗号分割后的第2个字段的值等于dfd的每一行
$ awk 'BEGIN {FS=","} $2 == "dfd" {print $0}' aaa

# 打印aaa文件里面，查找到以逗号分割后的第2个字段的值等于dfd并且第3个字段的值大于等于51的每一行
$ awk 'BEGIN {FS=","} $2 == "dfd" && $3 >= 51 {print $0}' aaa
# 打印aaa文件里面，查找到以逗号分割后的第2个字段的值等于dfd或者第3个字段的值大于等于51的每一行
$ awk 'BEGIN {FS=","} $2 == "dfd" || $3 >= 51 {print $0}' aaa
# 打印aaa文件里面，查找到以逗号分割后的第2个字段的值不等于dfd的每一行（注意：! 是取反）
$ awk 'BEGIN {FS=","} !($2 == "dfd") {print $0}' aaa

# 打印aaa文件里面，查找到以逗号分割后的第3个字段的值是0-9且出现次数大于等于2的每一行
# 注意：~ 后跟着的是正则表达式（用这个正则表达式去匹配前面的值）
$ awk 'BEGIN {FS=","} $3~/[0-9]{2,}/ {print $0}' aaa 
# 打印aaa文件里面，查找到以逗号分割后的第3个字段的值不是（0-9且出现次数大于等于2）的每一行
# 注意：!~ 是取反的意思（就是要不能匹配到正则表达式的数据）
$ awk 'BEGIN {FS=","} $3!~/[0-9]{2,}/ {print $0}' aaa 
# 打印aaa文件里面，查找到以逗号分割后的第3个字段的值是0-9且出现次数大于等于2或者第3个字段的值是dfd的每一行
$ awk 'BEGIN {FS=","} $3~/[0-9]{2,}/ || $2 == "dfd" {print $0}' aaa 

# 直接打印自己定义的变量
$ awk 'BEGIN {var1=20;var2="ssdfds";print var1,var2}'
# 直接打印var1,var2,var3的值（注意：如果var1没有定义，则默认就是0）
$ awk 'BEGIN {var1=20;var2=10;var3=var1+var2;print var1,var2,var3}'
# 直接打印var1,var2的值（注意：如果var1没有定义，则默认就是0）
$ awk 'BEGIN {var1=20;var2=var1+1;print var1,var2}'
# 直接打印var1,var2的值（注意：var1会等于21，var2等于20。原因：先赋值再加加（和java里面的一样））
$ awk 'BEGIN {var1=20;var2=var1++;print var1,var2}'
# 直接打印var1,var2的值（注意：var1和var2都是等于21。原因：先加加再赋值（和java里面的一样））
$ awk 'BEGIN {var1=20;var2=++var1;print var1,var2}'
# 直接打印var1,var2的值（注意：var1会等于19，var2等于20。原因：先赋值再减减（和java里面的一样））
$ awk 'BEGIN {var1=20;var2=var1--;print var1,var2}'
# 直接打印 var1除以var2，保留2位小数，之后换行
$ awk 'BEGIN {var1=20;var2=10;printf "%0.2f\n",var1 / var2}'
# 直接打印 var1乘以var2，保留2位小数，之后换行
$ awk 'BEGIN {var1=20;var2=10;printf "%0.2f\n",var1 * var2}'
# 直接打印 var1的var2次方（10和个20相乘），保留2位小数，之后换行
$ awk 'BEGIN {var1=20;var2=10;printf "%0.2f\n",var1 ** var2}'
# 直接打印 var1的var2次方（10和个20相乘），保留2位小数，之后换行
$ awk 'BEGIN {var1=20;var2=10;printf "%0.2f\n",var1 ^ var2}'

# 统计aaa文件里面包含33的行数（统计开始count=0，每匹配到一行count就是加加，最后打印count）
$ awk 'BEGIN {count=0} /33/ {count++} END {print count}' aaa
# 统计aaa文件里面以逗号分割后，后3个字段的平均值，最后保留4个小数打印出来
$ awk 'BEGIN {FS=","} {total=$2+$3+$4;avg=total/4;printf "%0.4f\n",avg}' aaa
# 统计aaa文件里面以逗号分割后，后3个字段的平均值，最后将3个字段和保留4个小数的平均值打印出来
$ awk 'BEGIN {FS=","} {total=$2+$3+$4;avg=total/4;printf "%d,%d,%d,平均值: %0.4f\n",$2,$3,$4,avg}' aaa
# 统计aaa文件里面以逗号分割后，后3个字段的平均值，最后将3个字段和保留4个小数的平均值打印出来
$ awk 'BEGIN {FS=",";printf "%s,%s,%s,%s\n","语文","数学","英语","平均分"} {total=$2+$3+$4;avg=total/4;printf "%d,%d,%d,%0.4f\n",$2,$3,$4,avg}' aaa
```

#### 十九、其它命令用法
```bash
$ echo $?                                # 查看上一条命令的执行结果（0 表示执行成功，1 表示执行异常）
$ which java                             # 查找某个程序安装目录（这个命令找的是java的安装目录）
$ ps -ef | grep java | grep -v grep      # 查找某个进程是否存在（注意：这个命令也会启一个进程，同时也会被查出来。grep -v grep 就是过滤掉这个命令启动的进程）
$ ps -ef | grep java | wc -l             # wc -l 表示统计命令执行结果的条数

$ env|grep JAVA_OPTS                     # 查看环境变量JAVA_OPTS的值（注意：这个是前置匹配）

$ sh -x ./fn.sh                          # 执行脚本加 -x 参数，可以打印脚本的执行过程
$ cat /etc/passwd | cut -d: -f1          # 获取所有用户（说明：先获取到/etc/passwd里面的所有数据，再通过:号进行行分割，再获取每一行分割后的第一个位置的数据）
$ dd if=./ of=test.db bs=512k count=2    # 在当前目录生成一个test.db文件，大小是1M（大小=bs * count）
```

[1]: https://github.com/firechiang/linux-test/tree/master/docs/ipv4-parameter-optimization.md
[2]: https://github.com/firechiang/linux-test/tree/master/docs/network-io-optimization.md
[3]: https://github.com/firechiang/linux-test/tree/master/docs/numa-explain.md
[4]: https://github.com/firechiang/linux-test/tree/master/docs/resources-limits.md
[5]: https://github.com/firechiang/linux-test/tree/master/docs/disk-io-strategy.md
[6]: https://github.com/firechiang/linux-test/tree/master/docs/bash-simple-use.md
[7]: https://github.com/firechiang/linux-test/tree/master/docs/linux-crontable-use.md
[8]: https://github.com/firechiang/linux-test/tree/master/docs/shell/index.md
[9]: https://github.com/firechiang/linux-test/tree/master/docs/iptables-doc.md
