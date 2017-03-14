---
title: "Opendkim設定"
thumbnailImage: images/eye-catch/default.png
thumbnailImagePosition: left
metaAlignment: left
date: 2014-10-21
categories:
- technology
tags:
- mail
- opendkim
- postfix
---

opendkimの設定したのでメモ。

<!--more-->

- opendkim,postfix

```
yum install sendmail-devel openssl-devel opendkim --enablerepo=epel
DOMAIN=test.youyo.info
mkdir /etc/opendkim/keys/${DOMAIN}
opendkim-genkey -D /etc/opendkim/keys/${DOMAIN}/ -d ${DOMAIN} -s default
chown -R opendkim:opendkim /etc/opendkim/keys
mv /etc/opendkim/keys/${DOMAIN}/default.private /etc/opendkim/keys/${DOMAIN}/default

vim /etc/opendkim.conf
----------------------------------------------------------
Mode sv           #sは送信時の署名、vは受信時の確認
#KeyFile      /etc/opendkim/keys/default.private
KeyTable      refile:/etc/opendkim/KeyTable
SigningTable      refile:/etc/opendkim/SigningTable
ExternalIgnoreList    refile:/etc/opendkim/TrustedHosts
InternalHosts     refile:/etc/opendkim/TrustedHosts
----------------------------------------------------------

vim /etc/opendkim/KeyTable
-----------------------------------------------------------------------------------------------------
default._domainkey.test.youyo.info test.youyo.info:default:/etc/opendkim/keys/test.youyo.info/default
-----------------------------------------------------------------------------------------------------

vim /etc/opendkim/SigningTable
-----------------------------------------------------
*@test.youyo.info default._domainkey.test.youyo.info
-----------------------------------------------------

cat /etc/opendkim/keys/${DOMAIN}/default.txt 
----------------------------------------------------------------------------------------------------
default._domainkey    IN  TXT ( "v=DKIM1; k=rsa; "
    "p=MIGfMA0SIb3DQEB.........AQUJd1j+P+QIDAQAB" )  ; ----- DKIM key default for test.youyo.info
----------------------------------------------------------------------------------------------------

vim /etc/postfix/main.cf
-----------------------------------------------------------------------
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain

smtpd_milters = inet:127.0.0.1:8891
non_smtpd_milters       = $smtpd_milters
milter_default_action   = accept
-----------------------------------------------------------------------

service postfix check
```

- dns

```
_adsp._domainkey IN TXT  "dkim=unknown"
default._domainkey    IN TXT  "v=DKIM1; k=rsa; p=MIGfMA0SIb3DQEB.........AQUJd1j+P+QIDAQAB"
```

- 反映

```
service opendkim start
chkconfig opendkim on
service postfix restart
```

- ドメイン追加時

```
DOMAIN=test2.youyo.info
mkdir /etc/opendkim/keys/${DOMAIN}
opendkim-genkey -D /etc/opendkim/keys/${DOMAIN}/ -d ${DOMAIN} -s default
chown -R opendkim:opendkim /etc/opendkim/keys
mv /etc/opendkim/keys/${DOMAIN}/default.private /etc/opendkim/keys/${DOMAIN}/default

vim /etc/opendkim/KeyTable
------------------
default._domainkey.test2.youyo.info test2.youyo.info:default:/etc/opendkim/keys/test2.youyo.info/default
------------------

vim /etc/opendkim/SigningTable
------------------
*@test2.youyo.info default._domainkey.test2.youyo.info
------------------

dns設定

service opendkim restart
```
