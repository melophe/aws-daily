# DNS レコード

## 基本的なDNSレコード

### A レコード
- **機能**: ホスト名（例: example.com）を **IPv4アドレス** に解決するためのレコード
- **例**: `example.com.   IN   A    192.0.2.1`

### AAAA レコード
- **機能**: ホスト名を **IPv6アドレス** に解決するためのレコード
- **名前の由来**: 「A」が4つあるのは、IPv6アドレスが128ビット（= 32bit × 4）であることに由来
- **例**: `example.com.   IN   AAAA   2001:db8::1`

#### IPv4/IPv6 の併用
- **IPv6 対応クライアント**: AAAA レコードを使って接続
- **IPv6 非対応クライアント**: A レコードを参照して IPv4 で接続
- **両方登録**: クライアントの環境に応じて適切な方が自動選択される

## AWS Route 53 の A レコード

### 標準 A レコード
- **機能**: DNS の基本的なレコードで、ドメイン名 → IPv4 アドレス を解決
- **例**: `example.com.   IN   A    192.0.2.1`

#### AWS リソースでの制限
- **問題**: AWS のリソース（CloudFront, ALB, S3 静的サイトなど）は **固定 IP を持っていない**
- **結果**: 通常の A レコードには向かない

### Alias レコード

#### 概要
- **定義**: Route 53 独自拡張の A レコード
- **特徴**: 「IP アドレス」ではなく「AWS リソースのドメイン名」を直接指定可能

#### 設定例
```
cdn.example.com.   IN   A (Alias)   d123456abcdef8.cloudfront.net
```

#### 動作原理
- Route 53 が内部的に `d123456abcdef8.cloudfront.net` の最新 IP アドレス群を解決
- ユーザーに正しい IP アドレスを返す

## Alias レコードのメリット

### 1. 固定 IP 不要
- CloudFront や ALB は IP が動的に変わる
- Alias レコードなら常に正しく解決される

### 2. ルートドメインでも使用可能
- **CNAME の制限**: 通常の CNAME レコードは `example.com` に使用不可（仕様上、ルートドメインに配置不可）
- **Alias の利点**: Alias A レコードなら `example.com` を CloudFront に直接割り当て可能

### 3. 追加料金なし
- **CNAME**: DNS クエリで外部参照が発生
- **Alias**: AWS 内で解決されるため **クエリ料金がかからない**

## CloudFront との連携

### CloudFront ドメイン名
- CloudFront ディストリビューション作成時に専用ドメイン名が自動割り当て
- **例**: `d123456abcdef8.cloudfront.net`

### Route 53 での設定
1. **A レコード（Alias）** で CloudFront のドメイン名を指定
2. **Route 53 が自動解決** してクライアントに正しい IP アドレスを返す