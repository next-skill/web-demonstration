require 'socket'

port = 8000
server = TCPServer.open(port)

while true
  socket = server.accept

  request_line = socket.gets
  request_header = ''
  while true
    line = socket.gets
    break if line.chomp.empty?
    request_header << line
  end

  puts '=== request_line ==='
  puts request_line
  puts '=== request_header ==='
  puts request_header

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

  puts '=== response_header ==='
  puts response_header
  puts '=== response_body ==='
  puts response_body

  socket.write <<~EOT
  #{response_header}

  #{response_body}
  EOT

  socket.close
end

server.close
