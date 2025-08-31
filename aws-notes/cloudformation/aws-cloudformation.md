AWS CloudFormationテンプレートを用いて2つのAZにアプリケーションに必要なインフラストラクチャーを自動的にデプロイすることは可能ですが、AWS CloudFormationテンプレートだけではアプリケーションのデプロイと管理ができません。

実際はどうするか

インフラ: CloudFormation

アプリケーションデプロイ: 他のサービスを併用

CodeDeploy

Elastic Beanstalk

CodePipeline + CodeBuild

ECS/EKS のデプロイ機能