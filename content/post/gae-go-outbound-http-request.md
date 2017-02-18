---
title: "GAE/Goで外部にhttpリクエスト送るには？"
thumbnailImage: //1.bp.blogspot.com/-ldb24xUV3f0/U-VjaM380DI/AAAAAAAAmPw/V9jDvdAT8R8/s1600/gae.png
thumbnailImagePosition: left
metaAlignment: left
date: 2016-07-05
categories:
- technology
tags:
- go
- gae
- zabbix
---

httpでGETリクエスト送るとそこからzabbixのapi叩いてアラートを停止するってのをGAE/Goの勉強がてら作り直してて、そのときいざzabbixにリクエスト送ろうとしたらエラー出て動きませんでした。

```
http.DefaultTransport and http.DefaultClient are not available in App Engine. See https://cloud.google.com/appengine/docs/go/urlfetch/
```
<!--more-->

そこにはこう書かれていて、

> This page describes how App Engine applications use the URL Fetch service to issue HTTP and HTTPS requests and receive responses. For guidance on how to issue HTTP and HTTPS requests from your Go-based App Engine application, see Issuing HTTP(S) Requests. To view the contents of the urlfetch package, see the urlfetch package reference.
>
> Requests
>
> App Engine uses the URL Fetch service to issue outbound requests. In Go, the `urlfetch` package provides urlfetch.Transport, an implementation of the http.RoundTripper interface that makes requests using App Engine's infrastructure.
>
[https://cloud.google.com/appengine/docs/go/outbound-requests](https://cloud.google.com/appengine/docs/go/outbound-requests)

`urlfetch` パッケージを使えよとのことでした。

`urlfetch.Client()` は次のようになっていて、 `*http.Client` を返します。

> func Client  
```
func Client(ctx context.Context) *http.Client
```
[https://cloud.google.com/appengine/docs/go/urlfetch/reference#Client](https://cloud.google.com/appengine/docs/go/urlfetch/reference#Client)

これで既存の `http.Client` を置き換えてあげればいいわけです。

---

今回使用したかったライブラリ([https://github.com/AlekSi/zabbix](https://github.com/AlekSi/zabbix))にhttpリクエストを送る部分が含まれていて、この外部ライブラリの `http.Client` を置き換える必要があります。幸いこのライブラリには次の関数が用意されていて、容易に置き換え可能でした。

```
func (api *API) SetClient(c *http.Client) {
	api.c = *c
}
```

もともとこうだったものを、

```
func stopAlert(c echo.Context) error {
	api := zabbix.NewAPI("https://zabbix-host/zabbix/api_jsonrpc.php")
	api.Login("user", "password")
	_, err := api.Call("method", zabbix.Params{...})
	if err != nil {
		return c.String(http.StatusInternalServerError, "error")
	}
	return c.String(http.StatusOK, "ok")
}
```

こう！

```
func stopAlert(c echo.Context) error {
	api := zabbix.NewAPI("https://zabbix-host/zabbix/api_jsonrpc.php")
	api.SetClient(urlfetch.Client(c))
	api.Login("user", "password")
	_, err := api.Call("method", zabbix.Params{...})
	if err != nil {
		return c.String(http.StatusInternalServerError, "error")
	}
	return c.String(http.StatusOK, "ok")
}
```

`api.SetClient(urlfetch.Client(c))` を一行加えるだけでokでした。  
これで無事外部にhttpリクエストを送ることができました。  
(ちなみにフレームワークに `echo` を使用しているので引数がよくあるサンプルとは異なっています..)

---

### エラーは続くよ

`goapp serve` コマンドを叩いてローカルでテストを行うと次のエラーが出ます。

```
API error 6 (urlfetch: SSL_CERTIFICATE_ERROR): [SSL: SSLV3_ALERT_HANDSHAKE_FAILURE] sslv3 alert handshake failure (_ssl.c:590)
```

これどうもローカルでテストしている場合にだけ出るみたいです...
実際にデプロイして動作確認したら問題ありませんでした。解決策不明...

### タスクキューについて

GAE/Goのデプロイには `goapp deploy app.yaml` で行いました。今回タスクキューを使用して非同期処理も行っていたのですが、このタスクキューのアップデートには `appcfg.py update_queues .` コマンドを使用しました。  
  
2つに分けて実行するのが正しいのか、ちゃんとしたやり方を知らなくて無駄なことしているのか...  
誰か知りませんかねぇ...
