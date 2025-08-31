# On-Demand Table (Minimal)

最小のオンデマンド構成（暗号化/TTL/Streams 有効）。

構成要素:
- DynamoDB テーブル（PAY_PER_REQUEST）
- ルートキー: `pk`/`sk`
- 暗号化: 有効
- TTL: `ttl` 属性
- Streams: NEW_AND_OLD_IMAGES

入力変数:
- `table_name`（例: `app`）

前提:
- AWS のリージョン/認証はローカルの既定設定（環境変数やプロファイル）を使用します。
