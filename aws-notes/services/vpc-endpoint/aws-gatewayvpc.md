# NAT Gateway vs VPC Endpoint

## NAT Gateway を使わない理由

### コスト面
- NAT Gateway自体に「時間単価＋通信量課金」が発生
- S3のような大量データ通信で高コストになる
- Gateway VPC Endpointなら追加料金なしでS3/DynamoDBにプライベート接続

### セキュリティ面
- NAT Gateway: 外（インターネット）経由でAWSサービスにアクセス
- 外部通信経路が存在するセキュリティリスク
- VPC Endpoint: AWSネットワーク内で完結するため安全

### 構成のシンプルさ
- NAT Gateway: インターネットゲートウェイやルートテーブル設定が必要
- VPC Endpoint: 特定サービスへのプライベートルートを追加するだけ

---

## 基本的な使い分け

| サービス | 用途 |
|---------|------|
| **NAT Gateway** | プライベートサブネットからインターネットに出る出口 |
| **Gateway VPC Endpoint** | 特定サービス（S3/DynamoDB）への専用近道 |

---

## VPC Endpoint の種類

### Gateway VPC Endpoint (S3/DynamoDB)

#### 特徴
- インターネット経由せずAWSバックボーン内で接続
- 完全プライベート通信
- 追加コストなし
- S3, DynamoDB のみ対応

### Interface VPC Endpoint (PrivateLink)

#### 特徴
- ENI経由で通信、インターネット経由なし
- 他のAWSサービスにもプライベート接続可能
- 完全プライベート通信

---

## 各アプローチの詳細比較

### NAT Gateway

#### 配置・設定
- **配置場所**: パブリックサブネット（IGWへのルートがあるサブネット）
- **関連付け**: プライベートサブネットのルートテーブルに設定
- **設定例**: `宛先: 0.0.0.0/0 → NAT Gateway`

#### 通信フロー
1. プライベートサブネットのEC2 → NAT Gateway
2. NAT Gateway → IGW経由でインターネット

外に出る出口として動作

### Gateway VPC Endpoint (S3 / DynamoDB)

#### 配置・設定
- **配置場所**: VPC単位（サブネットには非配置）
- **関連付け**: 指定したルートテーブルに追加
- **設定例**: `宛先: com.amazonaws.ap-northeast-1.s3 → vpce-xxxxxx`

#### 通信フロー
1. プライベートサブネットのEC2 → VPC Endpoint
2. AWS内部ネットワークを通って直接S3/DynamoDBへ

インターネットもNATも不要で完全プライベート接続

### Interface VPC Endpoint (PrivateLink)

#### 配置・設定
- **配置場所**: サブネット（ENIとして作成）
- **関連付け**: DNS解決がそのENIに向く（ルートテーブルに特別な記述不要）

#### 通信フロー
1. EC2 → ENI（Interface Endpoint）
2. AWS内部でサービスへ接続

ENIに直接アタッチされるイメージ

---

## 配置・関連付け比較表

| 種類 | 配置場所 | 関連付け方法 |
|------|----------|-------------|
| **NAT Gateway** | パブリックサブネット | プライベートサブネットのルートテーブル |
| **Gateway VPC Endpoint** | VPC | 対象ルートテーブル |
| **Interface VPC Endpoint** | ENIがサブネット内 | DNSで自動経路振り替え |

---

## Interface型VPCエンドポイントとENI

### ENI作成の仕組み
Interface型VPCエンドポイントを作成すると、VPC内の指定したサブネットにENIが自動作成される

そのENIがAWSサービス専用の窓口となる

### 対応サービス例
- S3のプライベートエンドポイント
- SNS / SQS / CloudWatch Logs / KMS等

### 通信方式
VPC内のリソースは、このENIに向かって通信するだけでインターネットに出ずに直接AWSサービスと通信可能

Interface型エンドポイント = VPC内に専用のENIを配置する仕組み

---

## VPCエンドポイント2種類の詳細比較

### Gateway型エンドポイント（S3 / DynamoDB専用）

#### 仕組み
- ENIは作成されない
- ルートテーブルに専用ルートを追加
- 例：`10.0.0.0/16 → vpce-xxxx` のエントリが作成される

#### 通信経路
ルートテーブルを経由してAWSバックボーンへ

#### 特徴
- シンプル & 安価（利用料金無料、転送料のみ）
- S3やDynamoDBのような大量アクセスを想定するサービス向け

### Interface型エンドポイント（その他ほとんどのサービス）

#### 仕組み
- VPC内にENIを作成
- そのENIがAWSサービス専用のNICとなる
- VPC内のリソースは、このENIを宛先にして通信

#### 特徴
- ENIのためセキュリティグループやDNS名も使用可能
- 利用料金発生（月額 + データ処理量）
- SQS / SNS / CloudWatch / KMS / Secrets Manager等幅広いサービス対応

---

## VPCエンドポイントとPrivateLinkの関係

### VPCエンドポイント
VPC内からAWSサービスにプライベートにアクセスする仕組み

- Gateway型（S3 / DynamoDB）
- Interface型（その他サービス）

### PrivateLink
Interface型VPCエンドポイントの技術基盤

AWS公式サービスだけでなく、自分のサービスや他のアカウントのサービスをプライベートに公開できる仕組み

Interface型VPCエンドポイントを一般化したもの

---

## 利用場面別の選択指針

### S3にプライベートアクセス
Gateway型VPCエンドポイント

### SQSやKMSにプライベートアクセス
Interface型VPCエンドポイント（裏側はPrivateLink技術）

### 自分のVPC内サービスを別アカウントのVPCからプライベート利用
PrivateLink（カスタムサービス公開）

---

## まとめ

### アプローチ別特徴
- **Gateway型**: ルートテーブルに専用の裏口を追加
- **Interface型**: VPCに専用のNICを配置してそのNICを通じて通信
- **PrivateLink**: Interface型の技術を使ったサービス間プライベート接続

### 選択基準
- コスト重視かつS3/DynamoDB利用 → Gateway型
- 他AWSサービス利用 → Interface型
- カスタムサービス公開 → PrivateLink

---

## VPCエンドポイント vs VPCエンドポイントサービス

### VPCエンドポイント（VPC Endpoint）

#### 概要
利用者側の仕組み

VPCの中からAWSサービスやPrivateLinkサービスにアクセスするためのドア

#### 種類
- Gateway型（S3 / DynamoDB用）
- Interface型（その他のAWSサービス、またはPrivateLinkサービス用）

#### 作成場所
自分のVPCの中

「使う側の入り口」

### VPCエンドポイントサービス（VPC Endpoint Service）

#### 概要
提供者側の仕組み

自分のVPC内のサービス（通常はNLB配下のアプリケーション）を、PrivateLink経由で他のVPCに公開

#### 接続方法
他アカウントのVPCから「VPCエンドポイント（Interface型）」を作成するとこのサービスに接続

#### アクセス方向
一方向（利用者→提供者）

「提供する側の出口」

---

## 役割の違い

| 項目 | VPCエンドポイント | VPCエンドポイントサービス |
|------|------------------|-------------------------|
| **役割** | 使う側（アクセスするドア） | 提供する側（公開する仕組み） |
| **作成者** | サービス利用者 | サービス提供者 |
| **目的** | AWSサービス or PrivateLinkサービスへアクセス | 自分のアプリをPrivateLinkで公開 |

---

## 具体的な実装

### VPCエンドポイントサービス
提供側が作成するもの

自分のサービス（通常NLB配下）をPrivateLinkで公開する宣言

### Interface型VPCエンドポイント
利用側が作成するもの

提供されたVPCエンドポイントサービスに接続するドア

ENIが作成され、そこから提供側のサービスへプライベートに接続

### Gateway型VPCエンドポイント
S3 / DynamoDB専用でVPCエンドポイントサービスには使用不可

PrivateLink経由の「サービス提供/利用」は全てInterface型で実装