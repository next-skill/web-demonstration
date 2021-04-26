# frozen_string_literal: true

require 'rack'
require 'pg'
require 'securerandom'

require_relative './controllers/todos_controller'
require_relative './controllers/todos_xss_controller'
require_relative './controllers/todos_sql_injection_controller'

class SampleWebApplication
  def call(env)
    request = Rack::Request.new(env)
    response = handle(request)
    response.finish
  end

  private

  def handle(request)
    if request.path == '/todos' && request.get?
      TodosController.new.index(request)

    elsif request.path == '/todos' && request.post?
      TodosController.new.create(request)

    # 同一オリジンポリシー
    elsif request.path == '/same-origin-policy' && request.get?
      response_body = <<~EOT
        <!DOCTYPE html>
        <html>
          <head>
            <meta charset="utf-8">
            <title>demo</title>
          </head>
          <body>
            <h1>同一オリジンポリシー</h1>
            <hr>
            <h2>同一オリジンの場合</h2>
            <div id="same-origin-output"></div>
            <hr>
            <h2>異なるオリジンの場合</h2>
            <div id="cross-origin-output"></div>
            <hr>
            <h2>異なるオリジンで CORS を設定した場合</h2>
            <div id="cors-output"></div>
          </body>
          <script>
            async function robData(requestUrl, outputId) {
              response = await fetch(requestUrl)
              responseText = await response.text()

              const outputTag = document.getElementById(outputId)
              outputTag.innerHTML = responseText
            }
            robData('http://localhost:9393/todos', 'same-origin-output')
            robData('http://localhost:9292/todos', 'cross-origin-output')
            robData('http://localhost:9292/todos/cors', 'cors-output')
          </script>
        </html>
      EOT

      header = {
        'Content-Type' => 'text/html'
      }
      Rack::Response.new(response_body, 200, header)

    # CSRF
    elsif request.path == '/csrf' && request.get?
      response_body = <<~EOT
        <!DOCTYPE html>
        <html>
          <head>
            <title>demo</title>
          </head>
          <body>
            <h1>404 Not Found</h1>
          </body>
        </html>
      EOT

      header = {
        'Content-Type' => 'text/html'
      }
      Rack::Response.new(response_body, 200, header)

    # その他の場合は 404 ページ
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

      header = {
        'Content-Type' => 'text/html'
      }
      Rack::Response.new(response_body, 404, header)
    end
  end
end

run SampleWebApplication.new
