---
title: "zabbix-senderが使えない環境でもhttpでデータを送る"
thumbnailImage: images/eye-catch/gopher.png
thumbnailImagePosition: left
metaAlignment: left
date: 2018-10-02
categories:
- technology
tags:
- zabbix
- go
---

通常zabbix-serverに対してデータをpushするときはzabbix-senderを使用します. しかし環境によってはzabbix-senderをインストール出来ないこともあります.  
そういった場合には直接クライアントがzabbix-serverとtcp接続を行い通信してもよいのですが, 今回はクライアント側の実装をシンプルにしたかったのでhttpでやり取りできるようにproxy-serverの参考実装を作ってみました. クライアントからhttpでjsonデータを送り, それを受け取ってzabbix-serverへtcp接続して受け渡すようにしています.

<!--more-->

<script src="https://gist.github.com/youyo/03f55553773b14f4dad2102c229874eb.js"></script>

`go run main.go` などで立ち上げ, jsonをpostしてあげるとzabbix-serverからのレスポンスが返ってきます.

```
$ go run main.go

   ____    __
  / __/___/ /  ___
 / _// __/ _ \/ _ \
/___/\__/_//_/\___/ v3.3.dev
High performance, minimalist Go web framework
https://echo.labstack.com
____________________________________O/_______
                                    O\
⇨ http server started on [::]:1323
```

```
$ curl -s -X POST -H 'Content-Type: application/json' -d '{"host":"some-host","key":"some-key","value":"some-value"}' http://127.0.0.1:1323/
ZBXDZ{"response":"success","info":"processed: 0; failed: 1; total: 1; seconds spent: 0.000021"}%
```
