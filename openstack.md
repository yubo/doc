# openstack 简介

## 模块

 - Identity(Keystone) 为所有的OpenStack服务提供身份验证,授权,服务目录。
 - Image Service(Glance) 是一个虚拟机镜像的存储、查询和检索系统，它提供了一个虚拟磁盘映像的目录和存储库，这些磁盘映像常常广泛应用于OpenStack Compute之中，而且这种服务在技术上是属于可选的，任何规模的云都适用于它。
 - Compute(Nova) 根据需求提供虚拟服务。
 - Block Storage(Cinder) 提供稳定的数据块存储服务。
 - Network(Quantum,nova-network) 在接口设备之间提供“网络连接作为一种服务”。该服务允许用户创建自己的网络
 - Dashboard(Horizon) Web GUI
 - Object Storage(Swift) 允许进行存储或者检索文件。目前已经有几好家公司开始提供基于Swift商业存储服务，这些公司包括KT，Rackspace公司（Swift项目的发源地）和Internap，而且很多大公司内部也使用Swift来存储数据。


##### keystone(身份验证,授权)

```
#mysql
CREATE DATABASE keystone;
GRANT ALL ON keystone.* TO 'keystoneUser'@'10.21.100.22' IDENTIFIED BY 'keystonePass';

#/etc/keystone/keystone.conf
connection = mysql://keystoneUser:keystonePass@10.21.100.22/keystone

#
service keystone restart
keystone-manage db_sync

root@lg-op-paas02:~/folsom# keystone tenant-list
+----------------------------------+---------+---------+
|                id                |   name  | enabled |
+----------------------------------+---------+---------+
| 0174d8c2400b456b95697fbd943fc74e |  admin  |   True  |
| b571884d294948dfb504361ab2515f4f |   xae   |   True  |
| dbb31293d2a14d1b9f9f2ed35276bde3 | service |   True  |
+----------------------------------+---------+---------+

root@lg-op-paas02:~/folsom# keystone user-list
+----------------------------------+---------+---------+--------------------+
|                id                |   name  | enabled |       email        |
+----------------------------------+---------+---------+--------------------+
| 05ccf49534864daaa1eb6efd367baf8c |   xae   |   True  |  yubo@xiaomi.com   |
| 1e7d9b8e77c94ce790fb7f71d7d959fc | quantum |   True  | quantum@xiaomi.com |
| 3cc6424bff21415cb8ee0c62c5d1aaa6 |  cinder |   True  | cinder@xiaomi.com  |
| 4a44c9e55fcf4e3ab56443471cfc956f |   nova  |   True  |  nova@xiaomi.com   |
| 7e99ba659cd740f98272fc3ff55cce38 |  glance |   True  | glance@xiaomi.com  |
| bf80afa1387442369fd0977523084f65 |  admin  |   True  |  admin@xiaomi.com  |
+----------------------------------+---------+---------+--------------------+


root@lg-op-paas02:~/folsom# keystone role-list
+----------------------------------+----------------------+
|                id                |         name         |
+----------------------------------+----------------------+
| 116ba0ed34e54baabf42f7473b2d69e7 |        admin         |
| bc73016ab3614c9e9ce13cfe0c6a9690 |    KeystoneAdmin     |
| cbf21cc989de4a71ab3b1524a2763a4e | KeystoneServiceAdmin |
| cf22b32d3bd145fb96edd655babe8774 |        Member        |
+----------------------------------+----------------------+

root@lg-op-paas02:~/folsom# keystone user-role-list --tenant-id 0174d8c2400b456b95697fbd943fc74e --user-id bf80afa1387442369fd0977523084f65
+----------------------------------+----------------------+----------------------------------+----------------------------------+
|                id                |         name         |             user_id              |            tenant_id             |
+----------------------------------+----------------------+----------------------------------+----------------------------------+
| 116ba0ed34e54baabf42f7473b2d69e7 |        admin         | bf80afa1387442369fd0977523084f65 | 0174d8c2400b456b95697fbd943fc74e |
| bc73016ab3614c9e9ce13cfe0c6a9690 |    KeystoneAdmin     | bf80afa1387442369fd0977523084f65 | 0174d8c2400b456b95697fbd943fc74e |
| cbf21cc989de4a71ab3b1524a2763a4e | KeystoneServiceAdmin | bf80afa1387442369fd0977523084f65 | 0174d8c2400b456b95697fbd943fc74e |
+----------------------------------+----------------------+----------------------------------+----------------------------------+

root@lg-op-paas02:~/folsom# keystone user-role-list --tenant-id dbb31293d2a14d1b9f9f2ed35276bde3 --user-id 7e99ba659cd740f98272fc3ff55cce38
+----------------------------------+-------+----------------------------------+----------------------------------+
|                id                |  name |             user_id              |            tenant_id             |
+----------------------------------+-------+----------------------------------+----------------------------------+
| 116ba0ed34e54baabf42f7473b2d69e7 | admin | 7e99ba659cd740f98272fc3ff55cce38 | dbb31293d2a14d1b9f9f2ed35276bde3 |
+----------------------------------+-------+----------------------------------+----------------------------------+
root@lg-op-paas02:~/folsom# keystone user-role-list --tenant-id dbb31293d2a14d1b9f9f2ed35276bde3 --user-id 4a44c9e55fcf4e3ab56443471cfc956f
+----------------------------------+-------+----------------------------------+----------------------------------+
|                id                |  name |             user_id              |            tenant_id             |
+----------------------------------+-------+----------------------------------+----------------------------------+
| 116ba0ed34e54baabf42f7473b2d69e7 | admin | 4a44c9e55fcf4e3ab56443471cfc956f | dbb31293d2a14d1b9f9f2ed35276bde3 |
+----------------------------------+-------+----------------------------------+----------------------------------+
root@lg-op-paas02:~/folsom# keystone user-role-list --tenant-id dbb31293d2a14d1b9f9f2ed35276bde3 --user-id 3cc6424bff21415cb8ee0c62c5d1aaa6
+----------------------------------+-------+----------------------------------+----------------------------------+
|                id                |  name |             user_id              |            tenant_id             |
+----------------------------------+-------+----------------------------------+----------------------------------+
| 116ba0ed34e54baabf42f7473b2d69e7 | admin | 3cc6424bff21415cb8ee0c62c5d1aaa6 | dbb31293d2a14d1b9f9f2ed35276bde3 |
+----------------------------------+-------+----------------------------------+----------------------------------+
root@lg-op-paas02:~/folsom# keystone user-role-list --tenant-id dbb31293d2a14d1b9f9f2ed35276bde3 --user-id 1e7d9b8e77c94ce790fb7f71d7d959fc
+----------------------------------+-------+----------------------------------+----------------------------------+
|                id                |  name |             user_id              |            tenant_id             |
+----------------------------------+-------+----------------------------------+----------------------------------+
| 116ba0ed34e54baabf42f7473b2d69e7 | admin | 1e7d9b8e77c94ce790fb7f71d7d959fc | dbb31293d2a14d1b9f9f2ed35276bde3 |
+----------------------------------+-------+----------------------------------+----------------------------------+


root@lg-op-paas02:~/folsom# keystone service-list
+----------------------------------+----------+----------+---------------------------+
|                id                |   name   |   type   |        description        |
+----------------------------------+----------+----------+---------------------------+
| 5b71a2346bb043c6bbbeb6f17deb446f |  glance  |  image   |  OpenStack Image Service  |
| 7923583a89a148ea89aee105bd71b751 |   ec2    |   ec2    |   OpenStack EC2 service   |
| 89dec4d269a945ef82b537b2ec425676 |   nova   | compute  | OpenStack Compute Service |
| bea32732deac4f619db175e3c6a552d3 | keystone | identity |     OpenStack Identity    |
| dc62c75a86ec4feaae6cb0bed87959f1 |  cinder  |  volume  |  OpenStack Volume Service |
+----------------------------------+----------+----------+---------------------------+


root@lg-op-paas02:~/folsom# keystone endpoint-list
+----------------------------------+-----------+-------------------------------------------+-------------------------------------------+-------------------------------------------+
|                id                |   region  |                 publicurl                 |                internalurl                |                  adminurl                 |
+----------------------------------+-----------+-------------------------------------------+-------------------------------------------+-------------------------------------------+
| 23e41385f7e44ca1b5cda67c2cb921a4 | RegionOne |       http://10.21.100.22:5000/v2.0       |       http://10.21.100.22:5000/v2.0       |       http://10.21.100.22:35357/v2.0      |
| 6b4d1bf790094e758719cee6b385d637 | RegionOne | http://10.21.100.22:8776/v1/$(tenant_id)s | http://10.21.100.22:8776/v1/$(tenant_id)s | http://10.21.100.22:8776/v1/$(tenant_id)s |
| 804ab168ff0941c4b413e726271109e2 | RegionOne | http://10.21.100.22:8774/v2/$(tenant_id)s | http://10.21.100.22:8774/v2/$(tenant_id)s | http://10.21.100.22:8774/v2/$(tenant_id)s |
| e5abd852eb7a47b8b5c4235ce549037b | RegionOne |  http://10.21.100.22:8773/services/Cloud  |  http://10.21.100.22:8773/services/Cloud  |  http://10.21.100.22:8773/services/Admin  |
| f3a06fbcb63b4d208f75374e3b28226b | RegionOne |        http://10.21.100.22:9292/v2        |        http://10.21.100.22:9292/v2        |        http://10.21.100.22:9292/v2        |
+----------------------------------+-----------+-------------------------------------------+-------------------------------------------+-------------------------------------------+
```

```
cat > creds << 'EOF'
export OS_NO_CACHE=1
export SERVICE_TOKEN=ADMIN
export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=admin_pass
export OS_AUTH_URL="http://10.21.100.22:5000/v2.0/"
EOF
source creds
```


```
root@lg-op-paas02:~/folsom# curl http://10.21.100.22:35357/v2.0/endpoints -H 'x-auth-token: ADMIN' | python -m json.tool
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1392    0  1392    0     0   106k      0 --:--:-- --:--:-- --:--:--  113k
{
    "endpoints": [
        {
            "adminurl": "http://10.21.100.22:35357/v2.0", 
            "id": "23e41385f7e44ca1b5cda67c2cb921a4", 
            "internalurl": "http://10.21.100.22:5000/v2.0", 
            "publicurl": "http://10.21.100.22:5000/v2.0", 
            "region": "RegionOne", 
            "service_id": "bea32732deac4f619db175e3c6a552d3"
        }, 
        {
            "adminurl": "http://10.21.100.22:8776/v1/$(tenant_id)s", 
            "id": "6b4d1bf790094e758719cee6b385d637", 
            "internalurl": "http://10.21.100.22:8776/v1/$(tenant_id)s", 
            "publicurl": "http://10.21.100.22:8776/v1/$(tenant_id)s", 
            "region": "RegionOne", 
            "service_id": "dc62c75a86ec4feaae6cb0bed87959f1"
        }, 
        {
            "adminurl": "http://10.21.100.22:8774/v2/$(tenant_id)s", 
            "id": "804ab168ff0941c4b413e726271109e2", 
            "internalurl": "http://10.21.100.22:8774/v2/$(tenant_id)s", 
            "publicurl": "http://10.21.100.22:8774/v2/$(tenant_id)s", 
            "region": "RegionOne", 
            "service_id": "89dec4d269a945ef82b537b2ec425676"
        }, 
        {
            "adminurl": "http://10.21.100.22:8773/services/Admin", 
            "id": "e5abd852eb7a47b8b5c4235ce549037b", 
            "internalurl": "http://10.21.100.22:8773/services/Cloud", 
            "publicurl": "http://10.21.100.22:8773/services/Cloud", 
            "region": "RegionOne", 
            "service_id": "7923583a89a148ea89aee105bd71b751"
        }, 
        {
            "adminurl": "http://10.21.100.22:9292/v2", 
            "id": "f3a06fbcb63b4d208f75374e3b28226b", 
            "internalurl": "http://10.21.100.22:9292/v2", 
            "publicurl": "http://10.21.100.22:9292/v2", 
            "region": "RegionOne", 
            "service_id": "5b71a2346bb043c6bbbeb6f17deb446f"
        }
    ]
}
```

##### Glance (虚拟机镜像组件)

```
# install
apt-get install glance

# mysql
CREATE DATABASE glance;
GRANT ALL ON glance.* TO 'glanceUser'@'10.21.100.22' IDENTIFIED BY 'glancePass';

#/etc/glance/glance-api-paste.ini 
...
#/etc/glance/glance-api.conf
...
#/etc/glance/glance-registry.conf
...

service glance-api restart
service glance-registry restart
glance-manage db_sync

glance image-create --name NimbulaTest --is-public true --container-format bare --disk-format qcow2 < cirros-0.3.0-x86_64-disk.img

+------------------+--------------------------------------+
| Property         | Value                                |
+------------------+--------------------------------------+
| checksum         | 50bdc35edb03a38d91b1b071afb20a3c     |
| container_format | bare                                 |
| created_at       | 2013-07-15T10:54:06                  |
| deleted          | False                                |
| deleted_at       | None                                 |
| disk_format      | qcow2                                |
| id               | 37f6a1e3-810b-481b-8ef5-d5ac16e6b3ca |
| is_public        | True                                 |
| min_disk         | 0                                    |
| min_ram          | 0                                    |
| name             | NimbulaTest                          |
| owner            | 0174d8c2400b456b95697fbd943fc74e     |
| protected        | False                                |
| size             | 9761280                              |
| status           | active                               |
| updated_at       | 2013-07-15T10:54:06                  |
+------------------+--------------------------------------+


root@lg-op-paas02:~/folsom# glance image-list
+--------------------------------------+-------------------------------------------+-------------+------------------+------------+--------+
| ID                                   | Name                                      | Disk Format | Container Format | Size       | Status |
+--------------------------------------+-------------------------------------------+-------------+------------------+------------+--------+
| 334a662e-2eb4-4151-a03a-d0698ed1e096 | BOSH-16e35fcd-d21e-471c-89f6-70793f91b416 | qcow2       | bare             | 1110573056 | active |
| 37f6a1e3-810b-481b-8ef5-d5ac16e6b3ca | NimbulaTest                               | qcow2       | bare             | 9761280    | active |
| b36b7e19-ea61-447f-9970-00424b77c299 | Ubuntu12.04-amd64                         | qcow2       | ovf              | 252575744  | active |
+--------------------------------------+-------------------------------------------+-------------+------------------+------------+--------+
```

##### networking(nova-network/quantum)

```
apt-get install -y bridge-utils
vi /etc/network/interfaces
...
auto br100
iface br100 inet static
        address 10.21.100.22
        netmask 255.255.255.0
        network 10.21.100.0
        broadcast 10.21.100.255
        gateway 10.21.100.254
        # dns-* options are implemented by the resolvconf package, if installed
        bridge_ports eth0
        bridge_stp off
        bridge_maxwait 0
        bridge_fd 0

apt-get install -y nova-api nova-cert novnc nova-consoleauth nova-scheduler nova-novncproxy nova-network
#delete quantum endpoint
root@lg-op-paas02:~/folsom# keystone endpoint-list | grep 9696
| a4a517c68689478487c1c2cdf7b2f7ff | RegionOne | http://10.21.100.22:9696/ | http://10.21.100.22:9696/ | http://10.21.100.22:9696/ |

root@lg-op-paas02:~/folsom# keystone endpoint-delete a4a517c68689478487c1c2cdf7b2f7ff
root@lg-op-paas02:~/folsom# keystone service-list | grep quantum
| 68d8e18ffb724d1983f990aea5bc4baf | quantum  | network  | OpenStack Networking service |

root@lg-op-paas02:~/folsom# keystone service-delete 68d8e18ffb724d1983f990aea5bc4baf


# mysql
CREATE DATABASE nova;
GRANT ALL ON nova.* TO 'novaUser'@'10.21.100.22' IDENTIFIED BY 'novaPass';

#/etc/nova/api-paste.ini
#/etc/nova/nova.conf
my_ip=10.21.100.22
public_interface=br100
vlan_interface=eth0
flat_network_bridge=br100
flat_interface=eth0
fixed_range=10.21.100.64/27
#dhcpbridge=/usr/bin/nova-dhcpbridge
#default_floating_pool = pool_auto_assign
#floating_range = 1.0.0.0/24
#auto_assign_floating_ip = True
#quota_floating_ips = 50


nova-manage db sync
cd /etc/init.d/; for i in $(ls nova-*); do sudo service $i restart; done

nova-manage service list
Binary           Host                                 Zone             Status     State Updated_At
nova-cert        lg-op-paas02.bj                      nova             enabled    :-)   2013-07-16 05:41:08
nova-consoleauth lg-op-paas02.bj                      nova             enabled    :-)   2013-07-16 05:41:08
nova-network     lg-op-paas02.bj                      nova             enabled    :-)   2013-07-16 05:41:10
nova-scheduler   lg-op-paas02.bj                      nova             enabled    :-)   2013-07-16 05:41:09
```


##### Cinder(块存储服务)

```
# install
apt-get install cinder-api cinder-scheduler cinder-volume iscsitarget iscsitarget-dkms

# mysql
CREATE DATABASE cinder;
GRANT ALL ON cinder.* TO 'cinderUser'@'10.21.100.22' IDENTIFIED BY 'cinderPass';

#/etc/cinder/api-paste.ini
...
#/etc/cinder/cinder.conf
...
volume_group = cinder-volumes
...

cinder-manage db sync


# pvcreate /dev/sda8
# vgcreate cinder-volumes /dev/sda8
# pvs
  PV         VG             Fmt  Attr PSize   PFree  
  /dev/sda8  cinder-volumes lvm2 a--  235.05g 235.05g


# tgt
root@lg-op-paas02:~/folsom# cat /etc/tgt/targets.conf 
include /etc/tgt/conf.d/*.conf
root@lg-op-paas02:~/folsom# cat /etc/tgt/conf.d/cinder_tgt.conf 
include /var/lib/cinder/volumes/*
service

```






##### openstack-dashboard(web gui)

...


##### Compute Node(nova)

```
nova-api ->　nova-api-metadata 
...
```



## 一个例子

```
nova-manage network create --label=NimbulaNetwork --fixed_range_v4=10.21.100.64/27 \
--bridge=br100 --project_id=b571884d294948dfb504361ab2515f4f --num_networks=1 --multi_host=T --dns1=10.237.8.8

glance add name="Ubuntu12.04-amd64" is_public=true container_format=ovf disk_format=qcow2 < precise-server-cloudimg-amd64-disk1.img

root@lg-op-paas02:~# nova-manage network list
id      IPv4                    IPv6            start address   DNS1            DNS2            VlanID          project         uuid           
3       10.21.100.64/27         None            10.21.100.66    10.237.8.8      None            None            b571884d294948dfb504361ab2515f4f        5b704280-ba67-41b2-9ed6-75d2d26abcd0
#nova-mange floating list

##################### 申请key
# 如果没有权限,先定义环境变量 source creds
nova keypair-add xae > xae.priv

##################### 查看机器模板
nova flavor-list

##################### 申请实例
nova boot --flavor 2 --key_name xae --image b36b7e19-ea61-447f-9970-00424b77c299 bosh-cli


root@lg-op-paas02:~/folsom# nova list
+--------------------------------------+----------+--------+--------------------------------------+
| ID                                   | Name     | Status | Networks                             |
+--------------------------------------+----------+--------+--------------------------------------+
| 5edbb336-b47b-45fb-a3dc-7ec322c530d8 | bosh-cli | ACTIVE | NimbulaNetwork=10.21.100.66          |
| bdde8496-89c6-4e73-9c1d-b94dc1f7c74e | xae00    | ACTIVE | NimbulaNetwork=10.21.100.68, 1.0.0.8 |
+--------------------------------------+----------+--------+--------------------------------------+

##################### acl
nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
nova secgroup-list-rules default
+-------------+-----------+---------+-----------+--------------+
| IP Protocol | From Port | To Port | IP Range  | Source Group |
+-------------+-----------+---------+-----------+--------------+
| icmp        | -1        | -1      | 0.0.0.0/0 |              |
| tcp         | 1         | 65535   | 0.0.0.0/0 |              |
| tcp         | 22        | 22      | 0.0.0.0/0 |              |
| udp         | 1         | 65535   | 0.0.0.0/0 |              |
+-------------+-----------+---------+-----------+--------------+


##################### cinder

root@lg-op-paas02:~/folsom# cinder create --display_name test 1
+---------------------+--------------------------------------+
|       Property      |                Value                 |
+---------------------+--------------------------------------+
|     attachments     |                  []                  |
|  availability_zone  |                 nova                 |
|      created_at     |      2013-07-23T03:55:16.875308      |
| display_description |                 None                 |
|     display_name    |                 test                 |
|          id         | a3c7be71-48ce-4228-bde3-39146dd88f1f |
|       metadata      |                  {}                  |
|         size        |                  1                   |
|     snapshot_id     |                 None                 |
|        status       |               creating               |
|     volume_type     |                 None                 |
+---------------------+--------------------------------------+

root@lg-op-paas02:~/src/openstack_folsom_deploy# cinder list
+--------------------------------------+-----------+--------------+------+-------------+-------------+
|                  ID                  |   Status  | Display Name | Size | Volume Type | Attached to |
+--------------------------------------+-----------+--------------+------+-------------+-------------+
| a3c7be71-48ce-4228-bde3-39146dd88f1f | available |     test     |  1   |     None    |             |
+--------------------------------------+-----------+--------------+------+-------------+-------------+

root@lg-op-paas02:~/src/openstack_folsom_deploy# nova volume-attach 5edbb336-b47b-45fb-a3dc-7ec322c530d8 a3c7be71-48ce-4228-bde3-39146dd88f1f auto
+----------+--------------------------------------+
| Property | Value                                |
+----------+--------------------------------------+
| device   | /dev/vdb                             |
| id       | a3c7be71-48ce-4228-bde3-39146dd88f1f |
| serverId | 5edbb336-b47b-45fb-a3dc-7ec322c530d8 |
| volumeId | a3c7be71-48ce-4228-bde3-39146dd88f1f |
+----------+--------------------------------------+

root@bosh-cli:~# fdisk -l          

Disk /dev/vda: 21.5 GB, 21474836480 bytes
255 heads, 63 sectors/track, 2610 cylinders, total 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/vda1   *       16065    41929649    20956792+  83  Linux

Disk /dev/vdb: 1073 MB, 1073741824 bytes
16 heads, 63 sectors/track, 2080 cylinders, total 2097152 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Disk /dev/vdb doesn't contain a valid partition table




ssh -i xae.priv root@10.21.100.66
```






## 重启之后


##### 检查服务状态

```
#keystone
service keystone status

#nova
cd /etc/init.d/; for i in $(ls nova-*); do sudo service $i status; done

#cinder
cd /etc/init.d/; for i in $(ls cinder-*); do sudo service $i status; done


# nova list
root@lg-op-paas02:/etc/init.d# nova list
+--------------------------------------+----------+---------+--------------------------------------+
| ID                                   | Name     | Status  | Networks                             |
+--------------------------------------+----------+---------+--------------------------------------+
| 5edbb336-b47b-45fb-a3dc-7ec322c530d8 | bosh-cli | SHUTOFF | NimbulaNetwork=10.21.100.66          |
| bdde8496-89c6-4e73-9c1d-b94dc1f7c74e | xae00    | SHUTOFF | NimbulaNetwork=10.21.100.68, 1.0.0.8 |
+--------------------------------------+----------+---------+--------------------------------------+
root@lg-op-paas02:/etc/init.d# nova start bosh-cli
root@lg-op-paas02:/etc/init.d# nova list
+--------------------------------------+----------+---------+--------------------------------------+
| ID                                   | Name     | Status  | Networks                             |
+--------------------------------------+----------+---------+--------------------------------------+
| 5edbb336-b47b-45fb-a3dc-7ec322c530d8 | bosh-cli | ACTIVE  | NimbulaNetwork=10.21.100.66          |
| bdde8496-89c6-4e73-9c1d-b94dc1f7c74e | xae00    | SHUTOFF | NimbulaNetwork=10.21.100.68, 1.0.0.8 |
+--------------------------------------+----------+---------+--------------------------------------+

# nova reset-state <server_name/server_id> # the state of instance will be changed to “ERROR”
# nova reset-state --active <server_name/server_id> # the state of instance will be changed to “ACTIVE” At this time, we can stop the instance, and start it again as usual.
# nova stop <server_name/server_id> # the state of instance will be changed to “SHUTOFF”
# nova start <server_name/server_id> # the state of instance will be changed to “ACTIVE”

# vm
nova list

#



```
