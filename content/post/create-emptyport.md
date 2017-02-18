---
title: "emptyportというGolangのライブラリを作った"
date: 2016-02-08
comments: true
tags: ["golang"]
---

現在使用されていないTCPポートを知りたくて簡単に見つけられないかなーと思ってライブラリ探してたんだけど、見つからなかったので作ってみた。  
(探しきれてないだけな気はするけど)  
なお、このライブラリは下記記事を大変参考にしています。  

[Goで適当に空いてるportをListenする](http://qiita.com/sfujiwara/items/7629fa0cfac5603dab30)  

## とりあえずコード

[https://github.com/youyo/emptyport](https://github.com/youyo/emptyport)

## Usage

`emptyport.Get()` を呼ぶだけです。

```
import (
	"github.com/youyo/emptyport"
	"fmt"
)

p := emptyport.Get()
fmt.Println(p)
// 53704
```

---

ものすごく簡単なものだったけど、goのライブラリを初めて作ってとても勉強になった。  
今のところtcpにしか対応してないけど、いずれ ~~気が向けば~~ udpにも対応したいと思う。
