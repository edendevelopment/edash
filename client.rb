require 'eventmachine'
require 'em-http'

module Dashboard
  module Client
    def self.send_message(host, message)
      EventMachine.run do
        http = EventMachine::HttpRequest.new("ws://#{host}:8080/websocket").get :timeout => 5
        http.errback {
          puts "Error connecting to server"
          EventMachine.stop
        }
        http.callback {
          http.send(message)
        }
        http.stream {
          EventMachine.stop
        }
      end
    end
  end
end
