#### 一、Linux提供了cfq，deadline和noop三种调度策略
##### 1.1，cfq: 这个名字是Complete Fairness Queueing的缩写，它是一个复杂的调度策略，按进程创建多个队列，试图保持对多个进程的公平（这就没考虑读操作和写操作的不同耗时）
##### 1.2，deadline: 这个策略比较简单，只分了读和写两个队列（这显然会加速读取量比较大的系统），叫这个名字是内核为每个I/O操作都给出了一个超时时间
##### 1.3，noop: 这个策略最简单，只有单个队列，只有一些简单合并操作

#### 二、考虑到硬件配置、实际应用场景（读写比例、顺序还是随机读写）的差异，上面的简单解释对于实际选择没有太大帮助，实际该选择哪个基本还是要实测来验证。不过下面几条说明供参考
##### 2.1，deadline和noop差异不是太大，但它们俩与cfq差异就比较大
##### 2.2，MySQL这类数据存储系统不要使用cfq（时序数据库可能会有所不同。不过也有说从来没见过deadline比cfq差的情况）

#### 三、调度策略修改
```bash
$ cat /sys/block/sda/queue/scheduler         # 查看磁盘IO调度策略（方括号里面的是当前选定的调度策略），如果不是noop或deadline，请将其修改成noop或deadline
$ vi /etc/default/grub                       # 找到 GRUB_CMDLINE_LINUX 行，在最后加入 elevator=deadline，比如：GRUB_CMDLINE_LINUX="rd.lvm.lv=centos/root rd.lvm.lv=centos/swap rhgb quiet elevator=deadline"
$ grub2-mkconfig -o /boot/grub2/grub.cfg     # BIOS-Based模式，重建  grub.cfg 配置和磁盘调度IO策略（UEFI-Based模式重建使用：grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg）
```
