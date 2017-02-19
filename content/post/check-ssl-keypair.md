---
title: "SSL証明書のkeyとcrtがペアかどうか確認する"
thumbnailImage: images/eye-catch/openssl.png
thumbnailImagePosition: top
metaAlignment: left
date: 2016-02-19
categories:
- technology
tags:
- openssl
---

apache起動しなくなったよー  
なんとかして！  
  
とかいう雑な依頼が来たので調べてみたら下記エラーログが出ていた。

```
[Fri Feb 19 00:00:00 2016] [error] SSL Library Error: 185073780 error:0B080074:x509 certificate routines:X509_check_private_key:key values mismatch
```
<!--more-->

なんとなくkeyファイルとcrtファイルの組み合わせが合ってないんだろうなーってのはわかる。その確認ってどうしたらいいんだ？ってググったら `openssl` コマンドでわかるみたい。  

```
$ openssl rsa -in ./default.key -modulus -noout | openssl md5
(stdin)= ffba1d6b1fa41d1dc53de9d9f85d4b65

$ openssl x509 -in ./default.crt -modulus -noout | openssl md5
(stdin)= 828f6677d969387cc848201c1872c374
```

正しいペアであれば、それぞれの値が同じものになります。(確認済み)  
今回は明らかに違う値だったので異なるペアってことに。
