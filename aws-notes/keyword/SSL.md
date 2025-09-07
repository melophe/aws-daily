# SSL認証

## 概要
通信相手が本物かどうかを確認しつつ、通信内容を暗号化する仕組み

もともとは「SSL（Secure Sockets Layer）」という規格で、今は改良版の「TLS（Transport Layer Security）」が主流。AWSのサービスでも「SSL接続」と書いてあって実際はTLSを使っている

**「相手が正しいサーバーであることを確認し、盗聴されないように通信を暗号化する仕組み」**

## 何が保証されるか
- **暗号化**：通信が盗聴されても内容が読まれない
- **認証**：サーバーが「本物」であることを確認できる
- **改ざん防止**：通信途中でデータが書き換えられない

## AWSの例
- **RDS にSSL接続** → 通信路を暗号化してDBパスワードやIAMトークンを保護
- **ALB/CloudFront** → HTTPSを有効化してブラウザからの通信を暗号化
- **S3** → HTTPSでオブジェクトをやり取り

---

# HTTPSとの関係

## 「HTTPをHTTPSにする」＝SSL/TLSの使い方のひとつ
HTTP → HTTPS にするのは、SSL/TLSをWeb通信に適用した例

- HTTPSの「S」は Secure の意味で、「HTTP + SSL/TLS暗号化」
- 「SSL認証」自体は通信暗号化＋認証の仕組み
- 「HTTPをHTTPSにする」はその仕組みを Web通信で利用した具体例

## 他の例
- **RDS接続** → MySQLやPostgreSQLのクライアント通信にSSL/TLSを適用
- **SMTP (メール送信)** → SMTPS として暗号化
- **FTP** → FTPS として暗号化

## まとめ
「SSL/TLS」はプロトコルに依存せず使える暗号化の仕組みで、HTTPに適用するとHTTPSになる、という関係