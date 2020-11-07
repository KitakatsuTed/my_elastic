# 環境構築
- Ruby 2.6.3
- PostgreSQL 9.6.9
- elasticsearch 6.8.8
- Rails 6.0.2.2

## 手順
1. レポジトリ(https://github.com/KitakatsuTed/my_elastic.git)をクローン

`git clone https://github.com/KitakatsuTed/my_elastic.git`

2. Ruby 2.6.3 のインストール
3. gemをインストールする

`bundle install`

4. .env.sampleをそのまま`.env`にコピペする(ポートの干渉等あれば調整をお願いします)
5. ルートディレクトリで下記を実行して、docker-composeを立ち上げる

`docker-compose up`

6. `yarn install --check-files`でyarnをインストール

7. `bin/rails db:create` でデータベースを作成する
8. `bin/rails db:migrate` でマイグレートを実行
9. `bin/rake data:setup` でelasticsearchにインデックスを作成する
10. `bin/rails s`でサービスとsidekiqを立ち上げ、`localhost:3000`がエラーなくひらけたら完了

### 簡単な使い方
https://ted-tech.hateblo.jp/entry/2020/08/11/182612

