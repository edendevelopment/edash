require File.dirname(__FILE__) + '/spec_helper'

describe "Dashboard" do
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  after(:each) do
    `rm -f #{File.dirname(__FILE__)}/../dashboard-test.pstore`
    raise "Cannot remove test file!" if $? != 0
  end

  def app
    @app ||= Dashboard
  end

  it "responds to /" do
    visit'/'
    last_response.body.should match(/Dashboard/)
  end

  it "responds to a blank url too" do
    visit ''
    last_response.body.should match(/Dashboard/)
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
    last_response.body.should have_selector('li.fail') do |li|
      li.should contain(/moo/)
    end
  end

  context "posting an author" do
    it "shows the author gravator for the last commit" do
      author = 'Chris Parsons <chris@example.com>'
      post 'build/moo/fail', 'author=' + author
      visit '/'
      last_response.body.should have_selector('li.fail') do |li|
        li.should have_selector('img[src*="9655f78d38f380d17931f8dd9a227b9f"]')
      end
    end
  end
end
