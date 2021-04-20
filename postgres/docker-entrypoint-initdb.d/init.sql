CREATE TABLE "todos" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "title" varchar NOT NULL
);

INSERT INTO "todos" ("title") VALUES
('foo'),
('bar');
