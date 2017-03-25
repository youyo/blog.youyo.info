---
title: "awsloginコマンド作った"
thumbnailImage: images/eye-catch/aws.jpg
thumbnailImagePosition: left
metaAlignment: left
date: 2017-02-20
categories:
- technology
tags:
- aws
- go
---

`awslogin` というコマンドを作りました.  
[https://github.com/youyo/awslogin](https://github.com/youyo/awslogin)  
  
[update]  
[MFA対応した](/post/2017/03/17/awslogin_support_mfa/)


## これは何？

マネジメントコンソールにコマンド一発でログインできます.  

<!--more-->

## 使い方

- バイナリダウンロード
- zshrc設定
- ( `${HOME}/.aws./config` 設定)

---

現状はmacOSのみ対応です. (Linuxな人は `go build` . Windows? 知らない子ですね.)  
バイナリを持ってきてパスの通ったところにおく.  
  
[update]  
[Linux用のバイナリも作った](https://github.com/youyo/awslogin/releases)

```
$ curl -LO `curl -s 'http://grl.i-o.sh/youyo/awslogin?suffix=darwin_amd64.zip'`
$ unzip awslogin_darwin_amd64.zip
```

`${HOME}/.zshrc` にこんな感じに書く.

```
$ vim ${HOME}/.zshrc
```

```zsh
function al-src () {
    local selected_arn=$(awslogin -l | peco --query "$LBUFFER")
    BUFFER="awslogin -r ${selected_arn}"
    zle accept-line
    zle clear-screen
}
zle -N al-src
bindkey '+_' al-src
```

みんな大好き `ghq + peco` の連携パターンです.  
キーバインドの割当などはご自由に.  
  
すでに `${HOME}/.aws./config` に対してAssume Role関連の設定が入っている方はこれで完了です.  
まだという方は, こちらを参考に設定してください.   
[http://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_roles_use_switch-role-cli.html](http://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_roles_use_switch-role-cli.html)

この状態で `+_` を叩くとpecoのクエリ画面に選択可能なprofile一覧が表示されます. そこから好きなものを選んで選択するとログインできます.  
デモ画面的にはこんな感じです.  


![動作画面](/images/awslogin_demo.gif)


## なぜ作った？

複数AWSアカウントを持っている場合, マネジメントコンソールへのログインっていうのはちょっとめんどくさいです. でもAWS側でもその辺は当然カバーされていて, `Switch Role` によるクロスアカウントアクセスの仕組みが提供されています. 僕も今までこれを使っていました. 昔に比べてアカウント切り替えがすごく楽になったし, 各Roleのリンクをブックマークしておけばサクッと切り替えられるし, 履歴も残ってるし, これなしじゃいろいろ辛いなぁって感じです. でもちょっとだけ不満があって,

- 履歴が5個までしか保存されない
- セッションが切れたときの再ログインがめんどくさい

ということです.  
  
まず, 履歴は5個じゃ全然足りません...  
上限もこちらで設定できるようになってもらえるとすごく嬉しい!  
  
次にSwitchRoleするためのソースIAM UserがにはMFAを設定しています. セッションが切れてもreloadすればなんとなく, あー今回は読み込めた, みたいな感じで続けられる場合もあります. でもそうではなく, ソースIAM Userでのログイン(MFAあり)からやり直さなければならない場合も多々あり, そういうときには `IAM User ログイン => MFA認証 => bookmarkからurl探してポチッ => Switch Roleポチッ` といった流れでログインしなければいけません.

**これはめんどくさい！！！**

以上が動機になります。

## 解決した？

- 履歴が5個までしか保存されない => `${HOME}/.aws.config` に書けば解決!
- セッションが切れたときの再ログインがめんどくさい => 一応解決したけど, 別の問題も発生...

別の問題というのは, 前のログインセッションが残っている状態で別のprofileでログインしようとすると, まずログアウトしてね〜という画面になってしまうということです..  

![aws_logout](/images/aws_logout.png)

別アカウントに切り替える際にはまずログアウトしてからログインという手順になったことで, 結果Switch Roleする場合とそんなに変わらないような...  
  
---

個人的にはこっちの方が好みだし, せっかく作ったんだしってことなので公開しました.  
少しでも誰かのお役に立てばいいな〜って感じです.
