---
title: "CentOS6にPostgreSQL7.3.1をソースインストール"
thumbnailImage: images/eye-catch/postgresql.png
thumbnailImagePosition: left
metaAlignment: left
date: 2015-10-21
categories:
- technology
tags:
- centos
- postgresql
---

備忘録です

### 環境

- CentOS6.7 x86_64
- PostgreSQL 7.3.1
<!--more-->

---

### 手順

- rootユーザーで。

```
yum install @development readline-devel zlib-devel
useradd -d /usr/local/pgsql postgres
```

- postgresユーザーで。

```
su - postgres
vim .bashrc
-------------------------------------
export PGHOME=/usr/local/pgsql
export PGDATA=/usr/local/pgsql/data
export PGHOST=localhost
PATH=$PGHOME/bin:$PATH
-------------------------------------

wget https://ftp.postgresql.org/pub/source/v7.3.1/postgresql-7.3.1.tar.gz
tar xvzf postgresql-7.3.1.tar.gz
cd postgresql-7.3.1
./configure
make
make all
make install
initdb -E EUC_JP
vim data/postgresql.conf
-------------------------------------
tcpip_socket = true
port = 5432
silent_mode = true
-------------------------------------
```

- rootユーザーで。

```
cp -a /usr/local/pgsql/postgresql-7.3.1/contrib/start-scripts/linux /etc/init.d/postgresql
chmod 755 /etc/init.d/postgresql
chkconfig postgresql on
service postgresql start
```
