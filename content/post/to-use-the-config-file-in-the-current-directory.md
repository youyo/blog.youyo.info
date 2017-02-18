---
title: "カレントディレクトリにあるmy.cnfファイルから設定を読み込む"
thumbnailImagePosition: left
thumbnailImage: //d1u9biwaxjngwg.cloudfront.net/cover-image-showcase/city-750.jpg
coverImage: //d1u9biwaxjngwg.cloudfront.net/cover-image-showcase/city.jpg
metaAlignment: center
coverMeta: out
date: 2016-09-26
categories:
- tranquilpeak
tags:
- mysql
- direnv
---

カレントディレクトリに置いてある `my.cnf` ファイルから設定読みこみたいなーと思って調べてみたら、どうやら普通にはできないようでした。  
([参考:基礎MySQL ~その２~ my.cnf (設定ファイル)](http://qiita.com/yoheiW@github/items/bcbcd11e89bfc7d7f3ff#mycnf%E3%81%AE%E8%AA%AD%E3%81%BF%E8%BE%BC%E3%81%BF%E9%A0%86%E5%BA%8F))  
<!--more-->
  
でも `$MYSQL_HOME/my.cnf` は環境変数使ってるし、ごにょればうまくやれそうだなーってことで `direnv` 使うことにしました。 `direnv` って何？という方はこちらをご覧ください。([参考:direnvを使おう](http://qiita.com/kompiro/items/5fc46089247a56243a62))  
<br/>
<br/>
<br/>
### direnvを使って環境変数[MYSQL_HOME]をカレントディレクトリに設定する

やることはシンプルで、direnvを使って環境変数[MYSQL_HOME]をカレントディレクトリに設定するだけです。

```
// プロジェクトルートに移動
$ cd ~/src/github.com/youyo/sample

// direnvで環境変数設定
$ direnv edit .
export MYSQL_HOME='/Users/youyo/src/github.com/youyo/sample'

// my.cnfファイルを作成
$ cat <<EOL> my.cnf
[client]
user = sample
password = sample
host = localhost
database = sample
EOL
$ chmod 640 my.cnf
```

これでカレントディレクトリのmy.cnfファイルを読み込むことができました！
