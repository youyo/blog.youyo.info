---
title: "awsloginコマンドでMFAサポートした"
thumbnailImage: images/eye-catch/aws.jpg
thumbnailImagePosition: left
metaAlignment: left
date: 2017-03-17
categories:
- technology
tags:
- aws
- go
---

以前 [awslogin](https://github.com/youyo/awslogin) というコマンドを作った.  
詳細についてはこちらを参照.([awsloginコマンド作った](/post/2017/02/20/create-command-awslogin/))  
  
公開したところ「MFA対応は? 」というリアクションをいただいた.  
すっかり忘れていたというのが正直なところ.  
  
ということで対応した.

<!--more-->

![](/images/awslogin_mfa.gif)

## 設定

awslogin自体のインストールについては[こちら](/post/2017/02/20/create-command-awslogin/).  
  
MFAを使用するにはこちらのドキュメントにある `mfa_serial` の設定を `~/.aws/config` に追加する.  
http://docs.aws.amazon.com/cli/latest/userguide/cli-roles.html

>Next, add a line to the role profile that specifies the ARN of the user's MFA device:
```
[profile marketingadmin]
role_arn = arn:aws:iam::123456789012:role/marketingadmin
source_profile = default
mfa_serial = arn:aws:iam::123456789012:mfa/jonsmith
```
>The role requires MFA in order to be assumed by any user, but the actual MFA device ARN is specified in the role profile's configuration on the user's machine and varies between users. This allows many users to assume the same role using their individual MFA devices.

これは `aws-cli` でAssumeRole+MFAを使用するときの設定だ. 独自設定を追加するわけではないので安心して設定してほしい.  
`mfa_serial` の設定があると, MFAコードの入力を促すので入力する. するとログインできる.  
  
MFAがないので使用を躊躇っていた人がもしいるなら, ぜひこの機会に試してみてほしい.
