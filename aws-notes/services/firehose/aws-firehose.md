
# AWS Kinesis Data Firehose

## 概要

**ストリーミングデータをリアルタイムに取得し、データレイクやデータストア、分析ツールに配信するサービス**

## Firehoseの出力先

### サポートしている主な出力先

- **Amazon S3** 
- **Amazon Redshift**（内部的には一度S3に落とす）
- **Amazon OpenSearch Service**（旧Elasticsearch Service）
- **カスタムHTTPエンドポイント**（SaaSや独自アプリ）
- **Splunk**

## S3に流すときの動き

### 基本的な流れ

1. Firehoseが受け取ったデータを、**一定サイズまたは一定時間ごとにバッファリング**してS3に書き込む
2. データはそのままS3に置くことも可能
3. 途中で**変換**（LambdaでJSON→Parquetなど）や**圧縮**（Gzip, Snappy, Parquetなど）をしてから保存することも可能

## ユースケース

- **アプリやIoTデバイスのログ収集** → S3に保存 → Athena/Glueで分析
- **WebアクセスログをS3に集めて**、RedshiftやEMRで後処理
- **CloudWatch LogsをFirehose経由でS3にエクスポート**

## Firehoseの仕組み

### バッファリング処理

**データを受け取ると、バッファリング（一定サイズ or 一定時間）してまとめてから出力する**

- **例**: 1MB or 60秒 などの単位でまとめてS3に書き込む
- **注意**: 即座に1件ずつ出力するわけではない

## Kinesis サービスの比較

### Kinesis Data Streams

#### 特徴
- **本物のリアルタイム処理**（数百ミリ秒単位でデータ取得・処理可能）
- **自分でコンシューマ**（アプリやLambda）を書いて処理する必要あり

#### 用途
- **株価取引やゲームイベント**など、即時処理が必須なリアルタイム処理
- **Lambdaや自作アプリ**でイベントをその場で処理する

### Kinesis Data Firehose

#### 特徴
- **取り込み → バッファ → 保存をマネージドで処理**
- **遅延は数秒〜数分程度**
- **バッチ処理に近いが、ほぼリアルタイム風に利用可能**

#### 用途
- **ログ収集**（アプリログ、クリックストリーム、IoTセンサー）
- **S3に落としてAthena/Redshiftで分析**
- **遅延は数秒〜分で許容されるケース**

## パフォーマンス特性

**Data Firehoseはデータロードに最大60秒を要するため、ミリ秒単位の処理には不向き。ただし、データ変換とニアリアルタイムのデータ配信処理に優れている**

## Lambda変換機能

### 概要

**Kinesis Data Firehose には Lambda変換（データ変換機能）が組み込まれており、S3に書き込む前にLambdaでデータ整形や加工が可能**

### 仕組み

1. **Firehoseがデータを受信**
2. **オプションでLambdaを呼び出してデータ変換**
3. **変換済みデータをバッファリング** → S3やRedshiftなど出力先へ保存

### できること

- **JSON → Parquet/ORC への変換**（Athena/Redshiftでの分析向け）
- **CSVやログの正規化**（改行や区切り文字の調整）
- **不要なフィールドの削除、フィルタリング**
- **圧縮**（Gzip, Snappy など）との組み合わせ

## 実用例: Webアクセスログの整形

### 処理フロー

```
1. アプリから Firehose にログ送信
   ↓
2. Firehose が Lambda を呼ぶ
   ↓
3. Lambda 内で
   - ログJSONから必要なフィールドだけ抽出
   - タイムスタンプをISO8601形式に変換
   ↓
4. 整形済みデータを Firehose が S3 に書き込み
```

## Amazon Kinesis Data Firehose の変換機能

Firehose が持つ変換は大きく分けて2種類:

### 1. Record format conversion（レコード形式変換）
- 有効化すると、JSON → Parquet / ORC などに変換可能
- これは形式変換（シリアライズ変換）であり、フィールド加工やフィルタリングなどのカスタム変換はできない

### 2. Lambda transformation
- Firehose に AWS Lambda 関数を組み合わせることで、任意のロジックでデータを変換可能（マスキング、匿名化、計算処理など）
- **カスタム変換が必要なら Lambda 必須**

## Firehose の送信先

Firehose の配信先（destination）は S3 だけではない。実際には次がサポートされている:

- **Amazon S3**
- **Amazon Redshift**（※一旦S3に保存してCOPYロード）
- **Amazon OpenSearch Service**
- **Splunk**
- **カスタムHTTPエンドポイント**

**S3のみ**という認識は誤解で、Firehoseは他のサービスにも直接配信可能

---

## まとめ

### Firehose単体
- JSON→Parquet/ORC の形式変換は可能
- ただし独自ロジックによるデータ変換はできない

### Lambda連携
- 任意のカスタム変換が可能

### 送信先
- S3 だけでなく、Redshift, OpenSearch, Splunk, HTTP endpoint も対応

### 使い分け
- **単純なフォーマット変換** → Firehose単体
- **カスタム変換（ユーザー独自処理）** → Firehose + Lambda
- **配信先はS3に限らない**（他サービスもOK）