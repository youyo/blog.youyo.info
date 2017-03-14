---
title: "CentOSのsystem領域にrubyの最新バージョンを手軽にインストールする"
thumbnailImage: images/eye-catch/default.png
thumbnailImagePosition: left
metaAlignment: left
date: 2014-12-05
categories:
- technology
tags:
- centos
- ruby
---

CentOS6系のパッケージでインストールされるrubyのバージョンは1.8.7です。さすがに低すぎるってことでもっと新しいバージョンを使おうってときに普通はrbenvやRVMを利用すると思います。
でもdeamonからrubyを使おうとしたとき、rbenvで入れたrubyって少し使いづらいです。。  
  
systemのrubyのバージョンを上げたいってとき、epelなどでもパッケージ提供されていないのでソースからインストールするしかないのかな〜って思ってます。  
今回aws-sdkを使おうとしたらバージョン低すぎるよ！って言われたのでどうにかすることにしました。

<!--more-->

```
# gem install aws-sdk
ERROR:  Error installing aws-sdk:
  nokogiri requires Ruby version >= 1.9.2.
```

## でもソースインストールってめんどくさい

僕は嫌いです。。  
コンパイルオプションの指定とかめんどいし。。

## ruby-build使えばいいんじゃね？

rbenvのプラグインであるruby-buildを直で使えば楽にソースインストールできるんじゃね？ってことでやってみました。

```
git clone https://github.com/sstephenson/ruby-build.git
cd ruby-build
./install.sh
ruby-build 2.1.5 /usr/local/ruby-2.1.5
ln -s /usr/local/ruby-2.1.5/bin/ruby /usr/local/bin/
ln -s /usr/local/ruby-2.1.5/bin/gem /usr/local/bin/

# ruby -v
ruby 2.1.5p273 (2014-11-13 revision 48405) [x86_64-linux]
```

## できました

`/usr/local/bin/` にシンボリックリンクを作成することでバージョンアップが必要になったときもこれで楽チンです！  
これでsystemのrubyで気軽に最新バージョン使えますね！

```
ruby-build 2.0.0-p598 /usr/local/ruby-2.0.0-p598
rm -f /usr/local/bin/ruby && ln -s /usr/local/ruby-2.0.0-p598/bin/ruby /usr/local/bin/
rm -f /usr/local/bin/gem && ln -s /usr/local/ruby-2.0.0-p598/bin/gem /usr/local/bin/

# ruby -v
ruby 2.0.0p598 (2014-11-13 revision 48408) [x86_64-linux]
```
