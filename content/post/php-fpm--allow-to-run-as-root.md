---
title: "php-fpmはrootで動かない"
date: 2016-02-15
comments: true
tags: ["php","php-fpm"]
---

知らないサーバで `php-fpm` 止まってるよーなんとかしてー  
<br/>
っていう状況があってその時の対応メモ。

---

再起動してみると、

```
# service php-fpm start
Starting php-fpm: [15-Feb-2016 13:22:04] ERROR: [pool www] please specify user and group other than root
[15-Feb-2016 13:22:04] ERROR: FPM initialization failed
                                                           [FAILED]
```

こんなこと言われて起動できなかった。  
  
なにやらrootで動かさないとパーミション周りでエラーが出るからrootで動かしてくれ！ってことになり、ググったら `--allow-to-run-as-root` オプションをつけてあげればいいとわかった。  
起動スクリプトを編集して無事起動 :)
