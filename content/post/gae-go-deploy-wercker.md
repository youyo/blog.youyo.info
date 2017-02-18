---
title: "werckerを使ってGAE/GOにデプロイしてFastlyでURLベースのルーティングをする"
date: 2016-06-15
comments: true
tags: ["hugo","gae","gcp","wercker","go","fastly"]
---

このブログは `hugo` で静的htmlを生成して `GAE/GO` にデプロイしています。(http://blog.youyo.info/)  
旧ブログも `Amazon S3` で同じドメインでホストしています。(http://blog.youyo.info/blog/archives/)  
  
この２つを同じドメインで運用するにあたってURLベースでのルーティングを `CloudFront` で実現していて、 `Circle CI` を使って `git push` をトリガーにしてデプロイ/キャッシュクリアして **いました**。  
  
先週あたりまでこの構成だったのですが、今は `CloudFront` => `Fastly` , `CircleCI` => `Wercker` へと変更しました。  
  
## 何故変更したか？

- CloudFrontのキャッシュクリアが遅い
- CircleCIでデプロイ実行時に都度環境作成するのが遅い
- Fastlyもwerckerもなんとなく興味あって使ってみたかった

3番目の理由が一番大きかったりします。やってみたかっただけ。

## Fastly?

VarnishをベースとしたCDNサービスです。高速なキャッシュのクリアが特徴です。今回はここに惹かれたので使ってみることにしました。  
  
詳しくはこちらをお読みください。  
[次世代CDNのFastlyで即時削除(Instant Purge)を体感した](http://dev.classmethod.jp/server-side/fastly1/)
  
### URLベースのルーティング設定

fastlyのアカウント作成やDomain登録などは省略します。  

---

- Domain登録後、ルーティング先(backend)の追加登録を行う

今回は `/blog/` , `/stylesheets/` , `/javascripts/` の場合にS3に向けたかったので、同じHostですが3つ登録しました。メインはGAEです。

![](/images/fastly1.png)

---

- Backendの `Conditions` を設定する

![](/images/fastly2.png)

backendの右側の歯車をクリックすると `Conditions` が選択できます。

![](/images/fastly3.png)

`Apply If...` のところに条件を記述できます。  
`req.url ~ "^/stylesheets/"` と書くことでURLが `/stylesheets/` から始まる場合にルーティングされます。今回は残り２つも同じように設定します。  
  
`VCL` をクリックすることでCurrentVersionの設定(VCL)を確認できます。

```
# default conditions
set req.backend = GAE;
# end default conditions

# Request Condition: blog Prio: 10
if( req.url ~ "^/blog/" ) {
	set req.backend = F_S3_blog;
}
#end condition

# Request Condition: stylesheets Prio: 10
if( req.url ~ "^/stylesheets/" ) {
	set req.backend = F_S3_CSS;
}
#end condition

# Request Condition: javascripts Prio: 10
if( req.url ~ "^/javascripts/" ) {
	set req.backend = F_S3_JS;
}
#end condition
```

設定を確認して問題なければ `Activate` すればokです。

### キャッシュPurge

ダッシュボードからもできますが、もちろんAPIでも操作できます。
`account` からAPIキーを発行して、それを一緒にpostするよくあるシンプルな形です。
purgeにはいくつか種類がありますが、キャッシュ全体を削除する場合には下記コマンドで良さそうです。  
  
詳細をドキュメントを。  
https://docs.fastly.com/api/purge

```
$ curl -X POST -H "Fastly-Key: ${FASTLY_APIKEY}" https://api.fastly.com/service/${FASTLY_SERVICE_ID}/purge_all
```

`FASTLY_SERVICE_ID` はDomain名の下に書かれているのでそれを。  
  
実際やってみるとわかるのですが、本当にキャッシュのクリアが一瞬でびっくりします..!

---

## Wercker?


werckerはCIにdockerコンテナを使用できます。なので自分に必要な環境の揃ったコンテナをあらかじめ用意しておくことでCIにかかる時間を短縮できるのではないかと思い試してみました。複数(または単一)のフェーズ/複数(または単一)のステップで構成されます。それぞれのフェーズで別のコンテナを使用できます。とりあえずwercker.ymlを見てもらうのが手っ取り早いと思うのでご覧ください。下記が今回作成したものになります。

<script src="https://gist.github.com/youyo/5719d96f6140c75026bd555f8e5a8e86.js"></script>

- build/deploy/cacheの3つのフェーズで構成
- それぞれ専用のコンテナを作成して使用( `google/cloud-sdk:latest` はgoogle提供のを使用)
- なんとなくぱっと見でわかると思う

#### 小技

- gcloudコマンドでGAE/GOにデプロイするにあたって、なんらかの形で認証しておく必要があります。今回は認証に使用するサービスアカウントのjsonファイルを、 `openssl` コマンドで暗号化して一緒にデプロイします。デプロイの過程で復号化を行い、 `gcloud auth activate-service-account` コマンドで認証するようにしました
- 復号化に使用するパスフレーズはwerckerのProtectedな環境変数で渡すので問題なし。
- 詳細はこちら [http://qiita.com/ikuwow/items/1cdb057352c06fd3d727](http://qiita.com/ikuwow/items/1cdb057352c06fd3d727)

#### 実際やってみてわかったこと

- CI開始後に環境構築が入らないので早くなるかと思っていたが、毎回コンテナイメージのダウンロードが入るので重いイメージを使用しているとそんなに早くならない
- `context canceled` というエラーを吐いて失敗する

2番目の理由がわからず悪戦苦闘... いまだ解決せずなので原因をご存知の方がいればご一報ください。。

---

## まとめ

- キャッシュクリア早くなったし満足！
- CIもちょっとだけ早くなったし満足！
