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
    if request.path == '/todos' && request.get?
      TodosController.new.index(request)

    elsif request.path == '/todos' && request.post?
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
end

run SampleWebApplication.new
