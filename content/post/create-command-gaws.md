---
title: "AWS Secrets Managerをちょっとだけ楽に使いたいのでgawsというコマンド作った"
thumbnailImage: images/eye-catch/aws.jpg
thumbnailImagePosition: left
metaAlignment: left
date: 2019-02-26
categories:
- technology
tags:
- aws
- go
- secretsmanager
---

`gaws` というコマンドを作りました。  
https://github.com/youyo/gaws  
  
```
$ gaws secretsmanager
Usage:
  gaws secretsmanager [command]

Available Commands:
  add         Add key-value pair to secure-string
  export      Export secure string
  get         Get secure string (alias of 'export' command)
  import      Import secure-string
  list        List secrets
  put         Update key-value pair to secure-string or adding
  remove      Remove key from secure-string

Flags:
  -h, --help   help for secretsmanager

Use "gaws secretsmanager [command] --help" for more information about a command.
```

<!--more-->

## なぜ作ったか

例えばaws-cliでsecure-stringを保存しようとすると次のようになります。

```
$ aws secretsmanager put-secret-value \
	--secret-id SecretId \
	--secret-string '{"key1":"value1","key2":"value2"}'
```

その後もう一つkey3を追加したいなと思ったらこうなります。

```
$ aws secretsmanager put-secret-value \
	--secret-id SecretId \
	--secret-string '{"key1":"value1","key2":"value2","key3":"value3"}'
```

毎回secure-string全体を渡すのがめんどくさいなと思ったので作りました。  
--secret-stringはfile://って感じでファイルも渡せますが, そういうのもめんどくさかったのです。

## インストール

macの方はhomebrewがおすすめです。

```
brew tap youyo/gaws
brew install gaws
```

それ以外の方はGithub releasesページからダウンロードしてください。

## 使い方

`add` , `remove` , `put` がメインになります。

### add

key-valueを追加します。keyが重複する場合にはエラーになります。

```
$ gaws secretsmanager add --help
Add key-value pair to secure-string

Usage:
  gaws secretsmanager add [flags]

Flags:
  -h, --help               help for add
  -k, --key string         json-key
  -s, --secret-id string   secret-id
  -v, --value string       json-value

$ gaws secretsmanager add -s SecretId -k key4 -v value4
```

### remove

keyを削除します。

```
$ gaws secretsmanager remove --help
Remove key from secure-string

Usage:
  gaws secretsmanager remove [flags]

Flags:
  -h, --help               help for remove
  -k, --key string         json-key
  -s, --secret-id string   secret-id

$ gaws secretsmanager remove -s SecretId -k key4
```

### put

key-valueを更新します。存在しないkeyを与えた場合はaddと同じ挙動で追加になります。

```
$ gaws secretsmanager put --help
Update key-value pair to secure-string or adding

Usage:
  gaws secretsmanager put [flags]

Flags:
  -h, --help               help for put
  -k, --key string         json-key
  -s, --secret-id string   secret-id
  -v, --value string       json-value

$ gaws secretsmanager put -s SecretId -k key4 -v value4
```

## completionも作った

最近補完の効かないコマンドを使うのは辛くなってきたのでここもちゃんと用意しました。  
zshを使っている方は `~/.zshrc` に1行追記してもらえれば動くと思います。

```
# gaws
source <(gaws completion zsh)
```

bash用も `gaws completion bash` で出力できますが, NoTestです。

## 今後

今回のsecretsmanagerは `gaws` というコマンドのサブコマンドとして実装しています。  
`gaws` には他に思いついたものや, 昔作った[awslogin](https://github.com/youyo/awslogin)や細々したものを入れてこうかなと考えています。
