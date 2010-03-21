require 'sinatra'
require 'haml'
require 'pstore'

class Dashboard < Sinatra::Base
  def initialize
    env = options.environment.to_s
    @store = PStore.new(File.dirname(__FILE__)+'/dashboard-'+ env +'.pstore')
  end

  get '/?' do
    @projects = {}
    @store.transaction do
      @store.roots.each do |name|
        @projects[name] = @store[name]
      end
    end
    haml :index
  end

  post '/build/:project/:status' do |project, status|
    @store.transaction { @store[project] = status }
  end
end
