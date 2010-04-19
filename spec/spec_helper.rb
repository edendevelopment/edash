require 'rubygems'

require File.join(File.dirname(__FILE__), '..', 'dashboard.rb')
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
Dashboard::Server.set :environment, :test
Dashboard::Server.set :run, false
Dashboard::Server.set :raise_errors, true
Dashboard::Server.set :logging, false
