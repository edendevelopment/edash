require File.dirname(__FILE__) + '/spec_helper'

describe Dashboard::Server do
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  after(:each) do
    `rm -f #{File.dirname(__FILE__)}/../dashboard-test.pstore`
    raise "Cannot remove test file!" if $? != 0
  end

  def app
    @app ||= Dashboard::Server
  end

  it "responds to /" do
    visit'/'
    last_response.body.should match(/Dashboard/)
  end

  it "responds to a blank url too" do
    visit ''
    last_response.body.should match(/Dashboard/)
  end

  context "posting build update" do
    before(:each) do
      Dashboard::Client.stub!(:send_message)
    end

    it "tags passing builds green" do
      post 'build/moo/pass'
      visit '/'
      last_response.body.should have_selector('a.pass') do |div|
        div.should contain('moo')
      end
    end

    it "tags failing builds red" do
      post 'build/moo/fail'
      visit '/'
      last_response.body.should have_selector('a.fail') do |div|
        div.should contain(/moo/)
      end
    end

    it "tags building grey with a loading image" do
      post 'build/moo/building'
      visit '/'
      last_response.body.should have_selector('a.building')
      last_response.body.should have_selector('div.project') do |div|
        div.should have_selector("img[src*=loading]")
      end
    end
    context "with an author" do

      def do_post(author = "")
        post 'build/moo/fail', 'author=' + author
        visit '/'
      end

      it "shows the author gravator for the last commit" do
        do_post('Chris Parsons <chris@example.com>')
        last_response.body.should have_selector('a.fail')
        last_response.body.should have_selector('div.project') do |div|
          div.should have_selector('img[src*="9655f78d38f380d17931f8dd9a227b9f"]')
        end
      end

      it "replaces spaces with plusses in the email addresses" do
        do_post('C P <dev sermoa tristanharris@edendevelopment.co.uk>')
        last_response.body.should have_selector('div.project') do |div|
          div.should have_selector(
          'img[src*="fecb482a5c1d13c869027b5dac71da00"]')
        end
      end
      
      it "posts to a websocket" do
        Dashboard::Client.should_receive(:send_message).with(anything, "foo")
        do_post
      end
    end
  end
end
