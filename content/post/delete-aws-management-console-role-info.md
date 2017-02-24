---
title: "AWSマネジメントコンソールのSwitchRoleのヒストリーの消し方"
thumbnailImage: images/eye-catch/aws.jpg
thumbnailImagePosition: left
metaAlignment: left
date: 2017-02-24
categories:
- technology
tags:
- aws
---

SwitchRoleをすると過去のヒストリーが残ると思います。  

![/images/aws-history.png](/images/aws-history.png)

こんな感じのやつ。  

<!--more-->

## 他にもあるかもしれませんがとりあえずうまくいったやり方

- ブラウザのCookieから `noflush_awsc-roleInfo` という名前のCookieを削除する

以上です。
