---
title: "pip install でバージョン指定"
date: 2016-02-09
comments: true
tags: ["python","pip","ansible"]
---

久しぶりに `ansible` インストールしたらバージョンが2系入るようになってた。

```
$ pip install ansible
$ ansible --version
ansible 2.0.0.2
```

お！っと思って既存のplaybook実行してみたら全然動かなくて :|  
直すのがめんどくさかったのでバージョンを下げた。  
調べた感じだと `package==version` の形で指定すれば良さそう。

```
$ pip uninstall ansible
$ pip install ansible\==1.9.4
$ ansible --version
ansible 1.9.4
```

無事入りました :)
