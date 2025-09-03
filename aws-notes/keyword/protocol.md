# SFTP プロトコル

## 1. 定義

**SFTP (SSH File Transfer Protocol / Secure File Transfer Protocol)** は、SSH（Secure Shell）の仕組みを使ってファイル転送やリモートファイル操作を行うプロトコル。

> 名前に「FTP」とつくが、従来のFTPとは別物。

### プロトコル比較

- **FTP** = 古くからあるファイル転送プロトコル（暗号化なし）
- **FTPS** = FTPにTLS/SSLを追加して暗号化
- **SFTP** = SSHをベースにした安全なファイル転送プロトコル