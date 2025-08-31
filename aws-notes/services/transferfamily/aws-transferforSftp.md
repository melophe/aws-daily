# AWS Transfer Family

**AWS Transfer Family**（その中の1機能が「Transfer for SFTP」）

## 概要

**SFTP（Secure File Transfer Protocol）をフルマネージドで提供するサービス。**

自分でSFTPサーバーを立てなくても、AWSがSFTPエンドポイントを提供してくれる。

### 主要な機能

- **データ保存先**: Amazon S3 または Amazon EFS に直接連携
- **ユーザー認証**: IAM, Active Directory, カスタム認証（Lambda） を利用可能
- **特徴**: スケーラブルで高可用性、サーバー管理不要

## サポートするプロトコル

AWS Transfer Family
→ AWS が提供する「ファイル転送プロトコルをマネージドで使えるサービス群」の総称

その中の構成員（ファミリーの一員）が以下：

AWS Transfer for SFTP（SSHベースの安全なファイル転送）

AWS Transfer for FTPS（FTP over SSL/TLS）

AWS Transfer for FTP（通常のFTP、レガシー互換）

AWS Transfer for AS2（EDIで使う業界標準プロトコル）

### AWS Transfer for SFTP
- **プロトコル**: Secure File Transfer Protocol (SFTP, SSHベース)
- **利用業界**: 金融・医療などセキュリティ要件の高い業界でよく使われる

### AWS Transfer for FTPS
- **プロトコル**: File Transfer Protocol over SSL/TLS
- **特徴**: FTPのセキュア版

### AWS Transfer for FTP
- **プロトコル**: レガシー互換用の通常FTP（非暗号化、あまり推奨されない）

### AWS Transfer for AS2
- **プロトコル**: Applicability Statement 2
- **用途**: EDI（電子データ交換）業界標準のファイル転送プロトコル

## 主な特徴

- **マネージドサーバー**: SFTP/FTPS/FTP/AS2サーバー → サーバー構築・保守不要
- **ストレージ統合**: S3/EFSに直結 → 転送したファイルは即座にAWSのストレージに保存可能
- **認証統合**: IAM, AD, LDAP, Lambdaベース認証
- **運用コスト削減**: パッチ、SSL証明書更新、可用性設計はAWSが担当

## ユースケース

- 取引先との安全なファイル受け渡し（金融・医療・小売業など）
- 既存の SFTP クライアントから AWS 環境へシームレスにデータ転送
- データレイク基盤へのデータ取り込み（S3に集約してAthena/Glue分析）
- EDIシステムのAS2データ連携