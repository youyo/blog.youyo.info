---
title: "postfixのログをパースしてjsonで吐き出すツール作った"
thumbnailImage: images/eye-catch/postfix.jpg
thumbnailImagePosition: left
metaAlignment: left
date: 2018-10-10
categories:
- technology
tags:
- postfix
- go
---

postfixのログをパースしてjsonで吐き出すツールを作りました.  
https://github.com/youyo/postfix-log-parser  
  
postfixのログってqueue-idをキーにして複数行を見ないと一連の流れが追えないっていうのがすごく面倒くさくて, それを解決するために作りました. 例えば, 下記のようなログを標準入力から渡してあげると次のようなjsonにして返してくれます.

```
Oct 10 15:59:28 mail postfix/smtpd[1830]: connect from example.com[127.0.0.1]
Oct 10 15:59:28 mail postfix/smtpd[1830]: C6E0DDB74006: client=example.com[127.0.0.1]
Oct 10 15:59:28 mail postfix/cleanup[1894]: C6E0DDB74006: message-id=<A40CF64D-7F2D-42E4-8A76-CBFFF64A6EB1@example.com>
Oct 10 15:59:28 mail postfix/qmgr[18719]: C6E0DDB74006: from=<test@example.com>, size=309891, nrcpt=1 (queue active)
Oct 10 15:59:28 mail postfix/smtpd[1830]: disconnect from example.com[127.0.0.1]
Oct 10 15:59:32 mail postfix/smtp[1874]: C6E0DDB74006: to=<test@example.ddd>, relay=example.ddd[192.168.0.30]:25, delay=3.4, delays=0.11/0/0.38/2.9, dsn=2.0.0, status=sent (250 2.0.0 OK 1539154772 az9-v6si5976496plb.190 - gsmtp)
Oct 10 15:59:32 mail postfix/qmgr[18719]: C6E0DDB74006: removed
```

```
# cat /path/to/log | ./postfix-log-parser
{
  "time": "0000-10-10T15:59:28+09:00",
  "hostname": "mail",
  "process": "postfix/smtpd[1830]",
  "queue_id": "C6E0DDB74006",
  "client_hostname": "example.com",
  "client_ip": "127.0.0.1",
  "message_id": "A40CF64D-7F2D-42E4-8A76-CBFFF64A6EB1@example.com",
  "from": "test@example.com",
  "messages": [
    {
      "time": "0000-10-10T15:59:32+09:00",
      "to": "test@example.ddd",
      "status": "sent",
      "message": "to=<test@example.ddd>, relay=example.ddd[192.168.0.30]:25, delay=3.4, delays=0.11/0/0.38/2.9, dsn=2.0.0, status=sent (250 2.0.0 OK 1539154772 az9-v6si5976496plb.190 - gsmtp)"
    }
  ]
}
```

<!--more-->

送信先が複数あっても問題ないです.  
  
現状postfix以外のdovecotなどのログが混じっていたり, parseできないものがあるとpanicを起こしてしまうのでこのあたりは直していこうと思います.
