# frozen_string_literal: true

require 'rack'
require 'pg'
require 'securerandom'

require_relative './controllers/todos_controller'
require_relative './controllers/todos_xss_controller'
require_relative './controllers/todos_sql_injection_controller'
require_relative './controllers/todos_cors_controller'
require_relative './controllers/todos_csrf_controller'

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

    # XSS
    elsif request.path == '/todos/xss' && request.get?
      TodosXssController.new.index(request)

    elsif request.path == '/todos/xss' && request.post?
      TodosXssController.new.create(request)

    # SQL インジェクション
    elsif request.path == '/todos/sql-injection' && request.get?
      TodosSqlInjectionController.new.index(request)

    elsif request.path == '/todos/sql-injection' && request.post?
      TodosSqlInjectionController.new.create(request)

    # CORS
    elsif request.path == '/todos/cors' && request.get?
      TodosCorsController.new.index(request)

    elsif request.path == '/todos/cors' && request.post?
      TodosCorsController.new.create(request)

    # CSRF
    elsif request.path == '/todos/csrf' && request.get?
      TodosCsrfController.new.index(request)

    elsif request.path == '/todos/csrf' && request.post?
      TodosCsrfController.new.create(request)

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
