#### 并发的调优是不能突破Amdahl 定律的，总会有串行的部分形成短板，对于CPU来讲也是同样的道理。随着CPU的核数越来越多，但CPU的利用率却越来越低，这是因为，所有的CPU都需要通过北桥来读取内存，对于CPU来说内存是共享的，这里的内存访问便是短板所在。为了解决这个短板，NUMA架构的CPU应运而生
![image](https://github.com/firechiang/linux-test/blob/master/image/numa-framework.jpg)
#### 如下图所示，是两个NUMA节点的架构图，每个NUMA节点有自己的本地内存，整个系统的内存分布在NUMA节点的内部，某NUMA节点访问本地内存的速度(Local Access)比访问其它节点内存的速度(Remote Access)要快
#### 数据库场景的服务器一般建议关掉NUMA（默认是开启的，关闭方法如下）
```bash
$ dmesg | grep -i numa                                       # 查看 numa 是否关闭
$ vi /etc/default/grub                                       # 找到 GRUB_CMDLINE_LINUX 行，在最后加入 numa=off，比如：GRUB_CMDLINE_LINUX="rd.lvm.lv=centos/root rd.lvm.lv=centos/swap rhgb quiet numa=off"
$ grub2-mkconfig -o /boot/grub2/grub.cfg                     # BIOS-Based模式，重建  grub.cfg 配置和关闭 numa（UEFI-Based模式重建使用：grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg）
```