# frozen_string_literal: true

require 'rack'
require 'pg'
require 'securerandom'

DEFAULT_HEADER = {
  'Content-Type' => 'text/html'
}.freeze

class SampleWebApplication
  def call(env)
    request = Rack::Request.new(env)

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

    response = Rack::Response.new(response_body, 200, DEFAULT_HEADER)
    response.finish
  end
end

run SampleWebApplication.new
