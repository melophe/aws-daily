# Provisioned + Auto Scaling

プロビジョンドキャパシティで開始し、Application Auto Scaling で RCU/WCU を自動調整する最小構成です。

構成要素:
- DynamoDB テーブル（PROVISIONED）
- ルートキー: `pk`/`sk`
- 暗号化: 有効
- Auto Scaling ポリシー（Read/Write それぞれ TargetTracking）

入力変数:
- `table_name`（例: `app`）
- `read_min` / `read_max`（既定: 1 / 100）
- `write_min` / `write_max`（既定: 1 / 100）

前提:
- AWS のリージョン/認証はローカルの既定設定（環境変数やプロファイル）を使用します。
