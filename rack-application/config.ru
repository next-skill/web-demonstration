# frozen_string_literal: true

require 'rack'

HEADER = {
  'Content-Type' => 'text/html'
}.freeze

class JankenWebApplication
  def call(env)
    request = Rack::Request.new(env)
    response = handle(request)
    response.finish
  end

  private

  def handle(request) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
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
      response_body = <<~EOT
        <!DOCTYPE html>
        <html>
          <head>
            <title>todos</title>
          </head>
          <body>
            <h1>todos</h1>
            <form method="post">
              <label>name: </label>
              <input type="text" name="name" />
              <button type="submit">register</button>
            </form>
          </body>
        </html>
      EOT

      Rack::Response.new(response_body, 200, HEADER)
    elsif request.path == '/todos' && request.post?
      puts request.params
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

run JankenWebApplication.new
