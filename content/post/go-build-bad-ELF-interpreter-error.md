---
title: "go buildしたバイナリを実行したら'/lib/ld-linux.so.2: bad ELF interpreter: No such file or directory'エラーが出た"
thumbnailImage: //blog.golang.org/gopher/gopher.png
thumbnailImagePosition: left
metaAlignment: left
date: 2016-06-23
categories:
- technology
tags:
- go
- alpinelinux
---

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">alpine linuxでgo buildしたバイナリでこの現象に出くわした。 <a href="https://t.co/smbA3ONLiX">https://t.co/smbA3ONLiX</a></p>&mdash; 洋@豆腐 (@youyo\_) <a href="https://twitter.com/youyo_/status/745799897186631681">2016年6月23日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script></p>
<!--more-->

で、 [http://www.howtodoityourself.org/how-to-fix-libld-linux-so-2-bad-elf-interpreter-no-such-file-or-directory.html](http://www.howtodoityourself.org/how-to-fix-libld-linux-so-2-bad-elf-interpreter-no-such-file-or-directory.html)によると解決策は `glibc` をインストールすることらしい。  
  
なるほどなるほどと思い早速インストールしようと思ったのだが、ビルドに使用していたコンテナイメージのalpine linuxではパッケージで提供されていないらしい。

```
/ # apk search glibc
/ #
```

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">apk search glibc してもないみたいだし、すっと諦めて別のコンテナイメージ使おう。</p>&mdash; 洋@豆腐 (@youyo\_) <a href="https://twitter.com/youyo_/status/745800315899764736">2016年6月23日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

glibc入りのパッケージも見つかるし、インストールできなくはないけどそこまでalpine linuxにこだわる必要はないなーと。(軽いは正義。これは間違いないけど。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">glib入りのイメージあるにはあるけど、ここまでしてalpineにこだわる必要はないかな。 <a href="https://t.co/swunId0pFK">https://t.co/swunId0pFK</a></p>&mdash; 洋@豆腐 (@youyo\_) <a href="https://twitter.com/youyo_/status/745800618233602049">2016年6月23日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

んで使用するイメージを `golang:1.6.2-alpine` から `golang:1.6.2-wheezy` に変えてbuildし直したら無事実行できました。
