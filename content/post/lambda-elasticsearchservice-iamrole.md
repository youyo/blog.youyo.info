---
title: "AWS LambdaからElasticsearch Serviceに接続するときに、IAM Roleを使う"
thumbnailImage: images/eye-catch/aws-ess.png
thumbnailImagePosition: left
metaAlignment: left
date: 2017-02-25
categories:
- technology
tags:
- aws
- elasticsearch
- lambda
- python
---

Amazon ElasticSearch Serviceに接続するとき、アクセスポリシーを使い許可してあげる必要がある。いくつかテンプレートが用意されているのだが、その中の選択肢としては

- IAM Userによる認証
- 特定IPからの接続許可
- フルオープン

となっている。  
  
AWS Lambdaから接続するってのを考えたとき、特定のIPからの接続許可を与えるのは難しい。じゃあIAM User作ってアクセスキー、シークレットキーで認証するか？と言われれば、Lambdaに設定されているIAM Roleを使いたい、と考えるわけで。

<!--more-->

そこで使うのがAWS Lambdaで使用できるようになった環境変数。  
(参考: [【アップデート】AWS Lambdaで環境変数を使えるようになりました！！！](http://dev.classmethod.jp/cloud/aws/aws-lambda-env-variables/))  
  
取得できる環境変数の中には、Lambdaに設定されているIAM Roleの `AWS_ACCESS_KEY_ID` `AWS_SECRET_ACCESS_KEY` などが含まれている。これを使用して認証してやればいい。  
<br/>

<script src="https://gist.github.com/youyo/48846ea087dcd81b618171ea0800a09c.js"></script>

(参考: [Running on AWS with IAM](http://elasticsearch-py.readthedocs.io/en/master/#running-on-aws-with-iam))  
  
あとはElasticsearch Serviceに設定するアクセスポリシーでIAM RoleのARNを許可してやればいい。  
<br/>
<script src="https://gist.github.com/youyo/c9d7fa4c25363de53fd873744825966d.js"></script>

もちろんAWS Lambdaに設定しているIAM RoleにはElasticsearch Serviceへのアクセス権限はあるということで。
