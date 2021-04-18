require 'json'

class TodosController
  def index(request)
    # DB から TODO 一覧を取得
    conn = PG::Connection.new(
      host: 'localhost',
      port: 5432,
      dbname: 'mydb',
      user: 'myuser',
      password: 'mypassword'
    )

    sql = 'SELECT id, title FROM todos'
    puts "[sql] #{sql}"

    result = conn.exec(sql)
    conn&.close

    # 取得したデータから JSON を生成
    todos = result.map do |record|
      {
        'id' => record['id'],
        'title' => record['title']
      }
    end

    response_body = {
      'todos' => todos
    }.to_json

    header = {
      'Content-Type' => 'application/json'
    }
    Rack::Response.new(response_body, 200, header)
  end

  def create(request)
    request_body_json = JSON.parse(request.body.read)
    puts "[request_body_json] #{request_body_json}"

    # DB に TODO を保存
    conn = PG::Connection.new(
      host: 'localhost',
      port: 5432,
      dbname: 'mydb',
      user: 'myuser',
      password: 'mypassword'
    )

    sql = 'INSERT INTO todos ("title") VALUES ($1)'
    puts "[sql] #{sql}"

    stmt_name = SecureRandom.uuid
    conn.prepare(stmt_name, sql)
    sql_params = [request_body_json['title']]
    conn.exec_prepared(stmt_name, sql_params)
    conn&.close

    # 一覧画面にリダイレクトするようなレスポンスを返却
    header = {
      'Location' => '/todos'
    }
    Rack::Response.new(nil, 303, header)
  end
end
