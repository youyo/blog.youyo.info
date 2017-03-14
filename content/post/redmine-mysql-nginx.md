---
title: "Redmine構築"
thumbnailImage: images/eye-catch/default.png
thumbnailImagePosition: left
metaAlignment: left
date: 2014-06-06
categories:
- technology
tags:
- mysql
- redmine
- nginx
- ruby
---

Redmine構築したのでメモ。(いつも忘れてググってるので。。)

## 環境

- CentOS 6.5
- Redmine 2.5.1
- Ruby 2.0.0-p481
- Nginx 1.6.0
- MySQL 5.1.73

Apache Passengerは使わず、unicornで起動してproxyとしてnginxを使います。unicornはupstartで起動します。rubyはrbenvでお好きなものを。

<!--more-->

## MySQL install

適当に。  
チューニングはスペックに合わせてしっかりやる。

```
yum -y install mysql-server

cat <<EOS > /etc/my.cnf
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
user=mysql
character-set-server = utf8
skip-character-set-client-handshake
ignore-builtin-innodb
plugin-load=innodb=ha_innodb_plugin.so;innodb_trx=ha_innodb_plugin.so;innodb_locks=ha_innodb_plugin.so;innodb_lock_waits=ha_innodb_plugin.so;innodb_cmp=ha_innodb_plugin.so;innodb_cmp_reset=ha_innodb_plugin.so;innodb_cmpmem=ha_innodb_plugin.so;innodb_cmpmem_reset=ha_innodb_plugin.so
innodb_file_per_table
innodb_flush_method = O_DIRECT
innodb_buffer_pool_size = 512M
innodb_log_file_size = 256M
innodb_data_file_path = ibdata1:64M:autoextend
innodb_autoextend_increment = 64
[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
character-set-server = utf8
EOS

service mysqld start
chkconfig mysqld on
mysql_secure_installation</EOS>>
```

データベース、ユーザーを作成しておく。

```
create database redmine;
grant all on redmine.* to redmine@"localhost" identified by "password";
flush privileges;
```

## Ruby install

ユーザーを追加してrbenvでrubyインストール。  
ホームディレクトリとかお好きにどうぞ。

```
mkdir -p /var/www/vhost
useradd -d /var/www/vhost/redmine.youyo.info redmine.youyo.info
chmod 755 /var/www/vhost/redmine.youyo.info
su - redmine.youyo.info
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
exec $SHELL -l
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
exec $SHELL -l
rbenv install 2.0.0-p481
rbenv global 2.0.0-p481
rbenv rehash
gem install bundler
rbenv rehash
```

## Redmine install

そのまま `redmine.youyo.info` ユーザーでredmineをインストールしていきます。

```
cd
wget http://www.redmine.org/releases/redmine-2.5.1.tar.gz
tar xvzf redmine-2.5.1.tar.gz
cd redmine-2.5.1/
bundle install --without development test rmagick postgresql sqlite
cp -a config/database.yml.example config/database.yml
vim config/database.yml
-----------------------------
production:
  adapter: mysql2
  database: redmine
  host: localhost
  username: redmine
  password: "password"
  encoding: utf8
-----------------------------
echo "gem 'unicorn'" >> Gemfile
bundle install --without development test rmagick postgresql sqlite
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake redmine:load_default_data
rake generate_secret_token
```

テストで起動してみる。問題なければctrl＋cで終了しておく。

```
bundle exec rails s -e production
```

unicorn設定。

```
cp -a ~/.rbenv/versions/2.0.0-p481/lib/ruby/gems/2.0.0/gems/unicorn-4.8.3/examples/unicorn.conf.rb config/
vim config/unicorn.conf.rb
-----------------------------
working_directory "/var/www/vhost/redmine.youyo.info/redmine-2.5.1"
listen "/var/www/vhost/redmine.youyo.info/redmine-2.5.1/tmp/sockets/unicorn.sock", :backlog => 64
timeout 60
pid "/var/www/vhost/redmine.youyo.info/redmine-2.5.1/tmp/pids/unicorn.pid"

stderr_path "/var/www/vhost/redmine.youyo.info/redmine-2.5.1/log/unicorn.stderr.log"
stdout_path "/var/www/vhost/redmine.youyo.info/redmine-2.5.1/log/unicorn.stdout.log"
-----------------------------
```

起動テスト。

```
bundle exec unicorn_rails -c config/unicorn.conf.rb -E production
```

## Upstart config

upstartでredmine起動するようにします。

```
vim /etc/init/redmine.conf
----------------------------
description "redmine"
author "youyo"

start on runlevel [2345]
stop on runlevel [016]

exec su - redmine.youyo.info -c "cd /var/www/vhost/redmine.youyo.info/redmine-2.5.1 && bundle exec unicorn_rails -c config/unicorn.conf.rb -E production"
respawn
----------------------------

initctl start redmine
```

## Nginx install

nginxでproxyする設定します。

```
vim /etc/yum.repos.d/nginx.repo
----------------------------------
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=0
enabled=1
----------------------------------

yum install nginx
rm -rf /etc/nginx/conf.d/*

vim /etc/nginx/nginx.conf
----------------------------
keepalive_timeout  10;
proxy_redirect off;
proxy_set_header Host                   $host;
proxy_set_header X-Real-IP              $remote_addr;
proxy_set_header X-Forwarded-Host       $host;
proxy_set_header X-Forwarded-Server     $host;
proxy_set_header X-Forwarded-For        $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto      $scheme;
server_tokens off;
----------------------------

vim /etc/nginx/conf.d/redmine.conf
----------------------------
server {
        listen 80;
        server_name redmine.youyo.info;
        root /var/www/vhost/redmine.youyo.info/redmine-2.5.1/public;
        location / {
                if (!-f $request_filename) {
                        proxy_pass http://unix:/var/www/vhost/redmine.youyo.info/redmine-2.5.1/tmp/sockets/unicorn.sock;
                        break;
                }
        }
}
----------------------------

nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

service nginx start
chkconfig nginx on
```

## できあがり！

これで `http://redmine.youyo.info/` にアクセスすればredmine使えるはず！
