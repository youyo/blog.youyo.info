---
title: "KVMでconsole接続出来るようにするメモ"
thumbnailImage: images/eye-catch/default.png
thumbnailImagePosition: left
metaAlignment: left
date: 2014-05-15
categories:
- technology
tags:
- kvm
- centos
---

KVMでVM作成するとき、毎回console出来るようにする設定をググっていたので自分用にメモ。  
+ ワンライナーにはならなかったけど、簡単なコマンドを。  
  
参考元はこちら。  
[RHEL6/CentOS6/SL6 on KVM時のシリアルコンソール設定](http://aikotobaha.blogspot.jp/2012/03/rhel6centos6sl6-on-kvm.html)  
[RHEL KVM (2) コンソール接続](http://aikotobaha.blogspot.jp/2010/08/rhel-kvm-2.html)

<!--more-->

- CentOS6

```
sed -i "s|hiddenmenu|hiddenmenu\nserial --speed=115200 --unit=0 --word=8 --parity=no --stop=1\nterminal --timeout=5 serial console|" /boot/grub/grub.conf
sed -i "s|\(kernel.*\)|\1 console=tty0 console=ttyS0,115200n|g" /boot/grub/grub.conf
```

- CentOS5

```
sed -i "s|standard runlevels|standard runlevels\nS0:12345:respawn:/sbin/agetty ttyS0 115200|" /etc/inittab
sed -i "s|hiddenmenu|hiddenmenu\nserial --speed=115200 --unit=0 --word=8 --parity=no --stop=1|" /boot/grub/grub.conf
sed -i "s|\(kernel.*\)|\1 console=ttyS0,115200n8|" /boot/grub/grub.conf
```
