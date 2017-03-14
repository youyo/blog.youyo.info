---
title: "Xbuildでrubyセットアップメモ"
thumbnailImage: images/eye-catch/default.png
thumbnailImagePosition: left
metaAlignment: left
date: 2015-05-27
categories:
- technology
tags:
- ruby
- xbuild
---

```
yum install epel-release
yum install make gcc kernel-devel zlib-devel openssl-devel readline-devel curl-devel sqlite-devel libyaml-devel libffi-devel
cd /usr/local/
git clone https://github.com/tagomoris/xbuild.git
/usr/local/xbuild/ruby-install 2.2.2 /usr/local/ruby-2.2.2
echo 'export PATH=/usr/local/ruby-2.2.2/bin:$PATH' > /etc/profile.d/ruby-2.2.2.sh
exec $SHELL -l
gem install bundler
```
