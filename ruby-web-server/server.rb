require 'socket'

port = 8000
server = TCPServer.open(port)

while true
  socket = server.accept

  puts '=== socket.peeraddr ==='
  puts socket.peeraddr

  puts '=== request ==='
  while true
    buf = socket.gets
    puts buf

    if buf.chomp.empty?
      break
    end
  end

  socket.write <<-EOT
HTTP/1.1 200 OK
Content-Type: text/html

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

  socket.close
end

server.close
