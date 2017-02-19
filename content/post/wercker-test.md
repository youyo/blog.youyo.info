---
title: "Werckerを使ってフェーズ間のパッケージの受け渡し周りでハマった"
thumbnailImage: images/eye-catch/wercker.png
thumbnailImagePosition: top
metaAlignment: left
date: 2016-06-18
categories:
- technology
tags:
- wercker
- go
---

### まとめ

- パッケージを次のフェーズに渡すには `${WERCKER_OUTPUT_DIR}` ディレクトリの中に入れる
- `${WERCKER_OUTPUT_DIR}` の中にパッケージを入れると元のソースコード類はコピーされない
- `${WERCKER_OUTPUT_DIR}` の中が空であれば元のソースコード類がコピーされ次のフェーズに渡される
- 今回のサンプルコード一式はこちら  
[https://github.com/youyo/wercker-test](https://github.com/youyo/wercker-test)  
[https://app.wercker.com/#applications/5764c96dc961d9eb3f0f515e](https://app.wercker.com/#applications/5764c96dc961d9eb3f0f515e)
<!--more-->

### やりたかったこと

phase1で生成したパッケージ(今回は `go build` で生成されるバイナリ)を次のphase2でデプロイというフローを作りたかった。
phase2のときにソースコードに含まれる `version.go` ファイルからバージョンを取得し、デプロイに利用したかった。

### とりあえずやってみる

下記 `wercker.yml` を作成してとりあえずやってみた。

<script src="https://gist.github.com/youyo/17d3ba013e3172f403aaed518d0bdaac.js"></script>

とりあえずやってみたら `version.go` ファイルがないよーというエラーが吐かれた。
あれーと思いつつwercker.ymlにlsコマンドを仕込んだりして見てみたら確かになかった。
そこには生成されたパッケージだけが。  
  
ググってみたらすぐにわかって、こちら解説されてた。  
[http://qiita.com/ngyuki/items/47a66b26e1bbf833e8c8](http://qiita.com/ngyuki/items/47a66b26e1bbf833e8c8)

>ビルドで $WERCKER_OUTPUT_DIR になにかが出力されていれば、デプロイではそのディレクトリの内容が $WERCKER_SOURCE_DIR にコピーされます。もし、ビルドで $WERCKER_OUTPUT_DIR が空っぽなら、ビルドの $WERCKER_SOURCE_DIR がデプロイの $WERCKER_SOURCE_DIR にコピーされます。

なーるーほーどー。  
今の `wercker.yml` だと `go build` で作成されたバイナリしか渡らないわけで、 `version.go` は次のフェーズでは存在しないわけだ。

### こうやることにした

`version.txt` というバージョンが書かれたファイルも `${WERCKER_OUTPUT_DIR}` に入れて渡すことにしました。  
んでwercker.ymlはこうなりました。

<script src="https://gist.github.com/youyo/f3696024d660dd33caadbbf84de879bf.js"></script>

無事 `version.txt` も渡されてバージョンを得ることができました。
