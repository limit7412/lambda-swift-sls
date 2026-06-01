# lambda-swift-sls

自作サーバーレスswift with serverless framework

provided.al2 ランタイム + zip パッケージ構成。
`sls deploy` 時に serverless-plugin-scripts のフックが Docker
(swift:amazonlinux2) で静的バイナリ `bootstrap` をビルドして同梱する。

> Docker(ECR イメージ)版から zip 版へ移行済み。旧構成は
> serverless.yml / Dockerfile にコメントアウトで残してある。

```bash
# プラグイン(serverless-plugin-scripts)のインストール
$ npm install

# deploy
$ sls deploy --stage <stage_name>
```
