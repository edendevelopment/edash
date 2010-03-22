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
    last_response.body.should have_selector('div.pass') do |div|
      div.should contain('moo')
    end
  end

  it "tags failing builds red" do
    post 'build/moo/fail'
    visit '/'
    last_response.body.should have_selector('div.fail') do |div|
      div.should contain(/moo/)
    end
  end

  context "posting an author" do
    it "shows the author gravator for the last commit" do
      author = 'Chris Parsons <chris@example.com>'
      post 'build/moo/fail', 'author=' + author
      visit '/'
      last_response.body.should have_selector('div.fail') do |div|
        div.should have_selector('img[src*="9655f78d38f380d17931f8dd9a227b9f"]')
      end
    end

    it "replaces spaces with plusses in the email addresses" do
      author = 'C P <dev sermoa tristanharris@edendevelopment.co.uk>'
      post 'build/moo/fail', 'author=' + author
      visit '/'
      last_response.body.should have_selector('div.fail') do |div|
        div.should have_selector(
        'img[src*="fecb482a5c1d13c869027b5dac71da00"]')
      end
    end
  end
end
