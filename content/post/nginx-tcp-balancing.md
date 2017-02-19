---
title: "NginxのTCP Load Balancing試してみた"
thumbnailImage: images/eye-catch/nginx.png
thumbnailImagePosition: top
metaAlignment: left
date: 2016-06-07
categories:
- technology
tags:
- nginx
---

公式サイトを参考にちょっとやってみた。  
[https://www.nginx.com/resources/admin-guide/tcp-load-balancing/](https://www.nginx.com/resources/admin-guide/tcp-load-balancing/)
<!--more-->

### 環境

- CentOS Linux release 7.2.1511 (Core)
- nginx version: nginx/1.10.1
- IP: 192.168.0.51

### とりあえずhttpをTCPバランシングしてみる

```
http {

	...

	server {
		listen 81;
		server_name _;
		location / {
			root   /usr/share/nginx/html;
			index  index.html;
		}
	}
	server {
		listen 82;
		server_name _;
		location / {
			root   /usr/share/nginx/html;
			index  index2.html;
		}
	}

	...

}

stream {
	upstream appservers {
		server 192.168.0.51:81;
		server 192.168.0.51:82;
	}
	server {
		listen 12345;
		proxy_pass appservers;
	}
}
```

```
# echo site1 > /usr/share/nginx/html/index.html
# echo site2 > /usr/share/nginx/html/index2.html
# nginx -t && systemctl restart nginx.service
```

これで `127.0.0.1:12345` にアクセスしてみると...

```
# curl 127.0.0.1:12345
site2
# curl 127.0.0.1:12345
site1
# curl 127.0.0.1:12345
site2
# curl 127.0.0.1:12345
site1
# curl 127.0.0.1:12345
site2
# curl 127.0.0.1:12345
site1
```

おー動いてる！

### httpじゃなんかいつもと変わらないのでsmtpもやってみる

複数立てるのめんどくさくなったので１つだけ。  
proxy出来てればそれでいい。

```
stream {
	upstream smtpservers {
		server 192.168.0.51:25;
	}
	server {
		listen 125;
		proxy_pass smtpservers;
	}
}
```

```
# nginx -t && systemctl restart nginx.service
```

試してみる。

```
# telnet 127.0.0.1 125
Trying 127.0.0.1...
Connected to 127.0.0.1.
Escape character is '^]'.
220 localhost.localdomain ESMTP Postfix
quit
221 2.0.0 Bye
Connection closed by foreign host.
```

ほー！

### まとめ

- シンプルでいい
- `http` ディレクティブではなく `stream` ディレクティブへ書く
- ヘルスチェクの機能もあったけどまた今度
([http://nginx.org/en/docs/stream/ngx_stream_upstream_module.html?&_ga=1.191197930.1138842998.1461731871#health_check](http://nginx.org/en/docs/stream/ngx_stream_upstream_module.html?&_ga=1.191197930.1138842998.1461731871#health_check))
