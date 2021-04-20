# web-demonstration

![badge.svg](https://github.com/next-skill/web-demonstration/workflows/main/badge.svg)

![badge.svg](https://github.com/next-skill/web-demonstration/workflows/schedule/badge.svg)

Web の仕組みや Web アプリの仕組みについてのデモンストレーション用コードです。

※ あくまでデモンストレーション用のコードです。セキュリティ上の問題が多数存在するため、実用しないでください。

## 依存関係

* Ruby
* Node.js
* Yarn
* Docker
* Docker Compose

※ Ruby、Node.js、Yarn のバージョンの指定には asdf を使用しています

## ディレクトリ構成

```
.
├── socket-web-server ... socket を使った Web サーバ
├── socket-web-application ... socket を使った Web アプリ
├── rack-application ... Rack を使った Web アプリ
├── rack-application-with-controller ... Controller を作成したサンプルアプリ
├── rack-application-with-ajax ... Ajax のサンプルアプリ
└── rails-generated-project ... Rails の自動生成プロジェクト
```

## デモンストレーション手順

### PostgreSQL のコンテナ起動

```shell
docker-compose up -d
```

### socket-web-server

```shell
cd socket-web-server
./server.rb
./server_v2.rb
```

ブラウザで http://localhost:8000 にアクセス

### socket-web-application

```shell
cd socket-web-application
./server.rb
```

ブラウザで http://localhost:8000/todos にアクセス

### rack-application

```shell
cd rack-application
bundle exec rackup config.ru
```

ブラウザで http://localhost:9292/todos にアクセス

curl の場合は以下のコマンドでアクセス可能

```shell
curl -v localhost:9292/todos
curl -v -L -d 'title=mytodo' localhost:9292/todos
```

### rack-application-with-controller

```shell
cd rack-application-with-controller
bundle exec rackup config.ru
```

ブラウザで http://localhost:9292/todos にアクセス

### rack-application-with-ajax

```shell
cd rack-application-with-ajax
bundle exec rackup config.ru
```

ブラウザで http://localhost:9292/todos.html にアクセス

### rails-generated-project

```shell
cd rails-generated-project
rails db:migrate
rails s
```

ブラウザで http://localhost:3000/todos にアクセス
