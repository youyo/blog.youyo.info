---
title: "AWS SAMでCognito UserPoolsの認証付きAPIを作成する"
thumbnailImage: images/eye-catch/aws.jpg
thumbnailImagePosition: left
metaAlignment: left
date: 2018-12-05
categories:
- technology
tags:
- aws
- api-gateway
- sam
- cognito
---

AWS SAMでCognito UserPoolsの認証付きAPIを作ろうとしたときに, ググるとswaggerの設定書けという記事がたくさん出てきます.  
めんどくさいです.  
Serverless Frameworkならこんなに簡単にやれるのに.  
[Serverless FrameworkでCognito User Poolsの認証付きAPIを作る](https://wp-kyoto.net/cognito-authorized-api-by-serverless-framework)

でもいろいろ調べてたらちゃんと対応されてました.  
[AWS サーバーレスアプリケーションモデルが Amazon API Gateway オーソライザーをサポート](https://aws.amazon.com/jp/about-aws/whats-new/2018/10/aws-sam-supports-amazon-api-gateway-authorizers/)

ということで動かしてみました. コード全体はこちら.  
https://github.com/youyo/sam-apigateway-authorizer  

<!--more-->

`ApiGateway` のリソースでAuthorizerの設定を行い, `RestApiId: !Ref ApiGateway` でその作成されたAPI Gatewayを参照するようにしています.

```
Resources:
  ApiGateway:
    Type: AWS::Serverless::Api
    Properties:
      StageName: Prod
      Auth:
        DefaultAuthorizer: CognitoAuthorizer
        Authorizers:
          CognitoAuthorizer:
            UserPoolArn: !GetAtt UserPool.Arn
  Function:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: hello_world/
      Handler: app.lambda_handler
      Runtime: python3.7
      Events:
        Register:
          Type: Api
          Properties:
            Path: /
            Method: get
            RestApiId: !Ref ApiGateway
```

これでdeployしてuserpoolにユーザー作成して認証してIdToken取得してAuthorizationヘッダーつけてリクエストしてあげると上手く動きます.

```
$ curl -s https://xxxxxxxxxxxx.execute-api.ap-northeast-1.amazonaws.com/Prod/
{"message":"Unauthorized"}

$ aws cognito-idp initiate-auth --auth-flow USER_PASSWORD_AUTH --client-id xxxxxxxxxxxx --auth-parameters '{"USERNAME":"xxxxxxxx","PASSWORD":"xxxxxxxxx"}' | jq '.AuthenticationResult.IdToken'
"eyJraWQiOiJ1NVwvOW........VFZuI48-FbrQGg"

$ curl -s -H 'Authorization: eyJraWQiOiJ1NVwvOW........VFZuI48-FbrQGg' https://xxxxxxxxxxxx.execute-api.ap-northeast-1.amazonaws.com/Prod/
{"message": "hello world", "location": "xxx.xxx.xxx.xxx"}
```

ということで無事AWS SAMでも簡単にCognito User Poolsの認証付きAPIを作ることができました.
