require File.dirname(__FILE__) + '/spec_helper'

describe Dashboard::Client do
  context "sending messages" do
    it "creates the connection" do
      EventMachine.should_receive(:run).and_yield
      http = mock(:http, :errback => nil, :callback => nil, :stream => nil)
      EventMachine.should_receive(:connect).with(
        'host', 8080, EventMachine::HttpClient).and_return(http)
      Dashboard::Client.send_message('host', 'foo')
    end
  end
end
