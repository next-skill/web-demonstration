# frozen_string_literal: true

require 'rack'
require 'pg'
require 'securerandom'

HEADER = {
  'Content-Type' => 'text/html'
}.freeze

class SampleWebApplication
  def call(env)
    request = Rack::Request.new(env)
    response = handle(request)
    response.finish
  end

  private

  def handle(request)
    if request.path == '/' && request.get?
      response_body = <<~EOT
        <!DOCTYPE html>
        <html>
          <head>
            <title>hello</title>
          </head>
          <body>
            <h1>Hello Ruby!!!</h1>
          </body>
        </html>
      EOT

      Rack::Response.new(response_body, 200, HEADER)
    elsif request.path == '/todos' && request.get?
      conn = PG::Connection.new(
        host: 'localhost',
        port: 5432,
        dbname: 'mydb',
        user: 'myuser',
        password: 'mypassword'
      )

      sql = 'SELECT id, title FROM todos'
      puts "[SQL LOG] #{sql}"

      result = conn.exec(sql)
      conn&.close

      table_body_html = result.map do |record|
        <<~EOT
          <tr>
            <td>#{record['id']}</td>
            <td>#{record['title']}</td>
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
            <form method="post">
              <label>title: </label>
              <input type="text" name="title" />
              <button type="submit">register</button>
            </form>
          </body>
        </html>
      EOT

      Rack::Response.new(response_body, 200, HEADER)
    elsif request.path == '/todos' && request.post?
      conn = PG::Connection.new(
        host: 'localhost',
        port: 5432,
        dbname: 'mydb',
        user: 'myuser',
        password: 'mypassword'
      )

      sql = 'INSERT INTO todos ("title") VALUES ($1)'
      puts "[SQL LOG] #{sql}"

      stmt_name = SecureRandom.uuid
      conn.prepare(stmt_name, sql)
      sql_params = [request.params['title']]
      conn.exec_prepared(stmt_name, sql_params)
      conn&.close

      header = {
        'Location' => '/todos'
      }
      Rack::Response.new(nil, 303, header)
    else
      response_body = <<~EOT
        <!DOCTYPE html>
        <html>
          <head>
            <title>Not Found</title>
          </head>
          <body>
            <h1>404 Not Found</h1>
          </body>
        </html>
      EOT

      Rack::Response.new(response_body, 404, HEADER)
    end
  end
end

run SampleWebApplication.new
