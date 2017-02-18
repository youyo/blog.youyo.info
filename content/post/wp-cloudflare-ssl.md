---
title: "CloudFlareの無料SSL/httpsリダイレクトを使用しているサイトにwordpressを突っ込む"
thumbnailImage: //www.cloudflare.com/img/cf-facebook-card.png
thumbnailImagePosition: left
metaAlignment: left
date: 2016-01-14
categories:
- technology
tags:
- cloudflare
- wordpress
---

まずやりたいこととしてはタイトルの通り。  
既に運用している `https://test.youyo.info` (仮)の直下に `https://test.youyo.info/blog` というwordpressサイトを突っ込みたい。  
最初は何も考えず普通に設置してみてインストール画面をみたらcssやらjsが読み込まれなかった。  
あれーと思ったらphpが吐くリンク先が `http` で出力されているためだった。  
<!--more-->
  
wordpressから `https` でリンクを吐いてもらわないと困るなーってことでググった結果、下記内容を `wp-config.php` に追加すればいいって結論に。  

```
// use https
define('FORCE_SSL_LOGIN', true);
define('FORCE_SSL_ADMIN', true);
if ($_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https') $_SERVER['HTTPS']='on';
```

CloudFlareからは `HTTP_X_FORWARDED_PROTO` ヘッダーが飛んでくるので、それがあれば `['HTTPS']='on'` とした。  
  
[Does CloudFlare include an X-Forwarded-For or X-Forwarded-Proto header?](https://support.cloudflare.com/hc/en-us/articles/200170946-Does-CloudFlare-include-an-X-Forwarded-For-or-X-Forwarded-Proto-header-)  
  
これで無事css/jsやらをhttpsで読み込めるようになった。よかった。
