CREATE TABLE "todos" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "title" varchar NOT NULL
);

INSERT INTO "todos" ("title") VALUES
('foo'),
('bar');

-- users テーブルは SQL インジェクションのデモ用
CREATE TABLE "users" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "name" varchar NOT NULL
);

INSERT INTO "users" ("name") VALUES
('Alice'),
('Bob');
