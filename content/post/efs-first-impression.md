---
title: "Amazon EFSがリリースされたので触ってみた"
date: 2016-06-29
comments: true
tags: ["aws","efs"]
---




<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">EFSが正式リリースされたけど、そろそろクラメソさんがブログアップしてくれる頃だと思って待機してる。</p>&mdash; 洋@豆腐 (@youyo\_) <a href="https://twitter.com/youyo_/status/748047484929314816">2016年6月29日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

と思って待ってたけどこのときはまだ出てなかったので自分で触ってみることにした。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">とりあえずEFS作成してみた。オレゴンとか触らなすぎてVPCの作成からやった..</p>&mdash; 洋@豆腐 (@youyo\_) <a href="https://twitter.com/youyo_/status/748052896932073472">2016年6月29日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">ほー、丁寧な説明付。 <a href="https://t.co/8oKPwUoLXb">pic.twitter.com/8oKPwUoLXb</a></p>&mdash; 洋@豆腐 (@youyo\_) <a href="https://twitter.com/youyo_/status/748053419269701633">2016年6月29日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">key pairがない！ オレゴンに振り回されている。</p>&mdash; 洋@豆腐 (@youyo\_) <a href="https://twitter.com/youyo_/status/748053850922311680">2016年6月29日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">とりあえず丁寧な説明の通りにやったらすんなりマウントまでできた。 <a href="https://t.co/sV4kbvqz0x">pic.twitter.com/sV4kbvqz0x</a></p>&mdash; 洋@豆腐 (@youyo\_) <a href="https://twitter.com/youyo_/status/748055431474405376">2016年6月29日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">[緩募] fioの雑なコマンド.<br>いつもオプション何つけてたかなー</p>&mdash; 洋@豆腐 (@youyo\_) <a href="https://twitter.com/youyo_/status/748057303090290690">2016年6月29日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">とりあえずsequential write bs=4k で300iopsくらいかな。<a href="https://t.co/5ersogTlzF">https://t.co/5ersogTlzF</a></p>&mdash; 洋@豆腐 (@youyo\_) <a href="https://twitter.com/youyo_/status/748060728519589888">2016年6月29日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">random writeでも変わらない。<a href="https://t.co/7fG7RCbJAE">https://t.co/7fG7RCbJAE</a></p>&mdash; 洋@豆腐 (@youyo\_) <a href="https://twitter.com/youyo_/status/748061720946446336">2016年6月29日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">なお、t2.microという大変ケチったインスタンスでの検証であり、ロードアベレージが数十まで上がっているのでインスタンスがボトルネックであると大いに予想されます。鵜呑みにせぬようご注意願います。</p>&mdash; 洋@豆腐 (@youyo\_) <a href="https://twitter.com/youyo_/status/748062240633323520">2016年6月29日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">同時接続数が増えてもiops落ちないとかそういうものだったりするのかなぁ。</p>&mdash; 洋@豆腐 (@youyo\_) <a href="https://twitter.com/youyo_/status/748062514106114048">2016年6月29日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">用途にHPC,BIgDataとか書いてるから同時接続とシーケンシャルに振ってる可能性はあると思う</p>&mdash; Masashi Terui (@marcy_terui) <a href="https://twitter.com/marcy_terui/status/748064533814509568">2016年6月29日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">とりあえず田舎は300iops出れば十分なのでこれでよしとする。</p>&mdash; 洋@豆腐 (@youyo\_) <a href="https://twitter.com/youyo_/status/748062667915440128">2016年6月29日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">cloud watchメトリクスはこんな感じ。 <a href="https://t.co/wzjYKv3Ixs">pic.twitter.com/wzjYKv3Ixs</a></p>&mdash; 洋@豆腐 (@youyo\_) <a href="https://twitter.com/youyo_/status/748065265976381440">2016年6月29日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">なんらかcreditを消費してburstしたみたいだけど、単位がでかくてよく分からないw <a href="https://t.co/0L502jUtAF">pic.twitter.com/0L502jUtAF</a></p>&mdash; 洋@豆腐 (@youyo\_) <a href="https://twitter.com/youyo_/status/748065957688414209">2016年6月29日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">お、スループットで制限されてたのかな？ <a href="https://t.co/zcG9rswuGO">pic.twitter.com/zcG9rswuGO</a></p>&mdash; 洋@豆腐 (@youyo\_) <a href="https://twitter.com/youyo_/status/748066425030356993">2016年6月29日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr"><a href="https://twitter.com/youyo_">@youyo_</a> 保存容量が1TB未満は100MB/sで頭打ちって書いてましたねー</p>&mdash; Masashi Terui (@marcy_terui) <a href="https://twitter.com/marcy_terui/status/748067273139585024">2016年6月29日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">ドキュメントはちゃんと読もう。(戒</p>&mdash; 洋@豆腐 (@youyo\_) <a href="https://twitter.com/youyo_/status/748067529533251588">2016年6月29日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

- セットアップについて全然触れてないけどものすごく簡単だった。
- 各AZごとに適用するSecurityGroupを変更できるっぽい。
- 最近もgoofysで痛い目見たからEFSには期待してる！

こちらからは以上です。
