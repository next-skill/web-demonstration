require 'cgi/escape'
require 'securerandom'

SESSIONS = {}

class TodosController
  def index(request)

    request_session_id = request.cookies['session_id']
    if SESSIONS[request_session_id].nil?
      # セッション ID がメモリ上に登録されていない場合、セッション ID と CSRF トークンを払い出す
      session_id = SecureRandom.hex(32)
      csrf_token = SecureRandom.hex(32)
      SESSIONS[session_id] = {
        'csrf_token' => csrf_token
      }
    elsif
      # セッション ID が存在する場合は、そのセッション ID と CSRF トークンを使い続ける
      session_id = request_session_id
      csrf_token = SESSIONS[session_id]['csrf_token']
    end

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
          <form action="/todos" method="post">
            <label>title: </label>
            <input type="text" name="title" />
            <input type="hidden" name="token" value="#{csrf_token}" />
            <button type="submit">register</button>
          </form>
        </body>
      </html>
    EOT

    header = {
      'Content-Type' => 'text/html',
      'Set-Cookie' => "session_id=#{session_id}"
    }
    Rack::Response.new(response_body, 200, header)
  end

  def create(request)
    # CSRF トークンのチェック
    request_csrf_token = request.params['token']
    session_id = request.cookies['session_id']
    session_csrf_token = SESSIONS[session_id]['csrf_token']

    if request_csrf_token != session_csrf_token
      return Rack::Response.new("Invalid CSRF Token", 400, {})
    end

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
      'Location' => '/todos'
    }
    Rack::Response.new(nil, 303, header)
  end
end
