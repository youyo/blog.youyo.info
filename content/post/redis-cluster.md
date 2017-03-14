---
title: "Redis-Sentinelのclient-reconfig-scriptでVIPをつける"
thumbnailImage: images/eye-catch/default.png
thumbnailImagePosition: left
metaAlignment: left
date: 2014-05-24
categories:
- technology
tags:
- redis
- ha
---

Redis-Sentinelを使って冗長化するとき、VIPの制御はどうしよっかな〜と思っていろいろ調べた結果、 `client-reconfig-script` を使うとVIP付けれそう！ってことがわかって、やってみたのでまとめ。

<!--more-->

## 環境

- CentOS 6.5 x86_64
- redis-2.8.9-1.el6.remi.x86_64

3台構成でIPとかははこんな感じで。  
Portはデフォルトの6379です。 3台全てでredis,redis-sentinelが動きます。

- redis1 192.168.0.1/24
- redis2 192.168.0.2/24
- redis3 192.168.0.3/24
- VIP 192.168.0.4/24

## Redis,Redis-Sentinel インストール

remiレポジトリを使用して2.8系をyumでサクッと。  
redis1をマスターにしてレプリケーションを組んでおきます。

```
yum install --enablerepo=epel,remi redis -y
sed -i "s|bind 127.0.0.1|bind 0.0.0.0|g" /etc/redis.conf
service redis start
chkconfig redis on
```

redis2,redis3で。

```
redis-cli
127.0.0.1:6379> SLAVEOF 192.168.0.1 6379
```

## VIP設定用スクリプト

フェイルオーバー時に実行されるスクリプトです。
`client-reconfig-script` で実行されるスクリプトには下記のような引数が渡されます。

```
# The following arguments are passed to the script:
#
# <master-name> <role> <state> <from-ip> <from-port> <to-ip> <to-port></state></role>
```

6番目の<to-ip>を使って、自分がマスターになったときにVIPをつけて、それ以外のときはVIPを外す動作をします。 ipコマンドで付けてるだけなので、フェイルオーバー時にarpが問題になることがあります。 そのためarpingコマンドでGARPを投げています。 ipコマンド、arpingコマンドいずれもroot権限が必要なのでsudo設定します。

```
vim /var/lib/redis/failover.sh
chmod 755 /var/lib/redis/failover.sh
chown redis: /var/lib/redis/failover.sh
echo -e "redis\tALL=(ALL)\tNOPASSWD:/sbin/ip,NOPASSWD:/sbin/arping" > /etc/sudoers.d/redis
sed -i "s|Defaults.*requiretty|#Defaults\trequiretty|" /etc/sudoers
chmod 440 /etc/sudoers.d/redis
```

```
#!/bin/bash

MASTER_IP=${6}
MY_IP='192.168.0.1'   # 各サーバ自身のIP
VIP='192.168.0.4'     # VIP
NETMASK='24'          # Netmask
INTERFACE='eth0'      # インターフェイス

if [ ${MASTER_IP} = ${MY_IP} ]; then
        sudo /sbin/ip addr add ${VIP}/${NETMASK} dev ${INTERFACE}
        sudo /sbin/arping -q -c 3 -A ${VIP} -I ${INTERFACE}
        exit 0
else
        sudo /sbin/ip addr del ${VIP}/${NETMASK} dev ${INTERFACE}
        exit 0
fi
exit 1
```

## Redis-Sentinel設定

redis-sentonelの設定をして起動します。  
初回だけVIPを手動で設定します。

```
vim /etc/redis-sentinel.conf

service redis-sentinel start
chkconfig redis-sentinel on

ip addr add 192.168.0.4/24 dev eth0
```

```
# sentinel.conf
port 26379
logfile /var/log/redis/sentinel.log
sentinel monitor mymaster 192.168.0.1 6379 2
sentinel down-after-milliseconds mymaster 3000
sentinel parallel-syncs mymaster 1
sentinel failover-timeout mymaster 60000
sentinel client-reconfig-script mymaster /var/lib/redis/failover.sh
```

## 確認

あとはマスターになっているredisをkillしてみてフェイルオーバーするか、pingを打ちながらフェイルオーバーさせて途切れないか、などチェックしてみればいいと思います。
`sentinel down-after-milliseconds mymaster 3000` にあるように3秒でredisのダウンを検知するようにしています。よりシビアな環境の場合は短く変更して試してみるといいと思います。

