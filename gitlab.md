# gitlab howto

## 绑定域名
```
#/etc/hosts
10.235.116.23  uaq.git
```

## 生成公钥
ssh-kegen

## 修改ssh配置,更换22端口为8022
```
$ vi ~/.ssh/config
Host gitlab.yubo.org
hostname uaq.git
port 8022
```

## 将公钥添加到gitlab
  - 将~/.ssh/id_rsa.pub 内容复制到剪切板
  - 访问http://10.235.116.23:8081
  - profile settings -> SSH Keys -> ADD SSH KEY 粘贴后提交

## 可通过这个地址访问
  - git@gitlab.yubo.org:uaq/uaq.git
