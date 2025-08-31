# DynamoDB Terraform Examples

このフォルダは DynamoDB の代表的な構成を最小の `.tf` で示すサンプル集です。
各サブフォルダは独立した最小プロジェクトです。

- `on-demand/`: オンデマンド課金 + 暗号化 + TTL + Streams（最小構成）
- `provisioned-autoscaling/`: プロビジョンド + Application Auto Scaling による RCU/WCU 自動調整

メモ:
- 変数は `-var` または `terraform.tfvars` で指定します。
- 実際に展開する場合はコストが発生します（リソースの削除も忘れずに）。
