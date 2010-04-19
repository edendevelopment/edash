require File.dirname(__FILE__) + '/spec_helper'

describe "Integration Tests:" do
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

  context "posting progress update" do
    def post_progress
      post "progress", :project => "moo", :progress => %{[["finished","10"],["started","40"],["unstarted","10"]]}
      visit '/'
    end
    context "without a valid project" do
      it "will return a 404" do
        post "progress", :project => "foo"
        last_response.status.should == 404
      end
    end
    context "with a valid project" do
      before(:each) do
        post 'build', :project => 'moo', :status => 'pass'
        visit '/'
      end
      it "does not show a progress bar before submission" do
        last_response.body.should_not have_selector('div.progress')
      end
      it "shows the progress bar for the project" do
        post_progress
        last_response.body.should have_selector('div.progress.finished') do|div|
          div.should contain(/10/)
        end
      end
      it "shows the width correctly" do
        post_progress
        last_response.body.should have_selector('div.finished', :style => 'width:50px')
        last_response.body.should have_selector('div.started', :style => 'width:200px')
        last_response.body.should have_selector('div.unstarted', :style => 'width:50px')
      end
      context "and then posting build updates" do
        it "retains the progress information" do
          post_progress
          post 'build', :project => 'moo', :status => 'fail'
          visit '/'
          last_response.body.should have_selector('div.progress')
        end
      end
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
