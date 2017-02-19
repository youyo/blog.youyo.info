---
title: "CentOS7にphp5.2をインストール"
thumbnailImage: images/eye-catch/centos.png
thumbnailImagePosition: top
metaAlignment: left
date: 2016-02-10
categories:
- technology
tags:
- centos
- php
---

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">今更php5.2とかやめてくれ！！！</p>&mdash; 洋@新婚 (@youyo\_) <a href="https://twitter.com/youyo_/status/697246270478356480">2016, 2月 10</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script></p>
<br/>
<br/>
<br/>
<br/>
そう叫びたかったけど、男には戦わなければいけない時もある。
<br/>
<br/>
<br/>
<br/>
<blockquote class="twitter-tweet" data-lang="ja"><p lang="de" dir="ltr">$ wget <a href="https://t.co/nGLB8cfWD6">https://t.co/nGLB8cfWD6</a></p>&mdash; 洋@新婚 (@youyo\_) <a href="https://twitter.com/youyo_/status/697246709089349632">2016, 2月 10</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<br/>
<br/>
<br/>
<br/>

<!--more-->

---

## 環境

- CentOS 7.2 (kernel 3.10.0-327.4.5.el7.x86_64)
- apache 2.4.6
- mysql 5.6.29
- **php 5.2.17**

## とりあえずやってみる

<script src="https://gist.github.com/youyo/e87cd5abe6594bcbc6ae.js"></script>

で、出たエラーがこれ。

<script src="https://gist.github.com/youyo/8c129faf64e8b92609be.js"></script>

ググったら同じようなことしている人がいて、頼むからそんな古いもの使わないでくれ！的なこと言われてた。(わかる)  
[https://www.centos.org/forums/viewtopic.php?f=47&t=53046](https://www.centos.org/forums/viewtopic.php?f=47&t=53046)  
<br/>
<br/>
でも最後になにやらパッチがあったので当ててみた。

<script src="https://gist.github.com/youyo/39704fbe5f7b3ddf8602.js"></script>

<br/>
<br/>
んで再コンパイルしてみたら解決したみたいで、別のエラーが。。。

<script src="https://gist.github.com/youyo/ca451741465d46a5d08d.js"></script>

<br/>
<br/>
グーグル先生に聞いたところ、こちらのサイトがヒット。
[http://zgadzaj.com/how-to-install-php-53-and-52-together-on-ubuntu-1204](http://zgadzaj.com/how-to-install-php-53-and-52-together-on-ubuntu-1204)

<br/>
<br/>
その中にこう書かれてあって、

```
EXT/GMP/GMP.C: IN FUNCTION ‘ZIF_GMP_RANDOM’:
EXT/GMP/GMP.C:1399:69: ERROR: ‘__GMP_BITS_PER_MP_LIMB’ UNDECLARED (FIRST USE IN THIS FUNCTION)
EXT/GMP/GMP.C:1399:69: NOTE: EACH UNDECLARED IDENTIFIER IS REPORTED ONLY ONCE FOR EACH FUNCTION IT APPEARS IN

This time it's PHP bug #50990. In one of comments there susan dot smith dot dev at gmail dot com suggested solution which works and does its magic:

I solved replacing the outdated __GMP_BITS_PER_MP_LIMB defined constant with GMP_LIMB_BITS. The latter is present in all previous versions, and MPIR define it too.

You have to edit file ext/gmp/gmp.c and replace one occurence of __GMP_BITS_PER_MP_LIMB with GMP_LIMB_BITS, in my case it was in line 1399.
```

`ext/gmp/gmp.c` このファイルの1399行目の `__GMP_BITS_PER_MP_LIMB` を `GMP_LIMB_BITS` に書き換えろってあった。  
書き換えて再度コンパイルしたら無事成功！  
あとは普通に `make install` して完了 :)  
  
---

## と思ったらphpがapache module方式で動かなかった

```
# apachectl -t
httpd: Syntax error on line 55 of /etc/httpd/conf/httpd.conf: Cannot load /usr/lib64/httpd/modules/libphp5.so into server: /usr/lib64/httpd/modules/libphp5.so: undefined symbol: unixd_config
```

グーグル先生は頼りになります。  
  
[http://d.hatena.ne.jp/rougeref/20120907](http://d.hatena.ne.jp/rougeref/20120907)

なにやらapache2.4とphp5.2の組み合わせでだけ発生するエラーらしい。  
言う通りに修正。  

<script src="https://gist.github.com/youyo/583d3d0a65e36bdd6ed5.js"></script>

再度コンパイルして今度こそ完了！！！

```
# apachectl -t
Syntax OK
```

## まとめ

- ちゃんと新しいものを使え
