---
title: "RDS for MySQLを再起動したら文字化けした"
thumbnailImage: //doxwk67ta2990.cloudfront.net/wp-content/uploads/2016/05/logo-amazon-rds.gif
thumbnailImagePosition: left
metaAlignment: left
date: 2016-06-14
categories:
- technology
tags:
- mysql
- aws
- rds
---

## まとめ

- ZABBIXのデータベースとして使用しているRDS for MySQLを再起動してみた
- アラート通知だけが文字化けした
- `skip-character-set-client-handshake` 有効にしたら直った
<!--more-->

## 環境

- RDS for MySQL 5.6.27
- Amazon Linux AMI release 2016.03
- ZABBIX 3.0.1

## 事象

RDSとZABBIXサーバー再起動したら文字化けするようになってしまった。  
なんでだろうと思ってとりあえず文字コード確認したら、一部 `utf8` になってた。( `utf8mb4` に統一してた)

```
mysql> show variables like "chara%";
+--------------------------+-------------------------------------------+
| Variable_name            | Value                                     |
+--------------------------+-------------------------------------------+
| character_set_client     | utf8                                      |
| character_set_connection | utf8                                      |
| character_set_database   | utf8mb4                                   |
| character_set_filesystem | binary                                    |
| character_set_results    | utf8                                      |
| character_set_server     | utf8mb4                                   |
| character_set_system     | utf8                                      |
| character_sets_dir       | /rdsdbbin/mysql-5.6.27.R1/share/charsets/ |
+--------------------------+-------------------------------------------+
```

あれー?と思いつつパラメーターグループで `skip-character-set-client-handshake` 有効にしてrebootしたら直った。

```
mysql> show variables like "chara%";
+--------------------------+-------------------------------------------+
| Variable_name            | Value                                     |
+--------------------------+-------------------------------------------+
| character_set_client     | utf8mb4                                   |
| character_set_connection | utf8mb4                                   |
| character_set_database   | utf8mb4                                   |
| character_set_filesystem | binary                                    |
| character_set_results    | utf8mb4                                   |
| character_set_server     | utf8mb4                                   |
| character_set_system     | utf8                                      |
| character_sets_dir       | /rdsdbbin/mysql-5.6.27.R1/share/charsets/ |
+--------------------------+-------------------------------------------+
```

今まで何故化けてこなかったのかは不明...
