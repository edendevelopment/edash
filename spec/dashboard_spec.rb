require File.dirname(__FILE__) + '/spec_helper'

describe "Dashboard" do
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  def app
    @app ||= Sinatra::Application
  end

  it "responds to /" do
    visit'/'
    last_response.body.should match(/Dashboard/)
  end

  it "responds to a blank url too" do
    visit ''
    last_response.body.should match(/Dashboard/)
  end

  it "allows setting of project state to pass" do
    post 'build/moo/pass'
    visit '/'
    last_response.body.should match(/moo.*pass/m)
  end

  it "tags passing builds green" do
    post 'build/moo/pass'
    visit '/'
    last_response.body.should have_selector('li', :class => 'pass') do |li|
      li.should contain('moo')
    end
  end

  it "tags failing builds red" do
    post 'build/moo/fail'
    visit '/'
    last_response.body.should have_selector('li', :class => 'fail') do |li|
      li.should contain('moo')
    end
  end
end
