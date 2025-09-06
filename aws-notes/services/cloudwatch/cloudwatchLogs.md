# AWS CloudWatch Logs

## 概要

EC2・Lambda・ECS・オンプレなどから送られたログを**集めて保存・検索・分析・可視化できるサービス**

AWS のログ収集・集中管理システム

## できること

### ログの収集

| 送信元 | 送信方法 |
|--------|----------|
| **EC2** | CloudWatch エージェント経由 |
| **Lambda** | 標準出力（console.log や print）が自動で送信 |
| **VPC Flow Logs、API Gateway、RDS** | 一部サービスは自動で送信 |

### ログの保存
- デフォルトは無期限保存（任意に保持期間を設定可能）

### ログの検索
- **CloudWatch Logs Insights** で SQL っぽいクエリで検索・集計できる

### メトリクス化
- 「このログに "ERROR" が出たらメトリクスを上げる」といった設定が可能

### アラート連携
- CloudWatch Alarm と組み合わせて「ログに ERROR が出たら通知」などができる

## 構成要素

### Log Group（ロググループ）
ログの大きな入れ物

**例**: `/aws/ec2/my-app`

### Log Stream（ログストリーム）
1つのロググループの中で、インスタンスやプロセスごとに分かれる単位

**例**: `i-1234567890abcdef のログ`

### Events（ログイベント）
実際のログ行（タイムスタンプ＋メッセージ）

## EC2 の OS ログを CloudWatch Logs に送る場合

### 設定手順
1. **EC2 内に CloudWatch エージェント**をインストール
2. **設定ファイルで `/var/log/messages` を CloudWatch Logs に送るように設定**
3. **CloudWatch コンソールで Log Group `/ec2/var/log/messages`** が作成される
4. **中に Log Stream（インスタンスごと）**ができて、リアルタイムで閲覧可能

## まとめ

- **CloudWatch Logs** = AWS のログ集中管理サービス
- EC2・Lambda・RDS などいろんなソースから集められる
- 保存・検索・可視化・アラートができる
- **重要**: EC2 の OS ログは勝手に送られない → CloudWatch エージェントが必要

## CloudWatch Logs Insights

### 概要
CloudWatch Logs 上のログをクエリできるサービス

### 特徴
- **ほぼリアルタイム**にログを検索できる
- **短期間**（直近のエラー調査など）に便利
- SQL ライクだが Athena より機能は軽量