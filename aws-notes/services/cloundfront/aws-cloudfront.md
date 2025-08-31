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

#### ✅ ACM が使えるサービス

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