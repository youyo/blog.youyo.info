---
title: "Too Many Authentication Failures for User"
thumbnailImage: images/eye-catch/default.png
thumbnailImagePosition: left
metaAlignment: left
date: 2014-06-17
categories:
- technology
tags:
- shell
---

macでsshしようとするとたまに出る。

```
[naoto@MBA ~] $ ssh root@192.168.5.222
Received disconnect from 192.168.5.222: 2: Too many authentication failures for root
```

<!--more-->

よくわかってないが、何かをクリアすると繋がるようになる。

```
[naoto@MBA ~] $ ssh-add -D
All identities removed.
```

※ ググったらいろいろ出ました。詳細はググるべし。
