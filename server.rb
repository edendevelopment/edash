require 'sinatra'
require 'haml'
require 'sass'

require 'client'
require 'project'
require 'progress_report'
require 'storage'

# For Countdown widget
require 'countdown'

module EDash
  class Server < Sinatra::Base

    set :static, true
    set :public, 'public'
    set :haml, { :format => :html5 }

    before do
      headers 'Content-Type' => 'text/html; charset=utf-8'
    end

    def initialize
      Storage.init_store(options.environment.to_s)
      super
    end

    helpers do
      def path_root
        "http://" + request.env["HTTP_HOST"]
      end
    end

    get '/?', :agent => /iPhone|iPod/ do
      @projects = Project.all
      haml :mobile
    end

    get '/detail/:project', :agent => /iPhone|iPod/ do
      @project = Project.find(params[:project])
      if (@project.nil?)
        return 404
      end
      haml :detail, :layout => false
    end

    get '/?' do
      @projects = Project.all
      @countdowns = Countdown.all
      haml :index
    end

    post '/build/?' do
      project = Project.find(params[:project])
      if (project.nil?)
        project = Project.new(params)
      else
        project.update_from(params)
      end
      Project.save(project)
      EDash::Client.send_message(request.host, project.to_json)
    end

    post '/progress/?' do
      project = Project.find(params[:project])
      if (project.nil?)
        return 404
      else
        project.progress = ProgressReport.new(params[:progress])
        Project.save(project)
      end
      EDash::Client.send_message(request.host, project.to_json)
    end
    
    post '/countdown/?' do
      countdown = Countdown.find_or_create(params[:countdown])
      EDash::Client.send_message(request.host, countdown.to_json)
      redirect '/'
    end

    get '/main.css' do
      content_type 'text/css', :charset => 'utf-8'
      sass :main
    end
    
    get '/mobile.css' do
      content_type 'text/css', :charset => 'utf-8'
      sass :mobile
    end
  end
end
