# AWS DMS (Database Migration Service)

## 概要

フルマネージドな データベース移行サービス

ソースDB → ターゲットDB にデータをレプリケート

最小限のダウンタイムで移行可能（CDC: Change Data Capture を使って差分同期）

---

## 特徴

### 対応範囲が広い

#### 同種DB間移行（homogeneous migration）
例: Oracle → Oracle, MySQL → MySQL

#### 異種DB間移行（heterogeneous migration）
例: Oracle → Aurora, SQL Server → PostgreSQL

### 移行だけじゃなく継続レプリケーションも可能

データウェアハウスや分析基盤にリアルタイム転送

---

## スキーマ変換

RDBMS間で異種移行する場合は AWS Schema Conversion Tool (SCT) を使ってスキーマやSQLを変換

---

## 代表的なユースケース

- オンプレDB → AWS RDS/Aurora への移行
- RDS MySQL → Aurora MySQL への移行
- Oracle → Amazon Redshift へのデータ移行（DWH統合）
- 継続的にオンプレDBの変更を S3 にレプリケートして分析に利用

---

## まとめ

- AWS DMS = データベース移行サービス
- 最小ダウンタイムで DB 移行可能
- 同種DBも異種DBもOK
- スキーマ変換には AWS SCT を併用