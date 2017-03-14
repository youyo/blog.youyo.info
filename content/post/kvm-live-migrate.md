---
title: "KVMでLiveMigrationしてみた"
thumbnailImage: images/eye-catch/default.png
thumbnailImagePosition: left
metaAlignment: left
date: 2014-08-18
categories:
- technology
tags:
- centos
- kvm
---

やってみました。  
参考は[こちら](https://d.hatena.ne.jp/enakai00/20111124/1322106772])。

<!--more-->

## 構成

- host1 centos6.5 (10.0.2.111)
- host2 centos6.5 (10.0.2.112)
- VM centos6.5 (gitlab)

host1からhost2にVMを移動させてみます。

## やってみる

### とりあえず実行してみた

```
virsh migrate --live --persistent --copy-storage-all --change-protection --verbose gitlab qemu+ssh://10.0.2.112:10022/system
root@10.0.2.112's password:
エラー: cannot open file '/var/lib/libvirt/images/gitlab.qcow2.img': No such file or directory
```

「ディスクイメージないよ！」と言われたので作成して再度やってみる。

### ディスクイメージ作成して再実行

```
qemu-img create -f qcow2 /var/lib/libvirt/images/gitlab.qcow2.img 50G
virsh migrate --live --persistent --copy-storage-all --change-protection --verbose gitlab qemu+ssh://10.0.2.112:10022/system
root@10.0.2.112's password:
エラー: Unable to resolve address 'host2' service '49153': Name or service not known
```

「host2が名前解決できないよ！」と言われたので、/etc/hostsに追記して再実行。

### 名前解決できるようにして再実行

```
echo -e "host2\t10.0.2.112" >> /etc/hosts
virsh migrate --live --persistent --copy-storage-all --change-protection --verbose gitlab qemu+ssh://10.0.2.112:10022/system
root@10.0.2.112's password:
マイグレーション: [100 %]
```

できた！！！

## まとめ

- 簡単にできた。
- VMにssh接続しながら移動させたけど、ほんとに止まってなかった。
- これ使わなくてもいいようなしっかりとした設計を。(戒め)
- でもメンテナンスには絶大な威力発揮できそう。(もっと検証必要だけど)
