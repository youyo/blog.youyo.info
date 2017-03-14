---
title: "hwclockのせいでOS起動しなくなった"
thumbnailImage: images/eye-catch/default.png
thumbnailImagePosition: left
metaAlignment: left
date: 2014-06-17
categories:
- technology
tags:
- centos
---

CentOS 5系のサーバを何気なくrebootしたら上がってこなくなった。  
慌ててリモートコンソール繋ぐと、

```
INIT: version 2.86 booting
Welcome to  CentOS release 5 (Final)
Press ‘I’ to enter interactive startup.
```

この画面で止まってた。。

<!--more-->

ガクブルしつつ再度rebootし、singleユーザーモードで立ち上げるも同じところで止まる。。。  
  
`INIT welcome to centos hang` とかでググってみると下記サイトがヒット！   
http://blog.wapnet.nl/2010/12/centos-fedora-red-hat-guest-os-hangs-during-boot-vmware/  
  
どうやらhwclockが悪さをしているらしい。  
  
BIOSで時刻設定が合ってるか確認したけど問題なし。  
時間合ってるかは関係ないのかな〜、というか仮想化してないし物理ハードだし〜とか思いつつも、とりあえずrescueモードで立ち上げてサイトにある対応を実施。  
  
```
mv hwclock hwclock.original
echo "exit 0" > hwclock
chmod 755 hwclock
```

(こういうときだけ)神に祈りつつreboot…！！  
  
無事起動しました！！！

## まとめ

- googleさんありがとう
