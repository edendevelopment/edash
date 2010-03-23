require 'sinatra'
require 'haml'
require 'sass'
require 'json'
require 'pstore'

require 'client'

module Dashboard
  class Server < Sinatra::Base

    set :static, true
    set :public, 'public'

    def initialize
      env = options.environment.to_s
      @store = PStore.new(File.dirname(__FILE__)+'/dashboard-'+ env +'.pstore')
    end

    helpers do
      def path_root
        ENV["RACK_BASE_URI"]
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

    post '/build/:project_name/:status' do |project_name, status|
      project = nil
      @store.transaction do
        @store[project_name] ||= {}
        @store[project_name][:status] = status
        @store[project_name][:author] = params['author']
        project = @store[project_name].merge(:project_name => project_name)
      end
      Dashboard::Client.send_message(request.host, project.to_json)
    end

    get '/main.css' do
      content_type 'text/css', :charset => 'utf-8'
      sass :main
    end
  end
end
