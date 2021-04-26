require "cgi/escape"

class TodosSqlInjectionController
  def index(request)
    # DB から TODO 一覧を取得
    conn = PG::Connection.new(
      host: 'localhost',
      port: 5432,
      dbname: 'mydb',
      user: 'myuser',
      password: 'mypassword'
    )

    title = request.params['title']

    if title.nil?
      sql = 'SELECT id, title FROM todos'
    else
      sql = "SELECT id, title FROM todos WHERE title = '#{title}'"
    end

    puts "[sql] #{sql}"

    result = conn.exec(sql)
    conn&.close

    # 取得したデータから HTML を生成
    table_body_html = result.map do |record|
      <<~EOT
        <tr>
          <td>#{CGI.escapeHTML(record['id'])}</td>
          <td>#{CGI.escapeHTML(record['title'])}</td>
        </tr>
      EOT
    end.join

    response_body = <<~EOT
      <!DOCTYPE html>
      <html>
        <head>
          <title>todos</title>
        </head>
        <body>
          <h1>todos</h1>
          <form action="/todos/sql-injection">
            <label>title: </label>
            <input type="text" name="title" />
            <button type="submit">search</button>
          </form>
          <table>
            <thead>
              <tr>
                <th>id</th>
                <th>title</th>
              </tr>
            </thead>
            <tbody>
              #{table_body_html}
            </tbody>
          </table>
          <form action="/todos/sql-injection" method="post">
            <label>title: </label>
            <input type="text" name="title" />
            <button type="submit">register</button>
          </form>
        </body>
      </html>
    EOT

    header = {
      'Content-Type' => 'text/html'
    }
    Rack::Response.new(response_body, 200, header)
  end

  def create(request)
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
    sql_params = [request.params['title']]
    conn.exec_prepared(stmt_name, sql_params)
    conn&.close

    # 一覧画面にリダイレクトするようなレスポンスを返却
    header = {
      'Location' => '/todos/sql-injection'
    }
    Rack::Response.new(nil, 303, header)
  end
end
