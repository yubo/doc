# 3ds to cia with 3DS Simple CIA Converter(rxTools)

本文来自于[gbatemp](https://gbatemp.net/threads/release-3ds-simple-cia-converter.384559/page-17#post-5950358),
介绍了如何使用rxtool & 3ds-simple-cia-converter批量生成xorpad的方法

### Download the program and follow the discussion on GBATemp

[3DS Simple CIA Converter](https://gbatemp.net/attachments/3ds-simple-cia-converter-v4-3-rar.21012/)

#### 开始

下载，并解压至d:\3DS_2_CIA

![](img/3ds2cia01.png?raw=true)

#### 生成ncchinfo.bin文件

将需要转换的3ds文件(可以是多个)放到一个文件夹中,比如：

![](img/3ds2cia01a.png?raw=true)

运行3ds_simple_cia.exe，点击create 'ncchinfo.bin' file, 选择3ds文件所在的目录，如图：

![](img/3ds2cia02.png?raw=true)
![](img/3ds2cia03.png?raw=true)

保存ncchinfo.bin文件

![](img/3ds2cia04.png?raw=true)

####  ncchinfo.bin -> xorpads

ncchinfo.bin放至3ds存储卡根目录

![](img/3ds2cia05.png?raw=true)
to
![](img/3ds2cia06.png?raw=true)

将sd卡从计算机取出，放回至3ds，启动并进入rxTools菜单(如果设置了自动进入，在rxTools启动时，按住L+R)

![](img/3ds2cia06a.png?raw=true)
![](img/3ds2cia06b.png?raw=true)

现在进到"DECRYTOON",按A进入，选择"Generate Xorpads",等待结束

![](img/3ds2cia06c.png?raw=true)
![](img/3ds2cia06d.png?raw=true)


At the end it's possible you get an error "100%Error opening SDinfo.bin" Just ignore it and press "A"

![](img/3ds2cia06e.png?raw=true)
![](img/3ds2cia06f.png?raw=true)

xporpad文件在sd卡根目录产生了

#### 生成cia文件

3ds关机后，取出sd卡，放入计算机读卡器中，将sd卡根目录下所有的xorpad文件移动到xorpads目录下

![](img/3ds2cia07.png?raw=true)
to
![](img/3ds2cia08.png?raw=true)
![](img/3ds2cia09.png?raw=true)

使用3ds_simple_cia.exe，点击Convert 3DS ROM to CIA, 选择3ds和xorpad文件所在的目录，等待结束

![](img/3ds2cia10.png?raw=true)
![](img/3ds2cia11.png?raw=true)
![](img/3ds2cia12.png?raw=true)

打开cia目录，会看到相应的cia文件
![](img/3ds2cia13.png?raw=true)

#### 使用cia installer安装,玩耍吧

![](img/3ds2cia15.png?raw=true)
![](img/3ds2cia16.png?raw=true)
![](img/3ds2cia18.png?raw=true)

