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
            <iframe id="same-origin-iframe" src="http://localhost:9393/todos"></iframe>
            <div id="same-origin-output"></div>
            <hr>
            <h2>異なるオリジンの場合</h2>
            <iframe id="cross-origin-iframe" src="http://localhost:9292/todos"></iframe>
            <div id="cross-origin-output"></div>
            <hr>
            <h2>異なるオリジンで CORS を設定した場合</h2>
            <iframe id="cors-iframe" src="http://localhost:9292/todos/cors"></iframe>
            <div id="cors-output"></div>
          </body>
          <script>
            function robIframeData(iframeId, outputId) {
              const iframe = document.getElementById(iframeId)
              iframe.onload = () => {
                const innerHTML = iframe.contentWindow.document.body.innerHTML
                const outputTag = document.getElementById(outputId)
                outputTag.innerHTML = innerHTML
              }
            }
            robIframeData('same-origin-iframe', 'same-origin-output')
            robIframeData('cross-origin-iframe', 'cross-origin-output')
            robIframeData('cors-iframe', 'cors-output')
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
