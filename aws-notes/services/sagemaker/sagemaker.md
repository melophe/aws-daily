# Amazon SageMaker サービス概要

## 主なコンポーネント／サービス

### 1. SageMaker Studio
- ブラウザベースの統合開発環境（IDE）
- データサイエンティスト向け

### 2. SageMaker Canvas
- ノーコードで予測モデルを作れるGUI
- ビジネスユーザー向け

### 3. SageMaker Autopilot
- データを投入するだけで自動でアルゴリズム選択・前処理・学習・チューニングまで実行するAutoML機能

### 4. SageMaker JumpStart
- 事前構築されたモデル・ソリューションテンプレートを簡単に利用可能
- Hugging FaceのモデルやVision/NLP系の学習済みモデルをすぐにデプロイ可能

### 5. SageMaker Data Wrangler
- データ前処理ツール
- GUIで特徴量エンジニアリングや欠損値処理などを実行可能

### 6. SageMaker Feature Store
- 機械学習に使う特徴量（features）を保存・再利用する専用ストア
- オンライン推論用（低レイテンシー）とオフライン学習用（バッチ処理）をサポート

### 7. SageMaker Training / Inference
- 分散トレーニングや推論エンドポイントをスケーラブルに実行できる基盤サービス

### 8. SageMaker Model Monitor
- デプロイしたモデルを監視
- データドリフトや精度低下を検知

### 9. SageMaker Pipelines
- 機械学習のMLOpsパイプライン構築用サービス
- CI/CDパイプラインのようにモデルの再学習やデプロイを自動化

### 10. SageMaker Clarify
- バイアス検出と説明可能性（Explainability）の機能
- 公平性や透明性が求められるユースケースで利用

### 11. SageMaker Ground Truth
- データラベリングサービス
- 人手や自動ラベリングを組み合わせて学習データを効率的に準備