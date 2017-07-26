## netconsole 

#### local 

sysconsole module
```
## centos
$sudo echo modprobe netconsole >> /etc/rc.modules
$sudo chmod +x /etc/rc.modules

## ubuntu
$sudo vi /etc/default/grub
Locate the line GRUB_CMDLINE_LINUX_DEFAULT="quiet splash" and 
replace this line with GRUB_CMDLINE_LINUX_DEFAULT="debug ignore_loglevel".
$sudo update-grub 
$sudo echo netconsole >> /etc/modules
```

config (/etc/modprobe.d/netconsole.conf)
```
# /etc/modprobe.d/netconsole.conf
#STEP_1_MAC_ADDRESS: 下一跳的mac地址
#netconsole=<LOCAL_PORT>@<SENDER_IP_ADDRESS>/<SENDER_INTERFACE>,
#<REMOTE_PORT>@<RECEIVER_IP_ADDRESS>/<STEP_1_MAC_ADDRESS>
options netconsole netconsole=6666@10.108.14.38/eth0,6666@10.108.13.39/70:f9:6d:42:ed:90
```

#### remote syslog
```
## centos
$ sudo yum install syslog-ng
## ubuntu
$ sudo apt-get install syslog-ng 

Edit /etc/syslog-ng/syslog-ng.conf file:

source net { udp(ip("0.0.0.0") port(6666)); };
destination netconsole { file("/var/log/$HOST-netconsole.log"); };
log { source(net); destination(netconsole); };

$ sudo /etc/init.d/syslog-ng restart
```

## sysrq
```
# dmesg -n 8
# echo 'kernel.printk = 8 4 1 7' >> /etc/sysctl.conf
# echo 'kernel.sysrq = 1' >> /etc/sysctl.conf
# sudo echo w > /proc/sysrq-trigger
```

## resouces
- [sysrq-doc](https://github.com/torvalds/linux/blob/v4.9/Documentation/sysrq.txt)
- [netconsole-doc](https://github.com/torvalds/linux/blob/v4.9/Documentation/networking/netconsole.txt)
- [sysrq](https://www.ibm.com/developerworks/cn/linux/l-cn-sysrq/)
- [netconsole](https://wiki.ubuntu.com/Kernel/Netconsole)

