# 简介
...

## 安装
#### transfer && collecter
  - os: ubuntu12.04
  - yum install -y cmake
  - install gcc-4.6.2-glibc-2.13-linaro-multilib-2011.12.tar.bz2
  - edit ~/my-i.mx6/my-imx6-3035.conf
  - cmake . && make

#### ffmpeg
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
    ffmpeg -re -i /opt/public/1.ts -vcodec h264 -acodec mp3 -f mpegts udp://127.0.0.1:12344
    ffmpeg -re -i udp://127.0.0.1:12344 -vcodec copy -acodec copy -f mpegts udp://127.0.0.1:12345
  - 模拟输入/转码
    * `while true ; do ffmpeg -re -i /opt/public/1.ts -vcodec h264 -acodec mp3 -f mpegts udp://127.0.0.1:12345 ; done`
	* 
  - transfer
    * `transfer`
  - collecter
    * 主模式 `collecter`
    * 从模式 `collecter -s`
  - 模拟接收
    * `./ffplay -af 'volume=0.0' udp://127.0.0.1:12347`
  - 生成带标记帧的ts文件
    * `ffmpeg -re -i /tmp/in.mp4 -vcodec h264 -acodec mp3 -strict experimental  -f mpegts -vf scale=-1:540 /tmp/out.ts`
  - 多网卡情况下的多播路由设置
    * `sudo route add -net 224.0.0.0/8  vmnet1`

## 高可用
  - 待续

## 转码常用参数
ffmpeg -re -i /opt/public/1.ts -vcodec h264 -acodec mp3 -f mpegts -preset veryfast -vf scale=640*360  -crf 28  udp://172.16.0.115:12348

  - preset Current presets in descending order of speed are: ultrafast,superfast,veryfast, faster, fast, medium, slow, slower, veryslow, placebo
  - vf scale=640*360
  - crf  The range of the quantizer scale is 0-51: where 0 is lossless, 23 is default, and 51 is worst possible.

## 其他
  - 测试版本在运行一个小时后会进入一个小时的睡眠状态,可以手动重启解决
  - 工具包中的ffmpeg版本和public目录下的ts文件,是修改过,带有标记帧信息的
  - 开发进度[sender][]
  - 部署拓扑[transfer][]

[sender]:http://naotu.baidu.com/file/c3f15bd55c8e8308d6fb7398e20d10e4?token=e15a4dca3bc92de0
[transfer]:http://naotu.baidu.com/file/04216b3f771850a7744e3d2251c59e26?token=27538d82ec306db6
