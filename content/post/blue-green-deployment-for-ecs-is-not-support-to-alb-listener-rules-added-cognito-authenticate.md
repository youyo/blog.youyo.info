---
title: "CodeDeployを使用したECS環境へのBlue/Green Deploymentは, ALB Listener rulesの認証アクションとの組み合わせをサポートしない (2018/12/28時点の情報)"
thumbnailImage: images/eye-catch/aws.jpg
thumbnailImagePosition: left
metaAlignment: left
date: 2018-12-28
categories:
- technology
tags:
- aws
- ecs
- cognito
- alb
- container
- fargate
---

## !! 2018/12/28時点の情報です !!

今後いい感じに修正されると思います。

<!--more-->

re:invent 2018でECS環境へのCodeDeployを使用したBlue/Green Deploymentの機能が発表されました。この機能自体の話はこちらをご覧ください。  
[ECSでCodeDeployを使用したBlue/Green Deploymentがサポートされたので早速試してみた #reinvent](https://dev.classmethod.jp/cloud/aws/ecs-codedeploy-blue-green-deployment/)
  
で, 今回はこのBlue/Green Deploymentの設定に加えてALB Listener rulesにCognitoを使用した認証アクションの設定を加えて動作確認を行いました。ALBへの認証機能の追加はこちらをご覧ください。  
[インフラエンジニアが一切コードを書かずにWebサーバーに認証機能を実装した話](https://dev.classmethod.jp/cloud/alb-cognito-user-pool/)  
  
んでいろいろ確認していて, Listener ruleへ認証アクションを加えた状態でもBlue/Green Deployemntは問題なく動作しました。しかしRollbackを実施したところListener ruleから認証アクションが削除されるという自体が発生しました。  
僕の想定していたBlue/Green Deploymentの挙動としては, ただターゲットグループが入れ替わるだけというものだったので, このRollback時のみ認証アクションが削除されるというのは想定外でした。何？Rollback時のみListener rule再作成とかされてるの？？？  
  
考えてもわからないのでAWSサポートに問い合わせたところ, 次のような回答が来ました。  

>お伺いしております以下の手順にて、当方の手元でも ECS (Blue/green) デプロイアクションのロールバックにて ALB のリスナールールの認証アクションが削除される挙動を確認いたしました。  
>
>> - fargateクラスター作成
>> - serivice作成(Blue/green deployment (powered by AWS CodeDeploy)利用)
>> - alb listener ruleを修正しcognitoによる認証設定を追加
>> - デプロイテスト. 通常のデプロイ時には, cognito認証設定のlistener ruleがそのまま残っており問題なし. (ターゲットグループのみ入れ替わっている？)
>> - ロールバックテスト. ロールバック時にはlistener ruleから認証設定が削除されている. (listener ruleが再作成されている？)
>
>上記より、ALB のリスナールールに認証アクションを設定されている場合、ECS (Blue/green) デプロイアクションをご利用されますと、意図せずロールバックした場合にリスナールールの認証アクションが削除されてしまう状況でございます。  
>従いまして、ALB のリスナールールに認証アクションを設定されている場合、現時点では ECS (Blue/green) デプロイアクションはご利用されないようにお願い申し上げます。  
>この度は、本事象によりお客様にご不便をお掛けいたしまして、大変申し訳ございません。  
>なお、本事象につきましては、修正に向けて開発部門へフィードバックを行っております。  
>恐縮ではございますが、対応時期につきましては必ずしもお約束できない点、ご了承くださいますと幸いです。

とりあえず2018/12/28時点ではこういう状況のようです。  
ECS環境へのCodeDeployを使用したBlue/Green Deploymentの機能とALBの認証アクションを組み合わせて使おうと考えている方はご注意ください。
