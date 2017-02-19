---
title: "Hugoで作ったサイトをGoogle App Engineで公開した"
thumbnailImage: images/eye-catch/hugo.png
thumbnailImagePosition: left
metaAlignment: left
date: 2015-10-23
categories:
- technology
tags:
- gae
- hugo
- gcp
---

ブログを作りなおすにあたってOctopressからHugoに移行しました。理由はなんとなくです。気分です。  
で、OctopressのときはS3でホストしてたのですが同じじゃつまらないのでGoogle Cloud Storageでホストしてみました。でもデプロイ時にコンテンツのパーミッションを設定する方法がわからなかったり差分だけど持っていくやり方がわからなかったのでイマイチだと感じていました。  
  
なんかないかなーと調べてたらGAEで静的ファイルを配信する方法が見つかったのでサクッと移してみました。

<!--more-->

---

## Hugoでサイト作成

いろんなところで紹介されている感じで進めます。

```
hugo new site example.com
cd example.com
hugo new post/helloworld.md
vim content/post/helloworld.md
-----------------------------------
+++
date = "2015-10-23T13:36:01+09:00"
draft = false
title = "helloworld"

+++

# Hello World
-----------------------------------

mkdir themes
cd themes
git clone https://github.com/digitalcraftsman/hugo-agency-theme

cd ..
vim config.toml
-----------------------------------
theme = "hugo-agency-theme"
-----------------------------------

hugo 
```

これで `public/` 配下にファイルが作成されたと思います。

---

## GAEにデプロイ

- Google Developers Console にログインしてプロジェクトを作成
- `app.yaml` を作成
- `goapp deploy -application [project-id] app.yaml` でデプロイ

流れとしてはこんな感じで、 `app.yaml` の中身が重要になります。

``` yaml
application: blog-youyo-info
version: 1
runtime: go
api_version: go1

handlers:
- url: /(.*\.css)
  mime_type: text/css
  static_files: public/\1
  upload: public/(.*\.css)

- url: /(.*\.html)
  mime_type: text/html
  static_files: public/\1
  upload: public/(.*\.html)

- url: /(.*\.ico)
  mime_type: image/x-icon
  static_files: public/\1
  upload: public/(.*\.ico)

- url: /(.*\.js)
  mime_type: text/javascript
  static_files: public/\1
  upload: public/(.*\.js)

- url: /(.*\.ttf)
  mime_type: font/truetype
  static_files: public/\1
  upload: public/(.*\.ttf)

- url: /(.*\.woff)
  mime_type: application/x-font-woff
  static_files: public/\1
  upload: public/(.*\.woff)

- url: /(.*\.xml)
  mime_type: application/xml
  static_files: public/\1
  upload: public/(.*\.xml)

- url: /(.*\.(bmp|gif|ico|jpeg|jpg|png))
  static_files: public/\1
  upload: public/(.*\.(bmp|gif|ico|jpeg|jpg|png))

- url: /(.+)/
  static_files: public/\1/index.html
  upload: public/(.+)/index.html

- url: /(.+)
  static_files: public/\1/index.html
  upload: public/(.+)/index.html

- url: /
  static_files: public/index.html
  upload: public/index.html
```

参考URL : https://gist.github.com/darktable/873098

参考URLそのまんまです。  
各ファイルへのルーティング設定を書いていけばokです。  
あとはdeployしてGAE側でカスタムドメインを設定すれば出来上がりです。(めんどくさくなった
  
とりあえず記事書いてこんな感じのスクリプト実行するだけでdeploy完了するので楽になりました。

```
#!/bin/zsh

hugo
sleep 1
goapp deploy -application blog-youyo-info app.yaml
```

---

## その他

- CloudFrontをL7バランサー代わりにして旧ブログ(s3にあるやつ)への振り分けやってる
- CloudFrontがキャッシュしまくってくれるからインスタンスが全然起動しなくて安上がり(計算してないけど
- サクッととか最初に言ったけど実は5時間くらいかかった
