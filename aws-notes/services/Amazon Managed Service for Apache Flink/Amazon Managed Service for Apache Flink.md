# Amazon Managed Service for Apache Flink

ストリーミングデータをリアルタイムで処理するマネージドサービス。

元の名前はAmazon Kinesis Data Analytics for Apache Flink（2023年にリネーム）。Apache Flinkというオープンソースの分散ストリーム処理フレームワークをAWSがフルマネージドで提供する。

## できること

### リアルタイム分析
- IoTセンサーのデータを秒単位で分析
- 金融取引ログをリアルタイムで不正検知

### ストリーム変換 & ETL
データをフィルタ、変換、集約して次のサービスに渡す
- 例：JSONをパースして整形 → S3やRedshiftに格納

### イベント駆動アプリケーション
特定条件にマッチしたらアラートを発出
- 例：在庫が閾値を下回ったら通知

## 特徴

### マネージド
Flinkクラスタの管理（プロビジョニング、スケーリング、パッチ適用）をAWSが担当

### 統合先が豊富
- **入力**：Kinesis Data Streams、Managed Kafka (MSK)、自前のKafka等
- **出力**：S3、DynamoDB、Redshift、OpenSearch、Kinesis Data Streams、Firehose等

### スケーラブル
データ量に応じてスケール可能

### 言語サポート
- FlinkのアプリケーションをJava/Scala/Pythonで開発可能
- SQLモードもある（簡単なクエリ処理向け）

## 用途例

| 分野 | 用途 |
|------|------|
| **ECサイト** | ユーザーの行動ログを即時分析してレコメンド |
| **IoT** | 工場のセンサーデータをリアルタイム監視 |
| **金融** | トランザクションのリアルタイム不正検知 |
| **運用** | アプリログを解析して即時アラート |

## まとめ

- **Apache Flink** = オープンソースのリアルタイム処理エンジン
- **Amazon Managed Service for Apache Flink** = それをAWSがマネージドで提供
- **メリット** = 管理不要、AWSサービスと統合しやすい、リアルタイム処理を簡単に導入可能