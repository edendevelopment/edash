require 'sinatra'
require 'haml'
require 'sass'

require 'client'
require 'project'

module Dashboard
  class Server < Sinatra::Base

    set :static, true
    set :public, 'public'

    def initialize
      Project.init_store(options.environment.to_s)
      super
    end

    helpers do
      def path_root
        ENV["RACK_BASE_URI"]
      end
    end

    get '/?' do
      @projects = Project.all
      haml :index
    end

    post '/build/?' do
      project = Project.new(params)
      Project.save(project)
      Dashboard::Client.send_message(request.host, project.to_json)
    end

    get '/main.css' do
      content_type 'text/css', :charset => 'utf-8'
      sass :main
    end
  end
end
