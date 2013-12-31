# vpn

## l2tp

##### xl2tp server on ubuntu

- 安装

```
apt-get install xl2tpd
```

- 配置

  * /etc/xl2tpd/xl2tpd.conf

```
[global]
[lns default]
ip range = 172.16.0.2 - 172.16.255.255
local ip = 172.16.0.1
require chap = yes
refuse pap = yes
require authentication = yes
name = gonzofamily.com
;ppp debug = yes
pppoptfile = /etc/ppp/options.xl2tpd
length bit = yes
```

  * /etc/ppp/options.xl2tpd

```
ipcp-accept-local
ipcp-accept-remote
ms-dns 8.8.8.8
noccp
auth
crtscts
idle 1800
mtu 1410
mru 1410
nodefaultroute
debug
lock
proxyarp
connect-delay 5000
```

  * /etc/ppp/chap-secrets

```
usr * pwd *
```

- 运行

```
/etc/init.d/xl2tpd restart
#debug
xl2tpd -D
```

- 其他

```
#打开转发
#/etc/sysctl.conf
net.ipv4.ip_forward=1


#配置iptables/SNAT
#/etc/rc.local
iptables -t nat -A POSTROUTING -s 172.16.0.0/16 -o eth1 -j MASQUERADE
```


##### xl2tp client on openwrt

- 配置.config后编译安装

```
#openwrt .config
CONFIG_PACKAGE_kmod-l2tp=y
CONFIG_PACKAGE_kmod-pppol2tp=y
CONFIG_PACKAGE_xl2tpd=y
CONFIG_PACKAGE_ppp-mod-pppol2tp=y

#linux .config
CONFIG_PPPOL2TP=y
CONFIG_L2TP=y
```

- 配置/etc/config/network,添加以下内容

```
config interface 'vpn'
        option proto 'l2tp'             #与/lib/netifd/proto/l2tp.sh相关
        option username 'usr'           #l2tp拨号用户名
        option password 'pwd'           #l2tp拨号密码
        option server 'xxx.xxx.xxx.xxx' #l2tp拨号服务器域名或IP地址
```


- 配置/etc/config/firewall

```
config zone
     option name 'wan'
     option network 'wan vpn'
     option input   REJECT
     option forward REJECT
     option output  ACCEPT
     option masq    1
```

- 使用vpn/l2tp

```
#手动开启/关闭vpn
ifup vpn
ifdown vpn
#使l2tp可以开机自动拨号：
/etc/init.d/xl2tpd enable

#ifdown vpn 后，如果不能上网，可重启wan口
ifup wan
```






---------------------------------------------------------------

## pptp

##### pptp server on ubuntu

```
#check gre

apt-get install pptpd

cat >> /etc/pptpd.conf << 'EOF
localip 172.17.0.1
remoteip 172.17.0.100-120
EOF


cat >> /etc/ppp/chap-secrets << 'EOF
usr pptpd pwd *
EOF

cat >> /etc/ppp/pptpd-options << 'EOF
ms-dns 8.8.8.8
EOF

/etc/init.d/pptpd restart

cat >> /etc/sysctl.conf << 'EOF
net.ipv4.ip_forward=1
EOF

cat >> /etc/rc.local << 'EOF
iptables -t nat -A POSTROUTING -s 172.16.0.0/16 -o eth0 -j MASQUERADE
EOF
```


##### pptp client on openwrt

- 配置/etc/config/network,添加以下内容

```
config interface 'vpn'
        option proto 'pptp'             #pptp
        option username 'usr'           #pptp拨号用户名
        option password 'pwd'           #pptp拨号密码
        option server 'xxx.xxx.xxx.xxx' #pptp拨号服务器域名或IP地址
```


- 配置/etc/config/firewall

```
config zone
     option name 'wan'
     option network 'wan vpn'
     option input   REJECT
     option forward REJECT
     option output  ACCEPT
     option masq    1
```

- 使用vpn/pptp

```
#手动开启/关闭vpn
ifup vpn
ifdown vpn

#ifdown vpn 后，如果不能上网，可重启wan口
ifup wan
```

