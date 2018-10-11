---
title: "fluent-plugin-postfix-parser作った"
thumbnailImage: images/eye-catch/postfix.jpg
thumbnailImagePosition: left
metaAlignment: left
date: 2018-10-11
categories:
- technology
tags:
- postfix
- fluentd
- ruby
---

filterプラグイン作りました.  
https://github.com/youyo/fluent-plugin-postfix-parser  
https://rubygems.org/gems/fluent-plugin-postfix-parser  

<!--more-->

## なぜ作った?

すでにいくつかpostfixのログをparseするfluentdプラグインは存在していましたが, 僕は複数行に渡るログをキューIDでまとめて1行にしてくれるものが欲しかったので作りました. Goで作ったCLIのfluentd-pluginバージョンです.  
https://blog.youyo.info/post/2018/10/10/create-postfix-log-parser/

## 使い方

インストール後, 下記のようなconfigを書いて動かせばokです.

```
# td-agent-gem install fluent-plugin-postfix-parser
```

```
<source>
  @type tail
  @id input_tail
  format none
  path /var/log/maillog
  tag postfix.maillog
</source>

<filter postfix.maillog>
  @type grep
  <exclude>
    key message
    pattern (dovecot|postfix-script)
  </exclude>
</filter>

<filter postfix.maillog>
  @type postfix_parser
  key message
</filter>

<match postfix.**>
  @type file
  @id output_file
  path /var/log/td-agent/test.log
</match>
```

```
# service td-agent restart
```

うまく動いていれば, 次のようなログが流れてくるはずです. (見やすいように改行入れてます)

```
2018-10-11T23:36:33+09:00	postfix.maillog	{
  "time": "Oct 11 23:36:32",
  "hostname": "mail",
  "process": "postfix/smtpd[17044]",
  "queue_id": "4E8373ABAF",
  "client_hostname": "xxxxxxxxxxx.ppp-bb.dion.ne.jp",
  "client_ip": "xxx.xxx.xxx.xxx",
  "messages": [
    {
      "time": "Oct 11 23:36:33",
      "to": "xxxxx@gmail.com",
      "orig_to": null,
      "relay": "gmail-smtp-in.l.google.com[74.125.204.26]:25",
      "relay_hostname": "gmail-smtp-in.l.google.com",
      "relay_ip": "74.125.204.26",
      "relay_port": 25,
      "delay": 1.5,
      "delays": "0.12/0.03/0.71/0.63",
      "dsn": "2.0.0",
      "status": "sent",
      "comment": "250 2.0.0 OK 1539268593 y193-v6si25866437pgd.558 - gsmtp"
    }
  ],
  "message_id": "fd693cc3-832e-99bb-ec7a-df82a8f6c7ca@heptagon.co.jp",
  "from": "xxxxx@xxxxxx.com",
  "size": 899,
  "nrcpt": 1,
  "queue_status": "queue active"
}
```

## その他

キューIDが出てこないログについては無視してしまっているので, それだとダメだという方には合わないものです.  
もし試してみようかなという方がいましたら, ぜひフィードバック頂けると嬉しいです.
