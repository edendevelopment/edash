require File.dirname(__FILE__) + '/spec_helper'

describe EDash::Server do
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  before(:each) do
    EDash::Client.stub!(:send_message)
  end

  after(:each) do
    `rm -f #{File.dirname(__FILE__)}/../edash-test.pstore`
    raise "Cannot remove test file!" if $? != 0
  end

  def app
    @app ||= EDash::Server
  end

  it "responds to /" do
    visit'/'
    last_response.body.should match(/Dashboard/)
  end

  it "responds to a blank url too" do
    visit ''
    last_response.body.should match(/Dashboard/)
  end
end
