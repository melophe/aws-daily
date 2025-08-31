# DynamoDB Terraform Cheatsheet

このフォルダは DynamoDB 関連の Terraform リソースブロック最小例を `.tf` で個別に用意した索引です。

- 00-table-basic.tf: 最小のテーブル（PROVISIONED/オンデマンドは任意）
- 01-table-ttl-streams.tf: TTL と Streams を有効化
- 02-table-gsi.tf: GSI（グローバルセカンダリインデックス）の追加
- 03-autoscaling-read-write.tf: 読み書きの Application Auto Scaling（ターゲットトラッキング）
- 04-kinesis-streaming-destination.tf: Kinesis Data Streams へのストリーミング連携
- 05-table-item.tf: 単発のアイテム投入（小規模ユースケース向け）

注意:
- すべての `.tf` はボイラープレート（provider/terraform ブロック）を省略しています。必要に応じて追加してください。
- 値はプレースホルダ/変数のままです。実際の適用前に必ず置き換えてください。

