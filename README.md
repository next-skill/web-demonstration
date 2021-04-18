# web-demonstration

Web の仕組みや Web アプリの仕組みについてのデモンストレーション用コードです。

※ デモンストレーション用のコードです。セキュリティ上の問題が多数存在するため、実用しないでください。

## 依存関係

* Ruby (バージョンの指定には asdf を使用しています)
* Docker
* Docker Compose

## デモンストレーション手順

## PostgreSQL 起動

```console
docker-compose up -d
```

psql -U myuser -d mydb

```sql
CREATE TABLE "todos" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "title" varchar NOT NULL
);

INSERT INTO "todos" ("title") VALUES
('foo'),
('bar');
```

### web-server

```console
cd web-server
./server.rb
./server_v2.rb
```

ブラウザで http://localhost:8000 にアクセス

### rails-initial-project

```console
cd rails-initial-project
rails s
```

ブラウザで http://localhost:3000 にアクセス

### socket-web-application

```console
cd socket-web-appliction
./server.rb
```

### rack-appliction

```console
cd rack-appliction
bundle exec rackup config.ru
```

curl -v localhost:9292/todos
curl -v -L -d 'title=mytodo' localhost:9292/todos

### my-framework-application

```console
cd my-framework-application
bundle exec rackup config.ru
```

### my-framework-ajax-application

```console
cd my-framework-ajax-application
bundle exec rackup config.ru
```
