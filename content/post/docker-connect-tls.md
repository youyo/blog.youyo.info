---
title: "リモートのdockerホストに接続する"
thumbnailImage: images/eye-catch/default.png
thumbnailImagePosition: left
metaAlignment: left
date: 2015-07-06
categories:
- technology
tags:
- docker
---

[インターネットの向こう側にあるDockerを使う](https://beatsync.net/main/log20141212.html) を大いに参考にした。(丸パクリ

<!--more-->

## 環境

- centos7
- dockerをyumでインストール

## Server側

```
cd /etc/docker/certs.d/
openssl genrsa -des3 -out ca-key.pem 4096
openssl req -new -x509 -days 3650 -key ca-key.pem -out ca.pem

openssl genrsa -des3 -out server-key.pem 4096
openssl req -subj '/CN=server' -new -key server-key.pem -out server.csr
openssl x509 -req -days 3650 -in server.csr -CA ca.pem -CAkey ca-key.pem -out server-cert.pem


openssl genrsa -des3 -out key.pem 4096
openssl req -subj '/CN=client' -new -key key.pem -out client.csr
echo extendedKeyUsage = clientAuth > extfile.cnf
openssl x509 -req -days 3650 -in client.csr -CA ca.pem -CAkey ca-key.pem -out cert.pem -extfile extfile.cnf

openssl rsa -in server-key.pem -out server-key.pem
openssl rsa -in key.pem -out key.pem

vim /etc/sysconfig/docker
------------------------------
#OPTIONS='--selinux-enabled'
OPTIONS='--selinux-enabled --tlsverify --tlscacert=/etc/docker/certs.d/ca.pem --tlscert=/etc/docker/certs.d/server-cert.pem --tlskey=/etc/docker/certs.d/server-key.pem -H=0.0.0.0:2376 -H unix:///var/run/docker.sock'
------------------------------


systemctl start docker.service
systemctl enable docker
```

## Client側

```
vim ~/.docker/ca.pem
vim ~/.docker/cert.pem
vim ~/.docker/key.pem

vim ~/.zshrc
export DOCKER_HOST=tcp://xxx.xxx.xxx.xxx:2376
export DOCKER_TLS_VERIFY=1
```
