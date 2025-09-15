# Amazon API Gateway

## 概要
REST APIやWebSocket APIを簡単に作成・公開・管理できるサービス

アプリケーションのフロントドアのような役割を果たす

## 主な機能

### APIの作成と公開
- REST API / HTTP API / WebSocket API を簡単に構築
- URLエンドポイントを公開してバックエンド（Lambda, EC2, ECS, VPC, SaaSサービス等）に接続

### リクエスト制御
- 認証・認可（IAM、Cognito、Lambda Authorizer）
- レート制限、スロットリング、APIキーによる制御

### 変換・統合
- リクエストやレスポンスを変換してバックエンドに合わせた形式に変換
- 複数のマイクロサービスを1つのAPIとしてまとめることが可能

### モニタリング
- CloudWatchと連携してリクエスト数、レイテンシ、エラーレートを可視化

### スケーラビリティ
- 自動でスケーリング（数リクエスト/秒から数十万リクエスト/秒まで対応）
- インフラ管理不要

## 利用シナリオ

### Lambdaとの統合
サーバーレスアプリのフロントエンドとして最も一般的な使い方

### マイクロサービスのエントリーポイント
各サービスを統合して1つのAPIにまとめる

### モバイルアプリやSPAのバックエンド
Cognito認証を組み合わせてセキュアにAPIを公開

### IoTやリアルタイム通信
WebSocket APIでデバイスやクライアントと双方向通信

---

## スロットリング

### 概要
一定時間あたりのリクエスト数を制限する仕組み

- クライアントのリクエストが多すぎると、API Gateway側で **429 Too Many Requests** を返す
- バックエンド（LambdaやEC2）がリクエスト過多でダウンするのを防止

### スロットリングの種類

#### ステージ単位のスロットリング
API Gatewayのステージ（例: dev, prod）ごとに設定

##### 設定項目
- **Rate**: 1秒あたりのリクエスト数
- **Burst**: 短時間に許可する最大同時リクエスト数

##### 設定例
- Rate = 100 req/sec
- Burst = 200 req

通常は100/秒だが、瞬間的に200までは許可、それ以上は 429

#### APIキーごとのスロットリング
- APIキーと**使用プラン (Usage Plan)** を組み合わせて特定のユーザーごとに制限
- 「無料プランは 10req/sec」「有料プランは 100req/sec」のような制御が可能

### スロットリングの動作
- **Rate（秒あたり）** と **Burst（一時的な上限）** を組み合わせて制御
- ステージ単位・APIキー単位で設定可能
- 制限を超過すると **429 Too Many Requests** を返す

---

## レスポンスキャッシュ

### 概要
- 同じリクエストに対して一定期間キャッシュされたレスポンスを返す
- バックエンド(Lambda等)の呼び出しを減らす
- パフォーマンス改善とコスト削減を実現

### キャッシュ設定

#### キャッシュ単位
- ステージごとにキャッシュを有効化
- APIのメソッド + クエリパラメータ + ヘッダの組み合わせで判定

#### キャッシュサイズ
0.5GB 〜 237GB を選択（デフォルトは無効）

#### キャッシュ有効期間 (TTL)
- デフォルト: 300秒 (5分)
- 設定範囲: 1秒 〜 3600秒 (1時間)

#### キャッシュクリア
- 手動でキャッシュ削除（API Gatewayコンソール or CLIから）
- デプロイ時の自動キャッシュ削除設定も可能

### メリット
- **レイテンシ改善**: API Gatewayが直接キャッシュを返すため高速
- **コスト削減**: Lambdaやバックエンドの呼び出し回数を削減
- **スパイク対策**: 急激なアクセス増加時もバックエンドへの負荷を抑制

### 制限事項・注意点
- **動的データには不向き**: 最新情報が必須なデータ（銀行残高等）はキャッシュに不適
- **追加コスト**: API Gatewayのキャッシュ容量ごとに追加課金
- **ステージ単位での有効化**（メソッド単位不可。キャッシュキーの細かい設定で制御可能）

### 適用場面
- ニュース記事一覧、商品一覧、ランキングAPI
- 認証済みユーザーごとに同じデータを返すAPI
- 読み取り頻度が高く、変更頻度が比較的低いデータ

---

## バックエンド統合

### HTTP API ファーストクラス統合

#### EventBridge
- EventBridge-PutEvents（イベントをEventBridgeに送信）

#### SQS
- SQS-SendMessage（メッセージ送信）
- SQS-ReceiveMessage（メッセージ取得）
- SQS-DeleteMessage（メッセージ削除）
- SQS-PurgeQueue（キューを空にする）

#### AppConfig
- AppConfig-GetConfiguration（設定取得）

#### Kinesis Data Streams
- Kinesis-PutRecord（ストリームにデータ投入）

#### Step Functions
- StepFunctions-StartExecution（ステートマシン実行）
- StepFunctions-StartSyncExecution（同期実行）
- StepFunctions-StopExecution（実行停止）

### REST API 統合（標準）

#### AWS Lambda
AWS_PROXY／AWS統合で呼び出し

#### Amazon S3
オブジェクト操作

#### Amazon DynamoDB
Put/Get/Update/Delete等

#### Amazon SNS
Publish

#### Amazon Cognito
認証

### VPCプライベートサービス統合
VPC内のプライベートサービス（ALB/NLB経由）への統合は **VPC Link機能** を使用

---

## 統合可能サービス比較表

| カテゴリ | サービス |
|----------|----------|
| **HTTP API ファーストクラス統合** | EventBridge, SQS, AppConfig, Kinesis, Step Functions |
| **REST API 統合（標準）** | Lambda, S3, DynamoDB, SNS, Cognito, Step Functions |
| **プライベートエンドポイント統合** | VPC Link経由でALB/NLB等 |

---

## AWS サービス統合詳細

### コンピュート・実行系
- **Lambda**: 最も一般的。サーバーレスでコード実行
- **EC2 / ECS / EKS**: HTTP統合でEC2上のアプリやコンテナサービスを呼び出し
- **Elastic Load Balancer (ALB/NLB)**: 複数インスタンスに振り分けてスケール

### ワークフロー・処理系
- **Step Functions**: ワークフロー（バッチ処理や連携タスク）実行

### データベース・ストレージ系
- **DynamoDB**: API Gatewayから直接CRUD操作（専用統合あり）

### メッセージング・通知系
- **SQS**: キューにメッセージを投入。非同期処理で使用
- **SNS**: トピックに通知をパブリッシュ

### ストリーミング・リアルタイム系
- **Kinesis Data Streams / Firehose**: ストリーミングデータ送信

---

## 選択指針

### HTTP API使用時
EventBridge, SQS, AppConfig, Kinesis, Step Functions等がファーストクラス統合として明確にサポート

### REST API使用時
Lambda、S3、DynamoDB、SNS、Cognito等、より豊富なサービス連携が選択可能

### VPC内プライベートサービス連携時
VPC Linkの利用を推奨