# new 3ds
=========

## New 3DS 9.8.0-20j downgrade

开盖取出tf卡，在tf卡的根目录下放入

  - [starter.zip][] for [HBL][]
  - [menuhax_v2.1.zip][] HBL引导，开机按L即可进入
  - [sysUpdater.zip][](0.4.2b by profi200) 降级程序
  - [9.2.0-20J-N3DS.ttp] 降级系统文件

#### install HBL
第一步选择一个可用的系统漏洞安装homebrew launcher(HBL),以下是Cubic Ninja的方式
  - [starter.zip][]解压至tf卡根目录
  - 进入Cubic Ninja, 如果卡里已有其他版本的破解存档,在主界面按L+R+X+Y清除后,edit->QR code->Scan QR code
  - 在联网状态下, 扫描http://smealum.github.io/ninjhax2/ 对应的版本

#### install menuhax_v2
有了HBL后,可以在HBL中安装menuhax,来解除对系统漏洞的依赖,安装完成后,在系统启动时按住L可直接进入HBL
  - 将[menuhax_v2.1.zip][]解压至/3ds目录,HBL的应用都放在这里
  - 进入HBL后,打开其中的menuhax manager
  - install -> b -> start 退出

#### downgrade
装完menuhax后,重启时按住L,可直接进入HBL
  - 将[sysUpdater.zip][]解压至/3ds
  - 将[9.2.0-20J-N3DS.ttp][]改名zip,解压至/updates,日版需要删除其中的000400102002CA00.cia,否则可能会变砖
  - 进入HBL后,先开启FTP,再开启sysUpdater,按Y降级(这一步我重复了20次左右后成功)



## 资源

* [starter.zip][] for [HBL][]
* [menuhax_v2.1.zip][] HBL引导，开机按L即可进入
* [sysUpdater.zip][](0.4.2b by profi200) 降级程序
* [9.2.0-20J-N3DS.ttp] 降级系统文件


[HBL]:http://smealum.github.io/3ds/
[starter.zip]:http://pan.baidu.com/s/1c1jfPAS
[menuhax_v2.1.zip]:http://pan.baidu.com/s/1jHrHfvw
[sysUpdater.zip]:http://pan.baidu.com/s/1sjY5YGl
[9.2.0-20J-N3DS.ttp]:http://pan.baidu.com/s/1nusqT7b
