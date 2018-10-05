---
title: "cloud pub/sub経由で起動したcloud functionsで, event元となったmessageの削除の仕方がわからない"
thumbnailImage: images/eye-catch/gcp.png
thumbnailImagePosition: left
metaAlignment: left
date: 2018-10-05
categories:
- technology
tags:
- gcp
- cloud_functions
- cloud_pubsub
---

cloud functionsはtriggerとしてcloud pub/subを使用できます. cloud pub/subにmessageを入れると指定したcloud functionsが起動してきてmessageを受け取れます.  
ここまでは問題ないのですが, messageを受け取って処理をしたあと, そのmessageって削除すると思うんですよ. 普通.  
  
通常pub/subに対する処理としてsubscriberはmessageにackを返すことで処理完了とします. messageは下記のようなcallback()に渡されてそこで処理されます. `message.ack()` を呼べばいいわけです.

```
def callback(message):
    body = message.data.decode()
    print(body)
    message.ack()
```
<!--more-->

cloud functionsに渡されるデータもだいたい同じ形式です.

```
def functions_handler(event, context):
    body = base64.b64decode(event['data']).decode()
    print(body)
```

しかしこの `event` には `ack()` は実装されていません. なんかどこかにack()実装されてるんじゃないかな-といろいろ見たのですがどうもなさそうでした. stackoverflowに, ちゃんとresponse 200返せば削除されるよという話もあった気がするのですが(url紛失), やってみてもまぁ消えませんでした.  
  
今回やりたかったのはsubscriberが1つだけというケースなのですが, pub/subなのでsubscriberが多数の場合もあるし, もしかしたら僕のやろうとしていることがユースケースから外れているのかもしれません.  
絶賛未解決なのでこうやるのがベストプラクティスだ!!!というのをご存知の方はぜひtwitterで教えてください.  
(ちなみに今回は諦めてapp engineとdatastoreでどうにかしました.)
