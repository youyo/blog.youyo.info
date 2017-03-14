---
title: "#opst19に参加してきた"
thumbnailImage: images/eye-catch/default.png
thumbnailImagePosition: left
metaAlignment: left
date: 2014-10-27
categories:
- technology
tags:
- openstack
---

\#opst19に参加してきました！  
http://connpass.com/event/8638/  
個人的にはかなりレベルの高いおもしろい内容でした！  
ので、メモったものを公開します！

<!--more-->

## openstack 2014.2 (juno release)

- 半年に1回新バージョンリリース
- juno
 - 正式コンポーネント11個
 - sahara(hadoop)が追加
- HP,redhatがcommit数1位2位。
- 最近はsaas,paasにシフトしてる
- bare metalは次回(kilo)で正式コンポーネントに
- junoでL3-HA対応。分散仮想ルータ。
- swiftでRAID5,6的な冗長化の準備進んでる
- nova
 - ironic-driver入った。(ベアメタル)
 - スケジューラーからconductorへ。
 - 対応ハイパーバイザ
  - kmv
  - vcenter(esxiは削除された！)
  - xen
  - hiper-v
- glance
 - イメージ単位、ユーザー単位のACL対応
 - バックエンドたくさんある
- neutron
 - ovs分散仮想ルーター
 - L3エージェント強化。HA
 - A10-LBのドライバー追加
- cinder
 - ストレージバックエンドのreplication対応
 - 複数ボリュームの同時スナップショット
- keystone
- telemetry(ceilometer)
 - 性能改善
 - イベントでmongodbのとき、アラーム用にRDBMS
- trove
 - クラスタリング対応
 - mongodb,mysql
 - postgresql対応
- sahara
 - hadoop2.4対応
 - apache spark

## nova RESTAPI

### nova apiの過去

- 一貫性がない
 - リクエストチェック不足
 - エラーがわからない。商用に影響あり。
- nova v3 api開発
 - 1年かけた
 - 一貫性修正のために後方互換性がなくなった
- nova v2.1 apiの提案
 - v3の上にv2のラッパー置いた
 - メンテナンスコスト削減
 - 否決。。
 - これはv3がベストという前提の案

### nova apiの現在

- 別実装のv2.1
- json-schema

### nova apiの未来

- microversioning
- json-home

## neutron udpate in juno

- distributed virtual router(DVR)
- L3-HA
 - masterとslaveの仮想ルーターが異なるホストに配置される
- ipv6 full support
- security group
 - iptablesベース
- nova-networkからneutronへのマイグレーション準備
 - neutronがデフォルトになるけど1年以上先にはなる
- 既存機能のbugfixがあるので使うならjuno
- DVR,L3-HAは新機能だからバグあるかも。
- icehouseでもクリティカルなものは特にないけど。

## 楽天でのopenstackの取り組み

- なんで入れたか？
 - RESTAPI
 - インフラ抽象化
 - OSS使いたい
- icehouce使ってる
 - swiftは使ってない。独自ストレージ。
 - glance=ZFS
 - auth(keystone)=LDAP
 - LB=A10
 - min=20servers
 - 楽天既存のものを組み込んでる。
- region3つ、AZ4つ
 - ネットワークの単位がregion
 - 5000VMで1region
- centos80%,ubuntu20%(paas)
 - 物理2台で438VM動かしてる！！
- 冗長化コンセプト
 - 1process/1server
 - APInode複数冗長
 - VMwareHAに頼ってる
- customize
 - forkするとその後のメンテが大変
 - vmwareでopenstack動かすと結構ハマる！
 - 結構ごりごり。。
- impression
 - 難しい。
 - 他者は参考にならない。(みんな独自実装。。)
 - VMwareまわりのバグ踏みまくり。。
 - 楽しい。
 - フルスタック。
 - ベストプラクティスはない
- roadmap
 - hybrid cloud private/public
 - Autoscaleやりたい。(楽天は手作業！)
 - LeoFS(ストレージ)をopenstackに。
 - ボランティア4人で16000VM(たしか)動かしてる！(業務外)

## まとめ

- すげー楽しかった。
