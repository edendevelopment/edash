require File.join(File.dirname(__FILE__), '..', 'dashboard.rb')

require 'rubygems'
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
Dashboard.set :environment, :test
Dashboard.set :run, false
Dashboard.set :raise_errors, true
Dashboard.set :logging, false
