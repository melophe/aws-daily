# Amazon CloudFront

## 基本的な仕組み

### 通信フロー

1. **Viewer** → CloudFront にリクエストを送る（例：ユーザーのブラウザ）
2. **CloudFront** → キャッシュを確認して、なければオリジンに取りに行く
3. **Origin** → コンテンツの本体を持っているサーバーやストレージ

## オリジン設定

### 設定可能なオリジン

CloudFront のオリジンとしては以下が選択可能：

- **S3 バケット**（静的コンテンツ配信の定番）
- **ELB / ALB**（Web サービスのフロント）
- **EC2 インスタンス**（直接 Web サーバーとして動いている場合）
- **オンプレや外部の Web サーバー**（CloudFront からインターネット越しにアクセス可能）

## SSL/TLS 証明書の設定

### ACM（AWS Certificate Manager）証明書の対応

**ACM で発行した証明書は、AWS マネージドサービスにのみ直接アタッチ可能**

####  ACM が使えるサービス

- **CloudFront**
- **ELB（ALB, NLB, CLB）**
- **API Gateway**
- **App Runner**
- その他一部のマネージドサービス

> これらは AWS が「証明書のインストール・更新」を自動で実行

#### ❌ ACM が使えないケース

- **EC2 上の Web サーバー**（Apache, Nginx, IIS）
- **オンプレミスの Web サーバー**
- **S3 静的ウェブサイトホスティング**（S3 に証明書を配置する仕組みなし）

> 自分でサーバーを管理するリソースでは ACM 証明書を直接配置不可

#### 代替手段

1. **外部 CA から証明書取得**
   - Let's Encrypt, DigiCert などから証明書を取得してサーバーにインストール

2. **ACM Private CA 利用**
   - ACM Private CA で発行した証明書をダウンロードしてインストール

### S3 の特殊ルール

#### CloudFront + S3 バケット構成

- **CloudFront 側に ACM 証明書設定** → Viewer との HTTPS 通信が暗号化
- **S3 自体** → AWS が HTTPS エンドポイントを提供（`https://bucket.s3.amazonaws.com`）

> S3 では自前での証明書管理は不要

---

## Cache-Control

### 概要
HTTPレスポンスヘッダーの一つで、コンテンツをキャッシュするか・どのくらいの時間キャッシュするか をブラウザやCDN（CloudFrontなど）に指示するための仕組み

### 代表的なディレクティブ

#### max-age=秒数
キャッシュを保持する最大秒数

#### s-maxage=秒数
CDNなど共有キャッシュ専用の有効期限（CloudFrontはこちらを優先）

#### no-cache
キャッシュはするが、再利用前に必ずオリジン確認

#### no-store
一切キャッシュさせない

#### public / private
public は共有キャッシュ可、private はユーザ専用キャッシュのみ

## CloudFrontとCache-Controlの関係

CloudFrontはオリジン（例: S3, ALB, EC2）からレスポンスを受け取ったとき、以下を見てキャッシュ挙動を決定

### 優先順位
1. **Cache-Control: s-maxage** → これがあれば最優先で使われる
2. **Cache-Control: max-age** → s-maxageが無ければこれを参照
3. **Expires ヘッダー** → Cache-Controlが無ければ参照
4. **CloudFrontのデフォルトTTL設定** → それらが無ければこれを利用

### CloudFront側での制御
CloudFrontには キャッシュポリシー があり、オリジンからのヘッダーをどう扱うか選べる

#### Use origin cache headers
オリジンの Cache-Control / Expires をそのまま尊重

#### Customize
CloudFront側でTTLを強制指定（オリジン無視も可能）

#### Caching disabled
キャッシュを完全にしない

## よくある使い方

### 静的コンテンツ (画像, CSS, JS)
```
Cache-Control: public, max-age=31536000, immutable
```
（1年キャッシュ、変更はファイル名にハッシュを付けて対応）

### 動的コンテンツ (APIレスポンスなど)
```
Cache-Control: no-store または private, no-cache
```

### S3をオリジンに使う場合
S3オブジェクトのメタデータで Cache-Control を設定可能（CLIやS3コンソールから設定できる）

## 注意点
- CloudFrontがオリジンの指示を無視する設定になっている場合、Cache-Controlを送っても効かない ことがある
- 動的APIのキャッシュは要注意（個人情報や更新頻度高いデータはキャッシュしない方が安全）
- キャッシュ削除は Invalidation を使う必要がある（設定TTL待ちでは時間がかかる）

## max-age を長くする効果
CloudFrontやブラウザがオリジンに問い合わせる頻度を減らせる

その結果、キャッシュヒット率が向上し、レイテンシも下がり、オリジン負荷も軽減される

### (1) 更新とのトレードオフ
- max-age を長くしすぎると、コンテンツ更新後も古いデータが配信される
- 特にAPIや頻繁に更新されるHTMLでは問題になりやすい

### (2) s-maxage の活用
s-maxage は CDN専用キャッシュ時間

例: `Cache-Control: s-maxage=3600, max-age=60` とすると
- ブラウザキャッシュは 60秒
- CloudFrontキャッシュは 3600秒

これで「CDNでは効率的にキャッシュ」「ユーザーは比較的新鮮なデータを得られる」というバランスが取れる

### (3) キャッシュキーの最適化
- クエリパラメータ や Cookie がキャッシュキーに含まれると、キャッシュが分散してヒット率が下がる
- CloudFrontの キャッシュポリシー で「不要なクエリやCookieを無視」するとヒット率が改善する

### (4) Immutable ファイル戦略
JS/CSS/画像など、ビルド時にハッシュ付きファイル名にする
- 例: `app.abc123.js`

これなら `Cache-Control: public, max-age=31536000, immutable` としても問題ない

更新時はファイル名が変わるので古いキャッシュが影響しない

## 実践でよくやるパターン
- **静的アセット（CSS/JS/画像）** → `max-age=31536000, immutable`
- **APIレスポンス（更新あり）** → `s-maxage=60, max-age=0, must-revalidate`
- **HTML（トップページなど）** → `s-maxage=300, max-age=0`