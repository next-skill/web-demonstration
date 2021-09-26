require 'socket'
require_relative 'handler'

port = 8000
server = TCPServer.open(port)

handler = Handler.new

while true
  socket = server.accept

  # リクエストの読み込み
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

  # パスの解析
  path = request_line.gsub(/^(.+) (.+) (.+)$/, '\2').chomp

  puts '=== path ==='
  puts path

  # パスごとのレスポンスの生成
  response_header, response_body = handler.handle(path, request_header)

  puts '=== response_header ==='
  puts response_header
  puts '=== response_body ==='
  puts response_body

  # レスポンスの返却
  socket.write <<~EOT
  #{response_header}

  #{response_body}
  EOT

  socket.close
end

server.close
