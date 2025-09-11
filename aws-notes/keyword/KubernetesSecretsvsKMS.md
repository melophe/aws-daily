# Kubernetes Secrets vs AWS KMS

| 項目 | Kubernetes Secrets | AWS KMS |
|------|-------------------|---------|
| **概要** | Kubernetes標準の機能。クラスター内のetcdに格納される | AWSのマネージド暗号化サービス。暗号鍵の作成・管理・利用を提供 |
| **役割** | アプリに必要なパスワードやAPIキーなどをPodに安全に注入 | データの暗号化・復号を実行。Secrets自体は保持しない |
| **デフォルト状態** | Base64エンコードのみ（暗号化ではない）。<br>そのままだとセキュリティ的に弱い | KMSキーは安全に保管され、アクセス制御・ローテーション・CloudTrailログに対応 |
| **EKSでの関係** | EKS上で利用可能。<br>「Secrets暗号化」を有効化すれば、etcd内のSecretsをKMSで暗号化可能 | EKSと連携してSecrets暗号化を担当。<br>「Secretsを直接代替する」ものではなく「Secretsを守る」もの |
| **利点** | ・Kubernetes標準なので移植性が高い<br>・Podからすぐ利用可能 | ・強力な暗号化<br>・鍵の管理・ローテーション・IAM制御が可能 |
| **欠点** | ・デフォルトは暗号化されていない<br>・etcdが盗まれると漏洩リスク | ・それ単体ではシークレットを保存する機能はない<br>・必ずSecretsやSecrets Managerなどと組み合わせる必要がある |