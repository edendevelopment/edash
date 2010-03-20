require File.dirname(__FILE__) + '/spec_helper'

describe "Dashboard" do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
  end

  it "responds to /" do
    get '/'
    last_response.body.should match(/Dashboard/)
  end

  it "responds to a blank url too" do
    get ''
    last_response.body.should match(/Dashboard/)
  end

  it "allows setting of project state to pass" do
    post 'build/moo/pass'
    get '/'
    last_response.body.should match(/moo.*pass/m)
  end
end
