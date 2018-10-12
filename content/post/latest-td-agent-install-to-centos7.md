---
title: "MessagePack::UnknownExtTypeError unexpected extension type"
thumbnailImage: images/eye-catch/fluentd.png
thumbnailImagePosition: left
metaAlignment: left
date: 2018-10-12
categories:
- technology
tags:
- fluentd
- td-agent
---

centos6とcentos7にfluentdをインストールしたくて, ドキュメント通りに進めたところバージョンの異なるものがインストールされました. その状態でout_forward, in_forwardでログを送受信したところ, タイトルにあるエラーが発生しました.  
docs: https://docs.fluentd.org/v0.12/articles/install-by-rpm#step-1:-install-from-rpm-repository  
  
バージョン違いにより発生する可能性のあるエラーだというのはこちらを参照しました.  
ref: https://qiita.com/kawashinji/items/ce416d13581d23ed11c7  

<!--more-->

```
# td-agent 2.5 or later. Only CentOS/RHEL 6 and 7 for now.
$ curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.5.sh | sh
```

```
// centos6
# /opt/td-agent/embedded/bin/fluentd --version
fluentd 1.2.6

// centos7

# /opt/td-agent/embedded/bin/fluentd --version
fluentd 0.12.43
```

centos7のほうでyum updateしても新しいバージョンのものは降ってこなかったのですが, 下記にtd-agent3があったのでインストールしてみると`fluentd 1.2.2`が入っていたので無事解決.  
https://td-agent-package-browser.herokuapp.com/3/redhat/7/x86_64

```
# yum install http://packages.treasuredata.com.s3.amazonaws.com/3/redhat/7/x86_64/td-agent-3.2.0-0.el7.x86_64.rpm
# /opt/td-agent/embedded/bin/fluentd --version
fluentd 1.2.2
```
