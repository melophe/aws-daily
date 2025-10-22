# AWS Site-to-Site VPN

## 概要

オンプレミス → AWS をインターネット経由で暗号化（IPSec VPN）して接続するサービス

## 特徴

### メリット
- **すぐ使える**（数時間〜1日で設定可能）
- **安価で導入が簡単**

### デメリット・制約
- インターネット経由なので、レイテンシや帯域はベストエフォート

## 主な利用シーン

### 暫定手段として
- 本番前のテスト接続
- Direct Connect 開通までの暫定手段

### 軽量な通信向け
- それほど大容量通信が発生しないシステム

## Direct Connect との比較

| 項目 | Site-to-Site VPN | Direct Connect |
|------|------------------|----------------|
| **導入速度** | 数時間〜1日 | 1〜3か月 |
| **コスト** | 安価 | 高め |
| **通信品質** | ベストエフォート | 安定・高品質 |
| **用途** | テスト・軽量通信 | 本番・大容量通信 |

Site-to-Site VPN を張るときには CGW（Customer Gateway）が必須

Site-to-Site VPNは「オンプレ側」と「AWS側」で VPNトンネルの両端を用意 する必要がある

オンプレ側の終端 → Customer Gateway (CGW)

AWS側の終端 → Virtual Private Gateway (VGW) または Transit Gateway (TGW)

つまりCGW が無いと「オンプレのどこにVPNをつなげるのか」が決まらず、トンネルを張れない。

必要なもの

オンプレ側

固定の パブリックIPアドレス（ルータやVPN機器に割り当てられる）

VPN機能を持ったルータ／ファイアウォール／サーバ（例: Cisco, Fortigate, strongSwan入りLinux）

AWS側

VGW（1つのVPCと接続する場合）

TGW（複数VPCやオンプレ接続をまとめたい場合）

[On-Premises Network]
        │
  [Customer Gateway]  ← オンプレ側VPN終端（必須）
        │
   (IPSec VPN Tunnel)
        │
  [Virtual Private Gateway] or [Transit Gateway]  ← AWS側終端
        │
       VPC

Site-to-Site VPN = オンプレとAWSを結ぶIPSecトンネル

CGWは必須（オンプレ側のVPN終端をAWSに登録するためのリソース）

もしオンプレ側にVPNルータが無い場合 → Linuxサーバに strongSwan を入れてCGWとして動かすことも可能

## CGW が必要になるケース

### AWS Site-to-Site VPN
**これは必須**

オンプレ側のVPN終端（ルータ/ファイアウォール/Linux VPNサーバ）をCGWとしてAWSに登録する

### AWS Transit Gateway + VPN接続
Transit Gatewayを使うときも、オンプレとVPNでつなぐならCGWが必要

（TGWのVPNアタッチメントの相手としてCGWが出てくる）

## CGW が不要なケース

### AWS Direct Connect
物理専用線で接続するのでCGWは不要

代わりに「DX Gateway」や「VGW/TGW」と接続する

### Client VPN
各ユーザー端末（PC）が直接AWSのClient VPNエンドポイントに接続する

ここではオンプレのVPNルータは不要なのでCGWは関係ない

### VPC Peering
VPC間の通信だけなのでオンプレを介さない → CGW不要

### AWS PrivateLink / VPCエンドポイント
AWSサービスや他のVPCとプライベート接続する仕組み → CGW不要

## まとめ
- **CGW必須** → オンプレとAWSを Site-to-Site VPN / TGW VPN でつなぐ場合
- **不要** → Direct Connect、Client VPN、VPC Peering、PrivateLink など