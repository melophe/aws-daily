DataSync ができること

オンプレミス環境（HDFS含む）と AWSのストレージサービス の間でデータ転送

HDFS ⇔ Amazon S3

HDFS ⇔ Amazon EFS

HDFS ⇔ Amazon FSx

差分コピー、圧縮、並列転送で効率的にデータを動かせる

👉 つまり DataSync の「相手」は ストレージサービス に限られる。

🔹 DataSync ができないこと

直接 EMR クラスターに接続することは不可

EMR は「計算基盤」なので、ストレージのように DataSync の転送先に指定できない