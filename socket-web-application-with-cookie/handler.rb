require 'securerandom'

class Handler
  def initialize
    @sessions = {}
  end

  def handle(path, request_header)
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
      # Cookie を文字列解析してセッション ID を抽出
      cookie_name = 'sample-session-id'
      cookie_session_id = request_header
        .split(/\R/)
        .filter { |row| row.start_with?('Cookie: ')}
        .first
        .split(/ /)
        .filter { |c| c.start_with?("#{cookie_name}") }
        .first
        &.gsub(/^#{cookie_name}=([^; ]+);?$/, '\1')
        &.chomp
      puts '=== cookie_session_id ==='
      puts cookie_session_id
      puts '=== @sessions before increment ==='
      puts @sessions

      if cookie_session_id.nil? || @sessions[cookie_session_id].nil?
        # Cookie にセッション ID がないか、メモリ上に ID に対応するセッションデータがない場合、
        # セッション ID を新規で払い出す

        session_id = SecureRandom.uuid

        @sessions[session_id] = {
          count: 1
        }

        response_header = <<~EOT
          HTTP/1.1 200 OK
          Content-Type: text/html
          Set-Cookie: #{cookie_name}=#{session_id}
        EOT
      else
        session_id = cookie_session_id

        @sessions[session_id][:count] = @sessions[session_id][:count] + 1

        response_header = <<~EOT
          HTTP/1.1 200 OK
          Content-Type: text/html
        EOT
      end

      puts '=== @sessions after increment ==='
      puts @sessions

      response_body = <<~EOT
        <!DOCTYPE html>
        <html>
          <head>
            <title>count</title>
          </head>
          <body>
            <h1>count = #{@sessions[session_id][:count]}</h1>
          </body>
        </html>
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
