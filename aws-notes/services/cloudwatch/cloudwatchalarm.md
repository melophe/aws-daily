

# CloudWatch から直接連携できる主なサービス

## 1. アラーム発火時のアクション

### Amazon SNS
- 通知メール、SMS、Webhook などに送信

### Amazon EC2 Auto Scaling
- スケールアウト / スケールインのトリガー

### EC2 インスタンス
- アラームで **停止 / 終了 / リブート / 回復 (recover)** を実行可能

## 2. CloudWatch Logs と連携

### Amazon Kinesis Data Streams / Data Firehose
- ログをリアルタイムにストリーミング処理

### AWS Lambda
- ログイベントをトリガーにLambdaを起動して処理

### Amazon OpenSearch Service (旧Elasticsearch)
- ログ検索・可視化

## 3. CloudWatch Events / EventBridge と連携

(ℹ️ CloudWatch Eventsは今は EventBridge に統合済み)

- **Lambda**
- **Step Functions**
- **SNS / SQS**
- **Kinesis Streams / Firehose**
- **ECS / Batch / CodePipeline** など多数のAWSサービス

## 4. ダッシュボードやメトリクスでの連携

### AWS Service Metrics
- RDS, DynamoDB, S3, ALB など各サービスのメトリクスを自動的に CloudWatch に送信

### CloudWatch Contributor Insights
- VPC Flow Logs, Route 53 Logs, ALB/NLB Logs などと連携

---

# CloudWatch連携パターン

## 「直接」アクションできる代表例
- **SNS通知**
- **EC2操作**（停止/終了/リブート/回復）
- **Auto Scaling**

## Logs/EventBridge 経由で連携可能
- Lambda, SQS, Kinesis, Step Functions, OpenSearch など

---

## 推奨パターン

**CloudWatch + SNS** の組み合わせは確実に機能し、Lambdaなどの中間処理なしで直接連携できるため、**シンプルかつ確実なソリューション**