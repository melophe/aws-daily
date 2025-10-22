AWS Schema Conversion Tool (SCT)とは

オンプレミスや他クラウド上のデータベーススキーマを、AWS上のデータベースに変換するためのデスクトップアプリケーション

例: Oracle → Amazon Aurora MySQL、SQL Server → Amazon RDS PostgreSQL

「スキーマ」とは、テーブル定義・ビュー・ストアドプロシージャ・トリガー・関数などの構造部分

 データそのもの（レコード）は DMS (Database Migration Service) が担当
 スキーマ（構造）の変換は SCT が担当

主な機能

異種DB間のスキーマ変換

Oracle → Aurora PostgreSQL / MySQL

SQL Server → Amazon RDS

など、エンジンが違うDB間の移行をサポート

コード変換の支援

ストアドプロシージャ、トリガー、関数をターゲットDB用に変換

変換できない部分は「手動修正が必要」とレポートしてくれる

レポート作成

「変換できる部分」「できない部分」を一覧化したアセスメントレポートを出せる

移行作業の工数見積もりに役立つ

DMSとの連携

SCTでスキーマ変換

DMSで実際のデータを複製／移行

使う場面

異種データベース移行（heterogeneous migration）

例: Oracle → Aurora PostgreSQL

同種DB（homogeneous migration, 例: Oracle → Oracle）はDMSだけで十分

AWS Schema Conversion Tool (SCT) = データベース移行時にスキーマを変換するツール。

スキーマ変換 → SCT

データ移行 → DMS

異種DB移行に必須