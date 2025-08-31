Storage Gateway とは

オンプレとAWSクラウドをつなぐ「ハイブリッドストレージサービス」

3つのモードがある：

File Gateway

Volume Gateway

Tape Gateway

Amazon S3 File Gateway の特徴

オンプレに仮想アプライアンスを配置して利用（VMware/Hyper-V/EC2で動かせる）

オンプレのアプリやデバイスに NFS または SMB プロトコルでファイル共有を提供

そのファイルは自動的に Amazon S3 にアップロードされる

クラウド上では S3オブジェクトとして扱える

キャッシュ機能があるので最近使ったデータはオンプレ側で高速アクセス可能