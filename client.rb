require 'eventmachine'
require 'em-http'

module EDash
  module Client
    def self.send_message(host, message)
      EventMachine.run do
        http = EventMachine::HttpRequest.new("ws://#{host}:8080/websocket").get :timeout => 5
        http.errback {
          puts "Error connecting to server"
        }
        http.callback {
          http.send(message)
        }
        http.stream {
        }
      end
    end
  end
end
