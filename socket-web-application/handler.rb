class Handler
  def initialize
    @count = 0
  end

  def handle(path)
    case path
    when '/' then
      response_header = <<~EOT
        HTTP/1.1 200 OK
        Content-Type: text/html
      EOT
  
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
    when '/count' then
      @count += 1
  
      response_header = <<~EOT
        HTTP/1.1 200 OK
        Content-Type: text/html
      EOT
  
      response_body = <<~EOT
        <!DOCTYPE html>
        <html>
          <head>
            <title>count</title>
          </head>
          <body>
            <h1>count = #{@count}</h1>
          </body>
        </html>
      EOT
    when '/api/count' then
      @count += 1

      response_header = <<~EOT
        HTTP/1.1 200 OK
        Content-Type: application/json
      EOT

      response_body = <<~EOT
        {
          "count": #{@count}
        }
      EOT
    else
      response_header = <<~EOT
        HTTP/1.1 404 Not Found
        Content-Type: text/html
      EOT
  
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
    end
  
    return response_header, response_body
  end
end
