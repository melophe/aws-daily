# AWS IAM Identity Center

## 概要

AWSアカウントやアプリケーションへのアクセスを一元的に管理するサービス

企業のユーザーは1回のログインで、複数のAWSアカウントやアプリケーションにアクセス可能

> 注: 2022年にAWS SSOから名称変更されて、より拡張された

## 主な機能

### シングルサインオン (SSO)
- 社員は一度ログインするだけで、複数のAWSアカウントやクラウドアプリにアクセス可能
- Okta, Azure AD, Google Workspace など外部IdP（Identity Provider）とも連携可能

### アクセス管理
- IAMロールやポリシーを直接触らずに、ユーザーやグループごとに「どのAWSアカウントに、どの権限で入れるか」を管理可能
- 権限セット (Permission Set) を使って一括管理

### アプリ連携
- SAML 2.0 対応のSaaSアプリケーション（Salesforce, Office 365, GitHub Enterprise など）とも統合可能

### セキュリティ強化
- MFA (多要素認証) を組み合わせて安全にログイン
- 監査ログをCloudTrailに記録可能

## 利用シーン

### 管理者視点
IAM Identity Center上で以下のような設定が可能：
- 営業部の人はこのAWSアカウントには読み取り権限だけ
- 開発部は開発用アカウントに管理者権限を持たせる

### ユーザー視点
1. 社員はIAM Identity Centerのポータルにログイン
2. 自分が利用できるAWSアカウントやアプリが一覧表示される
3. クリックすればシームレスにログイン

---

## まとめ

IAM Identity Center = AWSアカウントやアプリケーションへのSSOと権限管理を一元化するサービス

### 特徴
- 旧AWS SSOの進化版
- ユーザー: 1回のログインで複数AWSアカウントやSaaSにアクセス可能
- 管理者: 権限セットでユーザー権限を一元管理

---

## SAML 2.0 とは

### 概要
Security Assertion Markup Language (SAML) version 2.0 の略

認証と認可の情報を交換するためのXMLベースの標準プロトコル

主にシングルサインオン (SSO) を実現するために使われる

> 簡単に言うと: 「ユーザーが誰で、どんな権限を持っているか」を安全にやり取りするための仕組み

### 関係者の役割

#### IdP（Identity Provider, アイデンティティプロバイダー）
ユーザーを認証する側

例: Okta, Azure AD, Google Workspace, IAM Identity Center

#### SP（Service Provider, サービスプロバイダー）
認証されたユーザーを受け入れるサービス側

例: AWS, Salesforce, GitHub Enterprise, Box

### SAML 2.0 の動き（SSOの流れ）

1. ユーザーがSP（例：AWSコンソール）にアクセス
2. SPは「この人の認証はIdPに任せる」と判断し、IdPにリダイレクト
3. ユーザーがIdP（例：Azure AD）でログイン
4. IdPは「この人は誰か」「どんな属性を持っているか（権限など）」をSAML Assertion（XMLの認証トークン）に詰めてSPに返す
5. SPはそのトークンを確認して、ユーザーをログイン済みとして扱う

> これでユーザーはIdPに一度ログインするだけで、複数のSPにシングルサインオンできる

### IAM Identity Centerとの関係

- IAM Identity CenterはIdPとして振る舞い、SAML 2.0を使ってAWSアカウントやアプリにアクセスを渡す
- 逆にAzure ADなど外部IdPを利用して、AWSをSPにすることも可能

---

## SAML 2.0 の本質まとめ

- SAML 2.0 はプロトコル（ルール）
- IdPがユーザー認証を代行し、他サービス（SP）のログインを楽にする仕組み
- だからSSO（シングルサインオン）が可能になる

---

## IAM Identity Center の2つの使い方

### 1. 自分自身がIdP（アイデンティティプロバイダー）になる場合
- 社員のアカウントをIAM Identity Centerで管理して、そこからAWSやSaaSへSSO

### 2. 外部IdPを使う場合
- IAM Identity Centerは「SP（サービスプロバイダー）」として動作し、外部IdP（Azure AD, Okta, Google Workspace など）に認証を任せる

> 特徴: 外部IdPを使ってSSOもできるし、自分自身がIdPとしても動ける

---

## IDフェデレーションとは？

### 概要
複数のシステムやサービス間で、同じユーザー認証基盤（IdP）を使ってログインできる仕組み

ユーザーは別々のアカウントを作らずに、1つのIDで複数サービスを利用可能

> 簡単に言うと: 「よそで認証したユーザーを信頼して、そのまま使わせてあげる仕組み」

### 関係者

#### IdP（Identity Provider）
認証を担当する側

例: Okta, Azure AD, Google Workspace, IAM Identity Center

#### SP（Service Provider）
サービスを提供する側（認証を委ねる側）

例: AWS, Salesforce, Box, GitHub Enterprise

### IDフェデレーションの認証フロー

#### 1. ユーザーがAWSにアクセス（SP）
ユーザーがAWSコンソールにアクセスを試行

#### 2. AWSが認証を委譲
AWSは「この人の認証はウチじゃなくてIdPに任せる」と判断

#### 3. IdPでの認証
ユーザーはOkta / Azure AD（IdP）でログイン

#### 4. 認証情報の受け渡し
IdPが「この人は正しいユーザー」と認証情報をAWSに渡す

#### 5. ログイン完了
AWS側ではユーザーをログイン済みとして扱う

> 結果: これで「IDの連携（フェデレーション）」が成立

---

## AWSにおけるIDフェデレーションの利用例

### IAM Identity Center
- 外部IdP（Azure AD, Oktaなど）と連携してSSOを実現

### IAMロール + SAMLフェデレーション
- 既存の社内IdPで認証 → 一時的にIAMロールを付与してAWSにアクセス

### Cognitoフェデレーション
- GoogleやFacebookなどの外部IDでログイン → アプリに入れる

## IDフェデレーションのメリット

### ユーザー視点
- IDを一元管理できる - 複数のパスワードを覚える必要がない

### 管理者視点
- 認証処理を外部に任せられる - 独自の認証システム構築が不要

### 利用シーン
- AWSでもIAM Identity CenterやCognitoを通じてよく使われている

---

## サードパーティ製 SAML 2.0 IdP

### 概要
AWSが直接提供する認証基盤ではなく、外部ベンダーが提供するIdPサービス

### 主要なサードパーティIdP

#### Okta
- エンタープライズ向けSSO・IDプロバイダー

#### Azure Active Directory (Entra ID)
- Microsoft提供のクラウドベース認証基盤

#### Google Workspace
- Google提供のビジネス向け認証サービス

#### OneLogin
- クラウドベースのIDアクセス管理

#### Ping Identity
- エンタープライズ向けデジタルID管理

> 特徴: これらはすべてSAML 2.0に対応したIdPとして利用可能

---

## Active Directory とフェデレーション

### ADの役割

Active Directory (オンプレADやAWS Managed Microsoft AD) は IdPの代わり に使える

つまり、ユーザーは会社のADにログインして、その資格情報でAWSやSaaSにシングルサインオンできる

### 連携パターン

#### AD FS (Active Directory Federation Services) を使う
- オンプレADとSAML IdPのブリッジになる
- AWS Identity CenterとSAML連携してフェデレーション

#### AWS Managed Microsoft AD を使う
- AWS内にマネージドなADを立ててIdPとして機能させる

#### AD Connector を使う
- オンプレADに直接つなぐプロキシ
- ユーザー認証はオンプレADに流して、Identity CenterはSAML連携でSSO

### Identity Centerとの関係

- Identity Center自体は「認証を外部IdPに委任できる」
- その外部IdPとして AD / AD FS / Azure AD / Okta を設定可能
- 設定後はユーザーが自分のADアカウントでログイン → フェデレーションを通じて AWS やアプリにSSO

---

## まとめ

IdPはOktaやAzure ADだけじゃなく、Active Directory (AD) でもOK

その場合、ADをSAML IdPとして構成する必要がある（AD FS経由など）

Identity Centerに渡せば、AWSアカウントやSaaSにSSOができる