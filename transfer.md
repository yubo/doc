# 简介
...

## 安装
先展开压缩包
```shell
tar xzvf release-yyyymmdd.tar.gz
cd release-yyyymmdd
````

#### install transfer
系统要求 ubuntu12.04 x86_64

```shell
#将x86_64/transfer.tar.gz解压至根目录
$sudo tar xzvf x86_64/transfer.tar.gz -C /
etc/config/transfer
etc/init.d/transfer
usr/sbin/transfer
#将transfer服务更新至系统
$sudo /usr/sbin/update-rc.d transfer defaults
#卸载
$sudo /usr/sbin/update-rc.d -f transfer remove 
#运行
$sudo service transfer start|stop|restart|status
```

#### install collector
系统要求 ubuntu12.04 arm

```shell
$sudo tar xzvf arm/collector.tar.gz -C /
usr/sbin/collector
etc/config/collector.example
etc/init.d/collector
#将transfer服务更新至系统
$sudo /usr/sbin/update-rc.d collector defaults
#卸载
$sudo /usr/sbin/update-rc.d -f collector remove 
#运行
$sudo service collector start|stop|restart|status
```

#### install keepalive
系统要求 ubuntu12.04 arm

```shell
$sudo tar xzvf arm/keepalived.tar.gz -C /
usr/sbin/keepalived
usr/sbin/genhash
etc/keepalived/
etc/keepalived/backup.sh
etc/keepalived/stop.sh
etc/keepalived/fault.sh
etc/keepalived/keepalived.conf
etc/keepalived/master.sh
etc/init.d/keepalived
#将transfer服务更新至系统
$sudo /usr/sbin/update-rc.d keepalived defaults
#卸载
$sudo /usr/sbin/update-rc.d -f keepalived remove 
#运行
$sudo service keepalived start|stop|restart|status
```

#### ffmpeg
解压tools.tar.gz

```
#install libx264
sudo apt-get install -y libx264-dev yasm

#install lame
cd tools/lame-3.99.5
./configure
make
sudo make install

#install ffmpeg
cd ../FFmpeg
./configure --disable-shared  --enable-gpl\
        --enable-static \
        --enable-libx264 \
        --enable-libmp3lame \
        --enable-pthreads \
        --enable-filter=scale \
        --enable-protocol=udp \
        --enable-protocol=file \
        --enable-protocol=unix \
        --enable-encoder=libx264 \
        --enable-encoder=libmp3lame \
        --enable-bsf=h264_mp4toannexb \
        --enable-decoder=mpeg2video \
        --enable-decoder=h264 \
        --enable-decoder=aac \
        --enable-decoder=ac3 \
        --enable-decoder=mp3 \
        --enable-muxer=mpegts \
        --enable-demuxer=mpegts 
make
sudo make install
```

## 测试

  如果没有特殊说明，请使用工具包中的ffmpeg
  - 直接用ffmpeg中转
    * `ffmpeg -re -i /opt/public/1.ts -vcodec h264 -acodec mp3 -f mpegts udp://127.0.0.1:12344`
    * `ffmpeg -re -i udp://127.0.0.1:12344 -vcodec copy -acodec copy -f mpegts udp://127.0.0.1:12345`
  - 模拟输入/转码
    * `while true ; do ffmpeg -re -i /opt/public/1.ts -vcodec h264 -acodec mp3 -f mpegts udp://127.0.0.1:12345 ; done`
	* 
  - transfer
    * `transfer`
	* `sudo service transfer start|stop|restart`
  - collector
    * `collector`
	* `sudo service collector start|stop|restart`
  - 模拟接收
    * `ffplay -af 'volume=0.0' udp://127.0.0.1:12347`
  - 生成带标记帧的ts文件
    * `ffmpeg -re -i /tmp/in.mp4 -vcodec h264 -acodec mp3 -strict experimental  -f mpegts -vf scale=-1:540 /tmp/out.ts`
  - 多网卡情况下的多播路由设置
    * `sudo route add -net 224.0.0.0/8  vmnet1`

## 高可用 keepalived

配置文件是/etc/keepalived/keepalived.conf,修改配置后，需要重启服务`sudo service keepalived restart`

```
! Configuration File for keepalived

vrrp_script chk_echo_port {
    script "echo '</dev/tcp/127.0.0.1/12346' | /bin/bash" #检测本地的tcp 12346端口
    interval 1
	weight -2             #如果失败，权重-2
}

vrrp_instance VI_1 {      #广播域内的名称VI_1
    state BACKUP
    interface eth0        #这里填写内网（ha）广播接口设备名
	track_interface {
		eth0              #同上，如果eth0异常，会触发notify_fault
	}
    virtual_router_id 51
    priority 100          #权重，backup的权重高于master时，会与master交换角色身份
    advert_int 1
    authentication {
        auth_type PASS    #认证类型及口令，同一广播域内的相同id，口令须一致
        auth_pass 1111
    }
    track_script {
       chk_echo_port      #脚本检查，会影响权重
    }
    notify_backup "/etc/keepalived/backup.sh"  #切换至backup时触发
    notify_master "/etc/keepalived/master.sh"  #切换至master时触发
    notify_fault  "/etc/keepalived/fault.sh"   #网卡检查失败时触发
    notify_stop   "/etc/keepalived/stop.sh"    #服务关闭时触发

}
```

## 转码常用参数
```shell
ffmpeg -re -i /opt/public/1.ts -vcodec h264 -acodec mp3 -f mpegts -preset veryfast -vf scale=640*360  -crf 28  udp://172.16.0.115:12348
```

  - preset Current presets in descending order of speed are: 
    * `ultrafast`
	* `superfast`
	* `veryfast`
	* `faster`
	* `fast`
	* `medium`
	* `slow`
	* `slower`
	* `veryslow`
	* `placebo`
  - vf scale=640*360
  - crf  The range of the quantizer scale is 0-51: where 0 is lossless, 23 is default, and 51 is worst possible.

## 其他
  - 测试版本在运行一个小时后会进入一个小时的睡眠状态,可以手动重启解决
  - 工具包中的ffmpeg版本和public目录下的ts文件,是修改过,带有标记帧信息的
  - 开发进度[sender][]
  - 部署拓扑[transfer][]

[sender]:http://naotu.baidu.com/file/c3f15bd55c8e8308d6fb7398e20d10e4?token=e15a4dca3bc92de0
[transfer]:http://naotu.baidu.com/file/04216b3f771850a7744e3d2251c59e26?token=27538d82ec306db6
