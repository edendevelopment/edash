require 'sinatra'
require 'haml'
require 'sass'
require 'pstore'

class Dashboard < Sinatra::Base

  set :static, true
  set :public, 'public'

  def initialize
    env = options.environment.to_s
    @store = PStore.new(File.dirname(__FILE__)+'/dashboard-'+ env +'.pstore')
  end

  helpers do
    def path_root
      ENV["PATH_INFO"]
    end
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
    @store.transaction do
      @store[project] ||= {}
      @store[project][:status] = status
      @store[project][:author] = params['author']
    end
  end

  get '/main.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :main
  end
end
