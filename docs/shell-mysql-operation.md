#### 一、mysql命令详解（注意：参数后面不需要加空格，比如 -P3306）
```bash
-------|-----------------------------
option | 说明
-------|-----------------------------
-u     | 指定用户名
-------|------------------------------
-p     | 指定密码
-------|------------------------------
-h     | 指定服务器地址
-------|------------------------------
-D     | 指定要连接是数据库
-------|------------------------------
-N     | 指定不输出列的信息
-------|------------------------------
-B     | 指定使用tab键代替默认交互分隔符
-------|------------------------------
-e     | 指定要执行的sql语句
-------|------------------------------
-E     | 垂直输出
-------|------------------------------
-H     | 以HTML格式输出
-------|------------------------------
-X     | 以XML格式输出
-------|------------------------------
```

#### 二、创建数据表
```bash
# 创建sql文件
$ cat > school.sql << 'EOF'
-- 学生表
create table `student`(
    `s_id` varchar(20),
    `s_name` varchar(20) not null default '',
    `s_birth` varchar(20) not null default '',
    `s_sex` varchar(10) not null default '',
    primary key(`s_id`)
);

-- 课程表
create table `course`(
    `c_id` varchar(20),
    `c_name` varchar(20) not null default '',
    `t_id` varchar(20) not null,
    primary key(`c_id`)
);

-- 教师表
create table `teacher`(
    `t_id` varchar(20),
    `t_name` varchar(20) not null default '',
    primary key(`t_id`)
);

-- 成绩表
create table `score`(
    `o_id` varchar(20),
    `c_id` varchar(20),
    `o_score` int(3),
    primary key(`o_id`,`c_id`)
);

-- 插入学生表数据
insert into `student` values('1001','zhaolei','1998-01-02','male');
insert into `student` values('1002','moamoa','1968-12-12','male');
insert into `student` values('1003','zhanai','1989-09-22','male');
insert into `student` values('1004','wenjuan','1990-11-11','female');
insert into `student` values('1005','maoai','1978-02-02','male');
insert into `student` values('1006','jiangjian','1968-06-05','female');
insert into `student` values('1007','juanwen','1999-05-02','male');
insert into `student` values('1008','zhengzheng','2001-01-10','male');
insert into `student` values('1009','aiaia','1999-12-11','female');
insert into `student` values('1010','tiantia','2011-11-02','female');
insert into `student` values('1011','zoua','2009-01-12','female');

-- 插入课程表数据
insert into `course` values('1001','语文','1002');
insert into `course` values('1002','数学','1001');
insert into `course` values('1003','外语','1003');

-- 插入教师表数据
insert into `teacher` values('1001','万老师');
insert into `teacher` values('1002','上官老师');
insert into `teacher` values('1003','爱心老师');

-- 插入成绩表数据
insert into `score` values('1001','1001',80);
insert into `score` values('1001','1002',90);
insert into `score` values('1001','1003',99);
insert into `score` values('1002','1001',70);
insert into `score` values('1002','1002',60);
insert into `score` values('1002','1003',80);
insert into `score` values('1003','1001',80);
insert into `score` values('1003','1002',80);
insert into `score` values('1003','1003',80);
insert into `score` values('1004','1001',50);
insert into `score` values('1004','1002',30);
insert into `score` values('1004','1003',20);
insert into `score` values('1005','1001',76);
insert into `score` values('1005','1002',81);
insert into `score` values('1005','1003',31);
insert into `score` values('1006','1001',31);
insert into `score` values('1006','1002',34);
insert into `score` values('1006','1003',50);
insert into `score` values('1007','1001',66);
insert into `score` values('1007','1002',22);
insert into `score` values('1007','1003',52);
insert into `score` values('1008','1001',66);
insert into `score` values('1008','1002',52);
insert into `score` values('1008','1003',99);
insert into `score` values('1009','1001',66);
insert into `score` values('1009','1002',98);
insert into `score` values('1009','1003',99);
insert into `score` values('1010','1001',30);
insert into `score` values('1010','1002',80);
insert into `score` values('1010','1003',90);
insert into `score` values('1011','1001',69);
insert into `score` values('1011','1002',89);
insert into `score` values('1011','1003',58);
EOF
```

#### 三、导入MySQL数据文件
```bash
# 进入MySQL命令行
$ mysql
# 创建数据库school
$ create database school default character set utf8;
# 创建用户名jiang密码jiang，并将数据库school的正删改查的权限赋给它（注意：@localhost 表示本地IP才能访问）
$ grant all on school.* to jiang@localhost identified by 'jiang';
# 退出MySQL命令行
$ exit;
# 导入sql数据文件
$ mysql school < school.sql

# 使用用户将登陆MySQL
$ mysql -h 127.0.0.1 -P 3306 -u jiang -pjiang
```

#### 四、使用脚本控制mysql简单使用
```bash
# 创建一个用来执行sql的脚本
$ cat > exe_sql.sh << 'EOF'
#!/bin/bash
#
user="jiang"
password="jiang"
host="127.0.0.1"
// 要执行的sql和数据名称使用参数传进来
db_name="$1"
sql="$2"
# 获取变量的值建议使用双引号包起来
mysql -u"$user" -p"$password" -h"$host" -D"$db_name" -B -e "$sql"
EOF

# 执行脚本
$ ./exe_sql.sh "school" "select * from student"
```

#### 五、将特定文本数据导入到mysql（注意：mysql本身有自带的load data命令，只能导入固定格式的数据）
```bash
# 创建数据文件
$ cat > data.txt << 'EOF'
1012 zhaolei 1998-01-02 male
1013 moamoa 1968-12-12 male
1014 zhanai 1989-09-22 male
1015 wenjuan 1990-11-11 female
1016 maoai 1978-02-02 male
EOF

# 创建导入数据脚本
$ cat > load_data.sh << 'EOF'
#!/bin/bash
#
user="jiang"
password="jiang"
host="127.0.0.1"
db_name="school"

mysql_conn="mysql -u"$user" -p"$password" -h"$host" "

# 指定linux系统默认读取数据分隔符（注意：这个linux系统默认的环境变量，它的默认值是空格或tab键）
IFS=" "

# while read 循环读取命令默认会用空格或tab键分割数据（我们只需定义变量将分割后的数据接住即可，就像下面这样）
cat data.txt | while read id name birch sex
do
    $mysql_conn -D"$db_name" -e "insert into student values('$id','$name','$birch','$sex')"
done
EOF

# 执行脚本
$ ./load_data.sh
```

#### 六、mysql数据备份命令mysqldump详解
```bash
---------|--------------------------------------------
option   |  说明
---------|--------------------------------------------
-u       |  指定用户名
---------|--------------------------------------------
-p       |  指定密码
---------|--------------------------------------------
-h       |  指定服务器地址
---------|--------------------------------------------
-d       |  等价于--on-data（只导出表结构）
---------|--------------------------------------------
-t       |  等价于--on-create-info（只导出数据，不导出建表语句）
---------|--------------------------------------------
-A       |  等价于--all-databases（导出有权限的所有数据库）
---------|--------------------------------------------
-B       |  等价于--databases（指定一个或多个数据库）
---------|--------------------------------------------
--where  |  指定表数据的过滤条件
---------|--------------------------------------------

# 导出school数据库所有数据包括表结构
$ mysqldump -ujiang -pjiang -h127.0.0.1 school > db.sql

# 导出school数据库的student表的所有数据包括表结构
$ mysqldump -ujiang -pjiang -h127.0.0.1 school student > db-student.sql

# 导出school数据库的student表的s_id=1001的所有数据包括表结构
$ mysqldump -ujiang -pjiang -h127.0.0.1 school student --where="s_id=1001" > db-student-where.sql

# 导出school和test数据库所有的数据包括表结构
$ mysqldump -ujiang -pjiang -h127.0.0.1 -B school test > db-school-test.sql
```

#### 七、创建mysqldump备份数据，再将备份数据传送到FTP服务器脚本
```bash
#!/bin/bash
#
# 数据库相关变量
db_user="jiang"
db_password="jiang"
db_host="127.0.0.1"

# ftp服务器相关变量
ftp_user="ftp-jiang"
ftp_password="ftp-jiang"
ftp_host="127.0.0.1"

# 远程目录
dst_dir="/home/backup"
# 当前时间
time_data="`date +%Y%m%d%H%M%S`"
# 备份后数据的文件名
file_name="school_student_${time_data}.sql"

# ftp上传文件函数（参数是要上传的文件地址（注意：结尾的EOF要顶格写，否则报错））
function up_load{
    ftp -niv << EOF
        open $ftp_host
        user $ftp_user $ftp_password
        
        cd $dst_dir
        put $1
        bye
EOF
}
# 备份school数据student表的所有数据 并且 调用up_load函数将备份文件上传到ftp服务器
mysqldump -u"$db_user" -p"$db_password" -h"$db_host" school student > ./$file_name && up_load ./$file_name
```
