# AWS Certificate Manager (ACM)

## ACM 証明書の制約

**AWS Certificate Manager (ACM) で発行した証明書は、AWS マネージドサービスにのみ直接アタッチ可能**

- **対応**: ELB / CloudFront / API Gateway / ALB / NLB などのマネージドサービス
- **非対応**: EC2 上の Apache/Nginx やオンプレサーバー

> **重要**: ACM の無料公開証明書をそのまま EC2 に配置することはできない

## EC2/オンプレサーバーでの HTTPS 実装方法

### 方法1: 外部CA の証明書を使用（推奨）

#### 手順
1. **証明書取得**
   - Let's Encrypt や商用 CA（DigiCert, GlobalSign など）から証明書を取得

2. **サーバーインストール**
   - オリジンサーバー（EC2, オンプレ）にインストール

3. **CloudFront 設定**
   - Origin Protocol Policy = HTTPS only に設定

#### メリット
- **✅ 一般的に最もシンプル**
- コストが比較的安価

### 方法2: ACM Private CA を使用

#### 手順
1. **Private CA 契約**
   - AWS Certificate Manager Private CA を契約

2. **証明書発行・インストール**
   - 証明書を発行してオリジン（EC2など）にインポート

3. **CloudFront 設定**
   - Origin Access Control (OAC) 設定と併用可能

#### 適用ケース
- **✅ 完全に AWS 内で閉じたい場合の選択肢**

### 方法3: 外部証明書の ACM インポート

#### 概要
- 外部 CA で取得した証明書を ACM にインポート可能

#### 制限事項
- **ACM にインポートした証明書を EC2 に配布することは不可**
- 結局はオリジンサーバー側に手動で設置が必要

## ACM 対応サービス

### ✅ ACM が使えるサービス

- **CloudFront**
- **ELB（ALB, NLB, CLB）**
- **API Gateway**
- **App Runner**
- その他一部のマネージドサービス

> AWS が「証明書のインストール・更新」を自動実行

### ❌ ACM が使えないケース

- **EC2 上の Web サーバー**（Apache, Nginx, IIS）
- **オンプレミスの Web サーバー**
- **S3 静的ウェブサイトホスティング**（証明書配置の仕組みなし）

> 自分でサーバーを管理するリソースでは ACM 証明書を直接配置不可

### 代替手段

1. **外部 CA から証明書取得**
   - Let's Encrypt, DigiCert などから証明書を取得してサーバーにインストール

2. **ACM Private CA 利用**
   - ACM Private CA で発行した証明書をダウンロードしてインストール