## netoops简介

基于 [netoops support][] 和[taobao patches][] ，为了能工作在redhat 6.3内核(2.6.32-279)，做了少量修改。补丁可在 [netoops-2.6.32-279][]下载

netoops类似于一个网络版本的kmsg工具,可以将日志通过网络传输到远程的服务器上

目前netoops驱动只支持IPv4/UDP,  可以工作在i386和x86_64上

<!--more-->
## 一个例子

### 本机配置

- 先安装好打完补丁的linux内核

- 配置下面的脚本,然后执行

```
#!/bin/sh

#挂载 configfs
mount -t configfs configfs /sys/kernel/config/

#设置netoops
mkdir /sys/kernel/config/netoops/target1
cd /sys/kernel/config/netoops/target1/

#设置本机发送日志的ip地址
echo "1.1.1.1" > local_ip

#设置日志服务器的ip地址
echo "1.2.1.4" > remote_ip

#设置到日志服务器网关的mac地址,如果是直连网络,写日志服务器的mac地址
echo "00:0c:29:57:2d:81" > remote_mac

# 日志服务器udp端口
echo "520" > remote_port

#发送日志的网卡名称,默认是eth0
echo "eth1" > dev_name

#开启netoops
echo "1" > enabled
echo "1" > /sys/kernel/netoops/netoops_record_oom
```

## 远程日志服务器
```
yum install syslog-ng syslog-ng-libdbi

echo >> /etc/syslog-ng/syslog-ng.conf << 'EOF'
source netoops { udp(port(520)); };
destination oopslog { file("/var/log/oops"); };
log { source(netoops); destination(oopslog); };
EOF

service syslog-ng restart
```

重启syslog-ng服务，则以后收到的oops消息将记在/var/log/oops里

## 测试
淘宝文档中的测试办法在redhat6.3内核中无法工作了,原因如下

```
enum kmsg_dump_reason {
    KMSG_DUMP_PANIC,
    KMSG_DUMP_OOPS,
    KMSG_DUMP_KEXEC,
    KMSG_DUMP_EMERG,
    KMSG_DUMP_RESTART,
    KMSG_DUMP_HALT,
    KMSG_DUMP_POWEROFF,
    KMSG_DUMP_SOFT,
    KMSG_DUMP_OOM,
};

#./src/linux-2.6.32-279.el6/kernel/printk.c:1546:
     if ((reason > KMSG_DUMP_OOPS) && !always_kmsg_dump)
          return;
```

只有KMSG_DUMP_PANIC和KMSG_DUMP_OOPS级别的kmsg能够触发netoops
可使用如下模块代码,让内核panic,进行测试.

```
################kernel_pannic.c
#include <linux/module.h>  
#include <linux/kernel.h>  

int init_module(void)
{
    int i;
    printk(KERN_INFO "init_module() called %d\n", 1/0);
    return 0;
}

void cleanup_module(void)
{
    printk(KERN_INFO "cleanup_module() called\n");
}

################### Makefile
obj-m := kernel_pannic.o
KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)
default:
    $(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules

all:
    make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
                 
clean:
    make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
```

编译模块并加载,然后在日志接收机器上查看/var/log/oops日志是否更新了

```
make
insmod kernel_pannic.ko
```


## 资源
* [netoops-2.6.32-279][]
* [taobao patches][]
* [netoops support][] 

[netoops-2.6.32-279]:https://github.com/xiaomi-sa/netoops/tree/master/netoops-kernel-2.6.32-279.23.1.el6
[taobao patches]:https://github.com/alibaba/taobao-kernel/tree/master/patches.taobao
[netoops support]:https://lwn.net/Articles/414031/
