---
title: "zabbix-proxyでout of memory発生"
thumbnailImage: images/eye-catch/zabbix.png
thumbnailImagePosition: top
metaAlignment: left
date: 2016-02-03
categories:
- technology
tags:
- zabbix
---

`1秒あたりの監視項目数(Zabbixサーバーの要求パフォーマンス)	1703.18` というちょっとは規模大きいほうじゃないかなーというzabbix-serverを運用しています。  
zabbix-server1台ではなく複数台のzabbix-proxyで構成しています。  
そのうちのzabbix-proxy1台が次のようなエラーを吐いて停止。。  
<!--more-->

```
2068:20160203:051106.554 __mem_malloc: skipped 0 asked 136 skip_min 4294967295 skip_max 0
2068:20160203:051106.554 [file:dbconfig.c,line:446] zbx_mem_malloc(): out of memory (requested 136 bytes)
2068:20160203:051106.554 [file:dbconfig.c,line:446] zbx_mem_malloc(): please increase CacheSize configuration parameter
2066:20160203:051106.557 One child process died (PID:2068,exitcode/signal:255). Exiting ...
2066:20160203:051108.559 syncing history data...
2066:20160203:051108.562 syncing history data done
2066:20160203:051108.562 Zabbix Proxy stopped. Zabbix 2.2.9 (revision 52686).
```

`please increase CacheSize configuration parameter`
丁寧に対応内容まで書かれていて親切ですね :)  
  
このzabbix-proxyはデフォルトの8MBで運用していたのでとりあえず128MBに増やしました。(その他cache関連の項目も増やしておいた)  
数時間経ちましたが今のところ問題なく稼動中。
