# vpn

## l2tp

##### server

- install

- /etc/xl2tpd/xl2tpd.conf

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

- /etc/ppp/options.xl2tpd

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

- /etc/ppp/chap-secrets

```
usr * pwd *
```

- command

```
/etc/init.d/xl2tpd restart
#debug
xl2tpd -D
```

- /etc/sysctl.conf

```
net.ipv4.ip_forward=1
```

- iptables

```
#/etc/rc.local
iptables -t nat -A POSTROUTING -s 172.16.0.0/16 -o eth1 -j MASQUERADE
```

##### client

- 配置.config后编译安装

```
#.config
CONFIG_PACKAGE_kmod-l2tp=y
CONFIG_PACKAGE_kmod-pppol2tp=y
CONFIG_PACKAGE_xl2tpd=y
CONFIG_PACKAGE_ppp-mod-pppol2tp=y
#package/bcm-rls/components/opensource/linux/linux-2.6.36/bcm.config
CONFIG_PPPOL2TP=y
CONFIG_L2TP=y
```

- 配置/etc/config/network,添加以下内容

```
config interface 'vpn'
        option ifname 'vpn1'
        option proto 'l2tp'             #与/lib/netifd/proto/l2tp.sh相关
        option username 'usr'           #l2tp拨号用户名
        option password 'pwd'           #l2tp拨号密码
        option server 'xxx.xxx.xxx.xxx' #l2tp拨号服务器域名或IP地址
```


config interface 'vpn'
        option proto 'l2tp'
        option server '10.237.104.117'
        option username 'usr'
        option password 'pwd'


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

- 使用vpn

```
#手动开启/关闭vpn
ifup vpn
ifdown vpn
#使l2tp可以开机自动拨号：
/etc/init.d/xl2tpd enable```






---------------------------------------------------------------

## pptp

##### server

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


----------------------------------------------------------

##### clinet (ubuntu)

```
cat >> /etc/ppp/chap-secrets << 'EOF'
usr * pwd *
EOF


cat > /etc/ppp/peers/xq << 'EOF'
pty "pptp 1.0.2.3 --nolaunchpppd"
name usr
remotename xq
require-mppe-128
mppe-stateful
file /etc/ppp/options.pptp
ipparam xq
defaultroute
EOF


pon xq  || pon xq debug dump logfd 2 nodetach

```


- 编译

```
#.config
CONFIG_PACKAGE_pptp=y
#package/bcm-rls/components/opensource/linux/linux-2.6.36/bcm.config
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_CONNTRACK_PPTP=m
```

- /etc/ppp/peers/myvpn(0600)

```
# written by pptpsetup
pty "pptp 42.62.48.76 --nolaunchpppd"
lock
noauth
nobsdcomp
nodeflate
name conan2
remotename myvpn
ipparam myvpn
require-mppe-128
```

- vi /etc/ppp/ip-up
DG=10.237.104.1 #this is your default gateway
/sbin/route del -host $5 dev ppp0 #we delete "stupid" pppd route
/sbin/route add -host $5 gw $DG dev vlan1 #we add route to vpn-server in case you need it

pppd call think debug dump logfd 2 updetach

pppd call think updetach
killall pppd


## 资源

```
root@42.62.48.76 xiaomi9ijn0okm

```

