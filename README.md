# ドメインの末尾に「.」を付けても何故サイトにアクセス出来るのか

## YouTube のドメイン末尾に「.」を付けると広告が回避出来るとの記事

[fyi: You can bypass youtube ads by adding a dot after the domain](https://www.reddit.com/r/webdev/comments/gzr3cq/)  
[URLに「.」を追加するだけでウェブサイトの広告を回避できる可能性があるという指摘](https://gigazine.net/news/20200611-dot-host-error/)

## そもそも、ドメインで利用出来る文字に「.」は有るのか

JPNICの[ドメイン名の構成](https://www.nic.ad.jp/ja/dom/system.html)より参照。

> ピリオド(.)で区切られた部分は「ラベル」と呼ばれます。 一つのラベルの長さは63文字以下、ドメイン名全体の長さは、 ピリオドを含めて253文字以下でなければなりません。ラベルには、英字(A～Z)、数字(0～9)、 ハイフン( - )が使用できます(ラベルの先頭と末尾の文字をハイフンとするのは不可)。 ラベル中では大文字・小文字の区別はなく、 同じ文字とみなされます。

[RFC 1034 - Domain names - concepts and facilities](https://tools.ietf.org/html/rfc1034#section-3.5)

> The following syntax will result in fewer problems with many applications that use domain names (e.g., mail, TELNET).
>
> \<domain> ::= \<subdomain> | " "
>
> \<subdomain> ::= \<label> | \<subdomain> "." \<label>
>
> \<label> ::= \<letter> [ [ \<ldh-str> ] \<let-dig> ]
>
> \<ldh-str> ::= \<let-dig-hyp> | \<let-dig-hyp> \<ldh-str>
>
> \<let-dig-hyp> ::= \<let-dig> | "-"
>
> \<let-dig> ::= \<letter> | \<digit>
>
> \<letter> ::= any one of the 52 alphabetic characters A through Z in upper case and a through z in lower case
>
> \<digit> ::= any one of the ten digits 0 through 9
>
> Note that while upper and lower case letters are allowed in domain names, no significance is attached to the case.  That is, two names with the same spelling but different case are to be treated as if identical.

ラベルの `.` 以外は `A-Za-z0-9` と `-` しか利用出来ないのに、末尾に「.」を付けても何故サイトにアクセス出来るのか。

## 「 www.youtube.com 」と「 www.youtube.com. 」って何が違うのか

### 試しに名前解決してみる

IPは違うが、問題無く引ける。

```
$ dig www.youtube.com +short
youtube-ui.l.google.com.
172.217.31.174
172.217.174.110
216.58.220.110
-- 省略 --
```

```
$ dig www.youtube.com. +short
youtube-ui.l.google.com.
172.217.175.110
216.58.220.142
172.217.175.78
-- 省略 --
```

### FQDN について調べてみる

JPNICの[FQDNとは](https://www.nic.ad.jp/ja/basics/terms/fqdn.html)より参照。

> 「FQDN」とは、「Fully Qualified Domain Name」の略で、 日本語では主に「完全に指定された(限定された)ドメイン名」などと訳されますが、 「絶対ドメイン名」と呼ばれることもあります。
>
> ツリー(木)構造を持つDNS (Domain Name System)の階層構造において、 ある特定のノードに付けられたドメイン名を表記する際、 そのノードからDNSのルートまでのすべてのラベルを並べて書いたものがFQDNです。
>
> 具体的な例を挙げると、JPNICのWebサーバのFQDNは「www.nic.ad.jp.」となります。 一番左から、「www (第4レベルドメイン)」.「nic (第3レベルドメイン)」.「ad (第2レベルドメイン)」.「jp (トップレベルドメイン)」.「ルート」と、 順にすべてのラベルを表記しています。
>
> ドメイン名の表記においては、一般的にルートは「.」で表されるため、 狭義の意味でのFQDNを表記する際には、末尾の「.」まで含めて表記することが必要です。 ただし、RFCなどで厳密にFQDNの定義が決まっていないことから、「www.nic.ad.jp」のように、 トップレベルドメインまで表記されていれば、広義のFQDNとして扱われる例も増えてきていますので、 こうした表記が必ずしも誤りというわけではありません。
>
> 一方、上記の例における表記の中から、 「www」や「www.nic」などといったドメイン名を抜き出して表記した場合については、 それらの表記は「相対ドメイン名」や「不完全なドメイン名」などと呼ばれます。
>
> 日常的に、多くのユーザーがインターネットを利用する際には、 サーバ側やクライアント側がドメイン名を補ってFQDNを用いて通信するため、 ユーザー自身が特段FQDNを意識する必要はありません。ただし、DNSのドメイン名空間において、 あるノードを一意に特定する必要がある場合には、FQDNが利用されます。 例えば、DNSのゾーンファイルなどを記述する際には、FQDNを用いて設定する場合があります。

「www.youtube.com」は、**相対ドメイン**で  
「www.youtube.com.」は、**絶対ドメイン**という違いがあるらしい。

RFC で FQDN の定義が厳密に決まっていない為、末尾の「.」は合っても無くても大丈夫みたい。  

相対ドメインで FQDN する際のスタート・ポイントは、必ずルートネームサーバになる為、末尾の「.」が省略されても問題無く名前解決が出来る。

```
. <= ルートネームサーバ（ここから問い合わせがスタートする）
├── com
│   └── youtube
│       └── www
└── jp
    └── co
        ├── google
        │   └── www
        └── yahoo
            └── www
```

## FQDN の問い合わせをトレースしてみる

`.` => `com` => `youtube` => `www` の順に問い合わせてるのが確認出来る。

```
$ dig www.youtube.com +trace

; <<>> DiG 9.10.6 <<>> www.youtube.com +trace
;; global options: +cmd
.                       509636  IN      NS      a.root-servers.net.
.                       509636  IN      NS      b.root-servers.net.
.                       509636  IN      NS      c.root-servers.net.
-- 省略 --

com.                    172800  IN      NS      a.gtld-servers.net.
com.                    172800  IN      NS      b.gtld-servers.net.
com.                    172800  IN      NS      c.gtld-servers.net.
-- 省略 --

youtube.com.            172800  IN      NS      ns2.google.com.
youtube.com.            172800  IN      NS      ns1.google.com.
youtube.com.            172800  IN      NS      ns3.google.com.
-- 省略 --

www.youtube.com.        86400   IN      CNAME   youtube-ui.l.google.com.
youtube-ui.l.google.com. 300    IN      A       172.217.174.110
youtube-ui.l.google.com. 300    IN      A       172.217.175.238
youtube-ui.l.google.com. 300    IN      A       216.58.220.110
-- 省略 --
```

# 余談

Docker で Nginx を用意して、末尾に「.」付けてアクセスしてみた。

```
$ http -p hH http://localhost.lvh.me.:3002/
GET / HTTP/1.1
Accept: */*
Accept-Encoding: gzip, deflate
Connection: keep-alive
Host: localhost.lvh.me.:3002 ★ホストは末尾に「.」が付いてる
User-Agent: HTTPie/1.0.2

HTTP/1.1 200 OK
Accept-Ranges: bytes
Connection: keep-alive
Content-Length: 123
Content-Type: text/html
Date: Fri, 19 Jun 2020 09:40:51 GMT
ETag: "5ee5f327-7b"
Last-Modified: Sun, 14 Jun 2020 09:51:35 GMT
Server: nginx/1.19.0
```

Nginx のアクセスログに `$host` を出力してみたが、末尾の「.」が消えてた。

```
nginx-container
172.19.0.1
-
-
[19/Jun/2020:09:42:33 +0000]
"localhost.lvh.me" ★ホストの末尾の「.」が消えた
"GET / HTTP/1.1"
200
123
"-"
```

サイトの広告が表示されなくなるから、末尾に「.」が付いたドメインを防ぎたい時はどうするんだろうか。
