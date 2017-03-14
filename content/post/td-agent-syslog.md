---
title: "Fluentdでsyslog受信しようとしたらハマった"
thumbnailImage: images/eye-catch/default.png
thumbnailImagePosition: left
metaAlignment: left
date: 2014-11-14
categories:
- technology
tags:
- fluentd
- syslog
---

スイッチとかのログを集めようと思って下記のような設定をしてテストしてみるも、エラーを吐いてうまくいかない。

<!--more-->

```
<source>
  type syslog
  port 514
  bind 192.168.21.1
  tag network1
</source>

<match network1.local0.*>
  type file
  buffer_type file
  path /var/log/td-agent/test.log
  compress gzip
</match>
```

こんなエラーを吐く。

```
2014-11-14T19:40:31+09:00    fluent.error    {"error":"invalid time format: value = 'administrator' succeeded for, error_class = ArgumentError, error = invalid strptime format - `%b %d %H:%M:%S'","message":"\"<174>'administrator' succeeded for SSH: 192.168.20.2 admin\" error=\"invalid time format: value = 'administrator' succeeded for, error_class = ArgumentError, error = invalid strptime format - `%b %d %H:%M:%S'\""}
```

なんでや。。。  
と思いつつ、ググりまくっていたらformatを変更すればいいという情報にたどり着いた。

https://groups.google.com/forum/#!topic/fluentd/k0HU1Dkbazs

format noneを追加すればいいらしい。  
試したところバッチリ動きました！

```
<source>
  type syslog
  format none
  port 514
  bind 192.168.21.1
  tag network1
</source>

<match network1.local0.*>
  type file
  buffer_type file
  path /var/log/td-agent/test.log
  compress gzip
</match>
```

```
2014-11-14T19:47:19+09:00    network1.local5.info    {"message":"Login succeeded for SSH: 192.168.20.2 admin"}
2014-11-14T19:47:23+09:00 network1.local5.info    {"message":"'administrator' succeeded for SSH: 192.168.20.2 admin"}
2014-11-14T19:47:26+09:00 network1.local5.info    {"message":"Configuration saved in \"CONFIG0\" by SSH(admin)"}
2014-11-14T19:52:26+09:00 network1.local5.info    {"message":"Logout from SSH: 192.168.20.2 admin"}
```
