# new 3ds
=========

## 1. New 3DS 9.8.0-25j downgrade

开盖取出tf卡，在tf卡的根目录下放入

  - [starter.zip][] for [HBL][]
  - [menuhax_v2.1.zip][] HBL引导，开机按L即可进入
  - [sysUpdater.zip][](0.4.2b by profi200) 降级程序
  - [9.2.0-20J-N3DS.ttp] 降级系统文件

#### 1.1 HBL
第一步选择一个可用的系统漏洞安装homebrew launcher(HBL),以下是Cubic Ninja的方式
  - [starter.zip][]解压至tf卡根目录
  - 进入Cubic Ninja, 如果卡里已有其他版本的破解存档,在主界面按L+R+X+Y清除后,edit->QR code->Scan QR code
  - 在联网状态下, 扫描http://smealum.github.io/ninjhax2/ 对应的版本

#### 1.2 install menuhax_v2
有了HBL后,可以在HBL中安装menuhax,来解除对系统漏洞的依赖,安装完成后,在系统启动时按住L可直接进入HBL,
安装需要初始化tf卡的主题目录，如发现无法安装，可修改一次主题颜射解决
  - 将[menuhax_v2.1.zip][]解压至/3ds目录,HBL的应用都放在这里
  - 进入HBL后,打开其中的menuhax manager
  - install -> b -> start 退出

#### 1.3 downgrade
装完menuhax后,重启时按住L,可直接进入HBL
  - 将[sysUpdater.zip][]解压至/3ds
  - 将[9.2.0-20J-N3DS.ttp][]改名zip,解压至/updates,**日版需要删除其中的000400102002CA00.cia**,否则可能会变砖
  - 进入HBL后,先开启FTP,再开启sysUpdater,按Y降级(这一步我重复了20次左右后成功)


## 2. New 3DS 9.1.0-20j install rxTools

#### 2.1 HBL
see 1.1

#### 2.2 install menuhax_v2
see 1.2

#### 2.3 install devmenu
  - reboot -> L -> HBL
  - PastaCFW -> HBL(see 2.1)
  - FBI -> install devmenu.cia
FBI安装前，**要确保Nintendo 3DS/[1-9a-z]+/[1-9a-z]+/dbs/{import.db,title.db}这两个文件存在**，
可初始化2个空文件，进入3ds设置-文件管理(3-1-1-1-1)中初始化异常db文件

#### 2.4 create emuNAND
  - 备份tf卡中的Nintendo 3DS目录，用来在生成emuNAND后恢复devmenu
  - reboot -> L -> HBL
  - GW -> formatNAND
  - 关机取出tf卡，将备份的目录恢复

#### 2.5 分离系统
  - 取出tf卡，进入系统设置，恢复出厂设置(4-5-2)
  - 初始化后, 关机，插入tf卡
  - 重复2.1, 2.2
系统分离后，会在Nintendo 3DS下产生一个新的目录(真实系统),旧的目录由虚拟系统使用，存储目录分开了

#### 2.6 rxTools
  - boot -> L -> HBL
  - bootmanager -> rxTools -> boot emuNAND

#### 2.7 emuNAND update to 9.5.0-20j
  - HBL -> rxTools -> emuNAND
  - 修改主题颜色，使emuNAND devmenu失效，**这个会和升级冲突，导致黑屏**
  - BigBlueMenu -> 进入9.5.0-20j cia所在目录，R+L+A 安装所有，结束后，**直接power键退出**

### 2.8 Configure
  - HBL -> menuhax 可配置启动快捷键或自启动(configure -> Type1 -> 触碰下屏)
  - menuhax 设置开机启动图片 https://gbatemp.net/threads/menuhax-2-0-custom-main-screen-images.401528/
  - [CtrBootManager][]
    * 将HBL在ft卡根目录的boot.3dsx改名boot_hb.3dsx, 备份boot.cfg
	* 将[CtrBootmanager][]解压至根目录覆盖
	* 配置boot.cfg
  - 配置好后，可自动引导进入rxTools

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
[CtrBootManager]:http://gbatemp.net/threads/ctrbootmanager-3ds-boot-manager-loader-homemenuhax.398383/
