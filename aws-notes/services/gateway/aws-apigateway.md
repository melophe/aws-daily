# Amazon API Gateway

## 概要
**「REST APIやWebSocket APIを簡単に作成・公開・管理できるサービス」**

アプリケーションのフロントドアのような役割を果たす

## 主な機能

### APIの作成と公開
- REST API / HTTP API / WebSocket API を簡単に構築可能
- URLエンドポイントを公開して、バックエンド（Lambda, EC2, ECS, VPC, SaaSサービスなど）につなげられる

### リクエスト制御
- 認証・認可（IAM、Cognito、Lambda Authorizer）
- レート制限、スロットリング、APIキーによる制御

### 変換・統合
- リクエストやレスポンスを変換して、バックエンドに合わせた形式に変換
- 複数のマイクロサービスを1つのAPIとしてまとめられる

### モニタリング
- CloudWatchと連携してリクエスト数、レイテンシ、エラーレートを可視化

### スケーラビリティ
- 自動でスケーリング（数リクエスト/秒から数十万リクエスト/秒まで対応可能）
- インフラ管理は不要

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

- クライアントのリクエストが多すぎると、API Gateway 側で **429 Too Many Requests** を返す
- バックエンド（LambdaやEC2）がリクエスト過多でダウンするのを防げる

### スロットリングの種類

#### 1. ステージ単位のスロットリング
API Gateway のステージ（例: dev, prod）ごとに設定

- **レート (Rate)**: 1秒あたりのリクエスト数
- **バースト (Burst)**: 短時間に許可する最大同時リクエスト数

**例:**
- Rate = 100 req/sec
- Burst = 200 req

通常は100/秒だけど、瞬間的に200までは許可、それ以上は 429

#### 2. APIキーごとのスロットリング
- APIキーと**使用プラン (Usage Plan)** を組み合わせて、特定のユーザーごとに制限可能
- 「無料プランは 10req/sec」「有料プランは 100req/sec」みたいに制御できる

### まとめ
- API Gateway にはスロットリング機能あり
- **Rate（秒あたり）** と **Burst（一時的な上限）** を組み合わせて制御
- ステージ単位・APIキー単位で設定できる
- 超過すると **429 Too Many Requests** を返す

**API Gateway はリクエスト数を制御して、バックエンドを守るためのスロットリング機能を持つ**

---

# API Gateway レスポンスキャッシュ

## 概要
- 同じリクエストに対して一定期間キャッシュされたレスポンスを返す
- バックエンド(Lambdaなど)の呼び出しを減らせる
- **パフォーマンス改善** & **コスト削減**につながる

### 特徴

#### キャッシュ単位
- ステージごとにキャッシュを有効化可能
- キャッシュは APIのメソッド + クエリパラメータ + ヘッダ の組み合わせで判定

#### キャッシュサイズ
- 0.5GB 〜 237GB を選択できる（デフォルトは有効化されていない）

#### キャッシュ有効期間 (TTL)
- デフォルト: 300秒 (5分)
- 1秒 〜 3600秒 (1時間) の範囲で設定可能

#### キャッシュクリア
- 手動でキャッシュ削除（API Gatewayコンソール or CLIから）
- デプロイ時に自動でキャッシュ削除設定も可能

### メリット
- **レイテンシ改善**: API Gatewayが直接キャッシュを返すので高速
- **コスト削減**: Lambdaやバックエンドの呼び出し回数が減る
- **スパイク対策**: 広告やキャンペーンで急激にアクセスが増えてもバックエンドへの負荷を抑えられる

### デメリット・注意点
- **動的データには不向き**: 最新情報が必須なデータ（例: 銀行残高）はキャッシュに不適
- **追加コスト**: API Gatewayのキャッシュ容量ごとに追加課金される
- **ステージ単位でしか有効化できない**（メソッド単位では不可。ただし「キャッシュキー」を細かく設定することで挙動を制御できる）

### ユースケース
- ニュース記事一覧、商品一覧、ランキングAPI
- 認証済みユーザーごとに同じデータを返すAPI
- 読み取り頻度が高く、変更頻度が比較的低いデータ

# API Gateway と統合できるサービス一覧
## コンピュート

### AWS Lambda
最も一般的。REST/HTTPリクエストを関数実行へ変換

## HTTP API ファーストクラス統合

### EventBridge
- EventBridge-PutEvents（イベントを EventBridge に送信）

### SQS
- SQS-SendMessage（メッセージ送信）
- SQS-ReceiveMessage（メッセージ取得）
- SQS-DeleteMessage（メッセージ削除）
- SQS-PurgeQueue（キュー空にする）

### AppConfig
- AppConfig-GetConfiguration（設定取得）

### Kinesis Data Streams
- Kinesis-PutRecord（ストリームにデータ投入）

### Step Functions
- StepFunctions-StartExecution（ステートマシン実行）
- StepFunctions-StartSyncExecution（同期実行）
- StepFunctions-StopExecution（実行停止）

## REST API 統合（標準）

### AWS Lambda
- AWS_PROXY／AWS 統合で呼び出し可能

### Amazon S3
- オブジェクト操作

### Amazon DynamoDB
- Put/Get/Update/Delete など

### Amazon SNS
- Publish

### Amazon Cognito
- 認証

## VPCプライベートサービス統合
- VPC内のプライベートサービス（ALB/NLB を経由して）への統合は、**VPC Link 機能**を使って可能

---

## まとめ表

| カテゴリ | サービス |
|----------|----------|
| **HTTP API ファーストクラス統合** | EventBridge, SQS, AppConfig, Kinesis, Step Functions |
| **REST API 統合（標準 API）** | Lambda, S3, DynamoDB, SNS, Cognito, Step Functions |
| **プライベートエンドポイント統合** | VPC Link経由で ALB/NLBなど |

### 選択指針
- **HTTP API を使う場合** → EventBridge, SQS, AppConfig, Kinesis, Step Functions などが「サービス統合対象」として明確にサポート
- **REST API や他ユースケース** → Lambda、S3、DynamoDB、SNS、Cognito など、さらに豊富なサービス連携が選択可能
- **VPC 内プライベートサービスと連携** → VPC Link の利用を推奨