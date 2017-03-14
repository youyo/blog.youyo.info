---
title: "CentOS6でNAT設定"
thumbnailImage: images/eye-catch/default.png
thumbnailImagePosition: left
metaAlignment: left
date: 2014-05-20
categories:
- technology
tags:
- centos
---

いつも忘れるのでメモ。

- ローカルネットワークは192.168.10.0/24 とする。

```
sed -i "s|net.ipv4.ip_forward = 0|net.ipv4.ip_forward = 1|" /etc/sysctl.conf
sysctl -p
iptables -t nat -A POSTROUTING -s 192.168.10.0/255.255.255.0 -j MASQUERADE
service iptables save
```

<!--more-->

## [追記]

- 外部からのアクセスを許可する。

```
iptables -t nat -A POSTROUTING -d 192.168.10.0/255.255.255.0 -j MASQUERADE
```

- スタティックルート設定

192.168.5.224はnatサーバのIP。

```
echo "192.168.10.0/24 via 192.168.5.224" > /etc/sysconfig/network-scripts/route-eth0
service network restart
```
