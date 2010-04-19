require File.dirname(__FILE__) + '/spec_helper'

describe EDash::Server do
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  before(:each) do
    EDash::Client.stub!(:send_message)
  end

  after(:each) do
    `rm -f #{File.dirname(__FILE__)}/../dashboard-test.pstore`
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

  context "posting progress update" do
    before(:each) do
      post 'build', :project => 'moo', :status => 'pass'
    end
    it "does not show a progress bar before submission" do
      visit '/'
      last_response.body.should_not have_selector('div.progress')
    end
    it "shows the progress bar for the project" do
      post "progress", :project => "moo", :progress => %{[["finished","10"],["started","40"],["unstarted","10"]]}
      visit '/'
      last_response.body.should have_selector('div.progress.finished') do|div|
        div.should contain(/10/)
      end
    end

    it "shows the width correctly" do
      post "progress", :project => "moo", :progress => %{[["finished","10"],["started","40"],["unstarted","10"]]}
      visit '/'
      last_response.body.should have_selector('div.finished', :style => 'width:50px')
      last_response.body.should have_selector('div.started', :style => 'width:200px')
      last_response.body.should have_selector('div.unstarted', :style => 'width:50px')
    end
  end
  context "posting build update" do
    def do_post(status)
      post 'build', :project => 'moo', :status => status
      visit '/'
    end

    it "tags passing builds green" do
      do_post('pass')
      last_response.body.should have_selector('a.pass') do |div|
        div.should contain('moo')
      end
    end

    it "tags failing builds red" do
      do_post('fail')
      last_response.body.should have_selector('a.fail') do |div|
        div.should contain(/moo/)
      end
    end

    it "does not have an image" do
      do_post('fail')
      last_response.body.should_not have_selector('div.project img')
    end

    it "tags building grey with a loading image" do
      do_post('building')
      last_response.body.should have_selector('a.building')
      last_response.body.should have_selector('div.project img[src*=loading]')
    end
    context "with an author" do
      def do_post(author = "")
        post 'build', :project => 'moo', :status => 'fail', :author => author
        visit '/'
      end

      it "shows the author gravator for the last commit" do
        do_post('Chris Parsons <chris@example.com>')
        last_response.body.should have_selector('a.fail')
        last_response.body.should have_selector('div.project img[src*="9655f78d38f380d17931f8dd9a227b9f"]')
      end

      it "replaces spaces with plusses in the email addresses" do
        do_post('C P <dev sermoa tristanharris@edendevelopment.co.uk>')
        last_response.body.should have_selector('div.project img[src*="fecb482a5c1d13c869027b5dac71da00"]')
      end
      
      it "posts to a websocket" do
        EDash::Client.should_receive(:send_message).with(anything, /"status":"fail"/)
        do_post
      end
    end
  end
end
