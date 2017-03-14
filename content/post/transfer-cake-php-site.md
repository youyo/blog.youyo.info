---
title: "Cake phpで作られたサイトのホスト名変えたときのエラー対応"
thumbnailImage: images/eye-catch/default.png
thumbnailImagePosition: left
metaAlignment: left
date: 2014-05-14
categories:
- technology
tags:
- php
---

cake phpで作られたサイトを別サーバに移して、ホスト名変更しました。  
するとブラウザは真っ白。。ログにはこんなエラーが。。。

```
PHP Fatal error:  Class 'Dispatcher' not found in /PATH/TO/app/webroot/index.php on line 87
```

<!--more-->

Dispatcherが定義されているファイルはちゃんと読み込まれてるっぽいのになぜ？？  
と悩みググりまくってたら回答ありました。  
キャッシュファイルを消せばいいらしいです。

```
rm -rf app/tmp/cache/*
```

これで無事サイト表示できるようになりました！
