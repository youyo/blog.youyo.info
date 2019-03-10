---
title: "廃止予定のS3署名バージョン2API利用をCloudWatchEventで検出する設定をCloudformationで書いた"
thumbnailImage: images/eye-catch/aws.jpg
thumbnailImagePosition: left
metaAlignment: left
date: 2019-03-10
categories:
- technology
tags:
- aws
- s3
---

「[廃止予定のS3署名バージョン2API利用をCloudWatchEventで検出してみた](https://dev.classmethod.jp/cloud/aws/check-s3-sig2-usage-cloudwatch/)」を見ていろいろ設定して回らなきゃな-と思ったのでcloudformationで書いてみました。  
  
https://github.com/heptagon-inc/check-sigv2-s3-api-request  

<!--more-->

## 使い方

とりあえずデプロイしてもらうと `EmailAddress` で指定したアドレスに通知が来るようになります。あとは順次対応していきましょう。

```
aws cloudformation deploy \
	--stack-name check-sigv2-s3-api-request \
	--template-file template.yaml \
	--parameter-overrides 'EmailAddress=notification-xxxxxxx@example.com'
```

参考記事中ではSQSに入れていますがSNS経由でのメール通知に変更しています。理由としては, 僕はきっとめんどくさがってキューを確認したりはしないのです。  
  
ただメールがたくさん来られても迷惑というのはあるので, slackに通知専用捨てチャンネル作ってそこにメールインテグレーション入れてそのメールアドレスに通知が来るようにして集約する予定です。

## まとめ

ただのCloudformationテンプレートです。  
そのままでもいいですし, 通知周りなど自由に改変するなどしてご利用ください。
