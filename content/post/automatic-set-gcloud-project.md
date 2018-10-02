---
title: "ディレクトリを切り替えたときに自動的にGCP Projectを設定する"
thumbnailImage: images/eye-catch/default.png
thumbnailImagePosition: left
metaAlignment: left
date: 2018-10-02
categories:
- technology
tags:
- gcp
- gcloud
---

gcloudコマンドが使用するprojectの設定は, 環境変数で設定することはできず `gcloud config set project PROJECTID` コマンドを使用する必要があります.

>     --project=PROJECT_ID
        The Google Cloud Platform project name to use for this invocation. If
        omitted, then the current project is assumed; the current project can
        be listed using gcloud config list --format='text(core.project)' and
        can be set using gcloud config set project PROJECTID. Overrides the
        default core/project property value for this command invocation.

普段私は [direnv](https://direnv.net/) を使用してディレクトリごとに環境変数を切り替えることで, プロジェクト等の切り替えとしていました. gcloudの場合はこの環境変数での切り替えができずに不便だな-と思っていましたが, direnvで下記のように設定することでディレクトリ切替時にproject-idを設定することができました.

```
export PROJECT_ID=project-id
gcloud config set project ${PROJECT_ID}
```
