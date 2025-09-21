# Amazon CloudWatch Container Insights

## 概要

ECS・EKS・Kubernetes・Fargate 上で稼働するコンテナ化されたアプリケーションやインフラのパフォーマンスデータを自動収集・可視化する機能

コンテナやクラスタのリソース利用状況やログを、自動で CloudWatch に取り込み、ダッシュボードで監視できるサービス機能

---

## 主な機能

### メトリクス収集
- CPU 使用率、メモリ使用量、ディスク I/O、ネットワーク通信量
- Pod、Node、Service、Cluster 単位で収集

### ログの集中管理
- コンテナログや Kubernetes システムコンポーネントのログを CloudWatch Logs に保存

### 自動ダッシュボード生成
- EKS / ECS クラスターごとにパフォーマンスの可視化ダッシュボードを自動作成
- 問題のあるコンテナや Pod を一目で把握可能

### アラーム連携
- CloudWatch Alarms と統合し、リソース異常（例：CPU > 80%）を通知可能

### 統合トラブルシューティング
- メトリクス + ログを組み合わせて、アプリやインフラの問題調査が効率化

---

## 利用イメージ

EKS クラスタで Container Insights を有効化すると：

1. クラスタ内の Node / Pod / Container / Service ごとの利用状況が自動収集
2. CloudWatch コンソールに「Container Insights」ダッシュボードが生成

### 確認できる内容
- どの Pod がメモリ不足なのか
- どの Node が CPU ボトルネックになっているか
- ネットワークが遅いサービスはどれか

これらを一目で確認可能

---

## まとめ

CloudWatch Container Insights = コンテナ監視を自動化する仕組み

### 特徴
- Kubernetes/ECS を意識せず、AWS 管理コンソールから簡単に可視化・アラート設定が可能
- アプリのパフォーマンス把握を事前に整える仕組みとして最適