# web-demonstration

Web の仕組みや Web アプリの仕組みについてのデモンストレーション用コードです。

※ あくまでデモンストレーション用のコードです。セキュリティ上の問題が多数存在するため、実用しないでください。

## 依存関係

* Ruby (バージョンの指定には asdf を使用しています)
* Docker
* Docker Compose

## ディレクトリ構成

```
.
├── socket-web-server ... socket を使った Web サーバ
├── socket-web-application ... socket を使った Web アプリ
├── rack-application ... Rack を使った Web アプリ
├── rack-application-with-controller ... Controller を作成したサンプルアプリ
├── rack-application-with-ajax ... Ajax のサンプルアプリ
└── rails-initial-project ... Rails の自動生成プロジェクト
```

## デモンストレーション手順

### PostgreSQL セットアップ

PostgreSQL のコンテナを起動

```shell
docker-compose up -d
```

`docker ps` でコンテナ ID を確認し、SQL を流す

```shell
docker exec -it <container_id> sh
psql -U myuser -d mydb
```

実行する SQL は以下の通り

```sql
CREATE TABLE "todos" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "title" varchar NOT NULL
);

INSERT INTO "todos" ("title") VALUES
('foo'),
('bar');
```

### socket-web-server

```shell
cd socket-web-server
./server.rb
./server_v2.rb
```

ブラウザで http://localhost:8000 にアクセス

### rails-initial-project

```shell
cd rails-initial-project
rails db:migrate
rails s
```

ブラウザで http://localhost:3000/todos にアクセス

### socket-web-application

```shell
cd socket-web-appliction
./server.rb
```

ブラウザで http://localhost:8000/todos にアクセス

### rack-appliction

```shell
cd rack-appliction
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
