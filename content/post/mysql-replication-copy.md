---
title: "インスタンスを複製してレプリケーション組んだら詰まった"
thumbnailImage: images/eye-catch/default.png
thumbnailImagePosition: left
metaAlignment: left
date: 2014-06-02
categories:
- technology
tags:
- mysql
---

ec2上にmysqlサーバ建てて、AMI作成してそこからインスタンスもう1台あげてレプリケーション組もうとしたら詰まったのでメモ。  
いつも通り設定して `start slave;` して `show slave status\G` したらなんかエラー吐いてIOスレッド止まってた。。。

<!--more-->

```
mysql> show slave status\G
*************************** 1. row ***************************
               Slave_IO_State:
                  Master_Host: 10.0.0.110
                  Master_User: repl
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin-log.000007
          Read_Master_Log_Pos: 120
               Relay_Log_File: relay-bin-log.000001
                Relay_Log_Pos: 4
        Relay_Master_Log_File: mysql-bin-log.000007
             Slave_IO_Running: No
            Slave_SQL_Running: Yes
              Replicate_Do_DB:
          Replicate_Ignore_DB:
           Replicate_Do_Table:
       Replicate_Ignore_Table:
      Replicate_Wild_Do_Table:
  Replicate_Wild_Ignore_Table:
                   Last_Errno: 0
                   Last_Error:
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 120
              Relay_Log_Space: 120
              Until_Condition: None
               Until_Log_File:
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File:
           Master_SSL_CA_Path:
              Master_SSL_Cert:
            Master_SSL_Cipher:
               Master_SSL_Key:
        Seconds_Behind_Master: NULL
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 1593
                Last_IO_Error: Fatal error: The slave I/O thread stops because master and slave have equal MySQL server UUIDs; these UUIDs must be different for replication to work.
               Last_SQL_Errno: 0
               Last_SQL_Error:
  Replicate_Ignore_Server_Ids:
             Master_Server_Id: 110
                  Master_UUID:
             Master_Info_File: /var/lib/mysql/master.info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Slave has read all relay log; waiting for the slave I/O thread to update it
           Master_Retry_Count: 86400
                  Master_Bind:
      Last_IO_Error_Timestamp: 140602 18:26:21
     Last_SQL_Error_Timestamp:
               Master_SSL_Crl:
           Master_SSL_Crlpath:
           Retrieved_Gtid_Set:
            Executed_Gtid_Set:
                Auto_Position: 0
1 row in set (0.00 sec)
```

これ。  
`Fatal error: The slave I/O thread stops because master and slave have equal MySQL server UUIDs; these UUIDs must be different for replication to work.`  
  
そっこーググるとすぐに見つかる。いんたーねっとって素晴らしいですね！  
http://yoku0825.blogspot.jp/2012/10/mysqlfailovergtid.html  
  
`/var/lib/mysql/auto.cnf` を削除して再起動で完了。
