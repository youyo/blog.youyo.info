---
title: "grl.i-o.shというサイトを作った"
thumbnailImage: images/eye-catch/github.png
thumbnailImagePosition: left
metaAlignment: left
date: 2017-03-08
categories:
- technology
tags:
- github
- ruby
---

作った.

http://grl.i-o.sh/  
https://github.com/youyo/grl.i-o.sh

<!--more-->

## これは何？

Github releasesにある最新のダウンロードパッケージのURLを返してくれるサイト.

## 使用例

- `https://github.com/youyo/awslogin` にある最新のダウンロードパッケージを取得したい.

```
$ url=`curl -s http://grl.i-o.sh/youyo/awslogin`
$ echo ${url}
https://github.com/youyo/awslogin/releases/download/0.1.2/awslogin_darwin_amd64.zip
$
$ wget ${url}
$ ls
awslogin_darwin_amd64.zip
```

シンプルな使い方としてはこんな感じ.  

## 使用例2

- `https://github.com/heptagon-inc/recorder` にある複数の最新ダウンロードパッケージのうち,  `darwin_amd64` 用のものを取得したい.

```
$ # 複数URlが返却される
$ curl -s http://grl.i-o.sh/heptagon-inc/recorder
https://github.com/heptagon-inc/recorder/releases/download/v0.4.1/recorder_darwin_amd64.zip,https://github.com/heptagon-inc/recorder/releases/download/v0.4.1/recorder_linux_amd64.zip
$
$ # suffixを指定することで特定のダウンロードパッケージURLを取得
$ url=`curl -s 'http://grl.i-o.sh/heptagon-inc/recorder?suffix=darwin_amd64.zip'`
$ echo ${url}
https://github.com/heptagon-inc/recorder/releases/download/v0.4.1/recorder_darwin_amd64.zip
$
$ wget ${url}
$ ls
recorder_darwin_amd64.zip
```

## なぜ作ったか？

今後複数のサーバに `Mitamae` を入れることになりそうだったので, そのデプロイ方法について考えてみた. Github Releasesにある最新のバージョンを毎度調べてからインストールするっていうのはちょっと面倒だったので, サクッと最新のダウンロードURLが取得したかったっていうのが理由.  
  
---

ちなみに `Mitamae` のインストールはバージョンが変わってもこんな感じでやれる.  
手順が変わらないっていい.  

```
# curl -sL -o /usr/sbin/mitamae `curl -s 'http://grl.i-o.sh/k0kubun/mitamae?suffix=x86_64-linux'`
# chmod 700 /usr/sbin/mitamae
# mitamae version
MItamae v1.4.2
```
