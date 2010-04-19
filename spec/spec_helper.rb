require 'rubygems'

require File.join(File.dirname(__FILE__), '..', 'server.rb')
require File.join(File.dirname(__FILE__), '..', 'client.rb')
require File.join(File.dirname(__FILE__), '..', 'project.rb')
require File.join(File.dirname(__FILE__), '..', 'progress_report.rb')
require File.join(File.dirname(__FILE__), '..', 'plugins', 'pivotal_tracker', 'pivotal_progress.rb')

require 'sinatra'
require 'rack/test'
require 'webrat'
require 'spec'
require 'spec/autorun'
require 'spec/interop/test'

Webrat.configure do |config|
  config.mode = :rack
end

# set test environment
EDash::Server.set :environment, :test
EDash::Server.set :run, false
EDash::Server.set :raise_errors, true
EDash::Server.set :logging, false
