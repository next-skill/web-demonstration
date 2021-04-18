# frozen_string_literal: true

require 'rack'
require 'pg'
require 'securerandom'

require_relative './todos_controller'

class SampleWebApplication
  def call(env)
    request = Rack::Request.new(env)
    response = handle(request)
    response.finish
  end

  private

  def handle(request)
    if request.path == '/todos.html' && request.get?
      static_file(request)

    elsif request.path == '/todos.js' && request.get?
      static_file(request)
  
    elsif request.path == '/api/todos' && request.get?
      TodosController.new.index(request)

    elsif request.path == '/api/todos' && request.post?
      TodosController.new.create(request)

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

  def static_file(request)
    puts Dir.pwd

    path = 'static' + request.path
    response_body = File.readlines(path).join

    Rack::Response.new(response_body, 200, {})
  end
end

run SampleWebApplication.new
