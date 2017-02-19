---
title: "Error detected while processing vim_bootstrap_updater.vim"
thumbnailImage: images/eye-catch/vim.png
thumbnailImagePosition: left
metaAlignment: left
date: 2016-01-10
categories:
- technology
tags:
- vim
- brew
---

`brew cask install hoge` とかやったらインストールできなかった。  
調べてみたら `homebrew-cask` が本家に入ったとかで移行が必要なようだった。  
[homebrew-caskがErrorになると思ったら本家に移行してた](http://qiita.com/emonuh/items/5dc518a64e6ca722b08a)  
  
んで `brew update` かけたら `vim` でファイル開いたときにエラー出るようになってた...  
<!--more-->

```
[youyo@MBA ~] $ vim file
Error detected while processing /Users/youyo/.vim/bundle/vim-bootstrap-updater/plugin/vim_bootstrap_updater.vim:
line    4:
E319: Sorry, the command is not available in this version: python import sys
line    5:
E319: Sorry, the command is not available in this version: python import vim
line    6:
E319: Sorry, the command is not available in this version: python sys.path.append(vim.eval('expand("<sfile>:h")'))
Press ENTER or type command to continue</sfile>
```

これまた調べてみるとどうもバグらしい。  
[vim_bootstrap_updater.vim - 'cannot execute :python after using :py3' #156](https://github.com/avelino/vim-bootstrap/issues/156)  
  
```
python import sys
python import vim
python sys.path.append(vim.eval('expand("<sfile>:h")'))
```

これを、

```
python3 import sys
python3 import vim
python3 sys.path.append(vim.eval('expand("<sfile>:h")'))
```

このように `python3` に変更することでとりあえず直るよーって書かれてたのでやってみたらとりあえず直った。  
よかった。
