# Required so that we can set path correctly for Config, which is loaded statically due to a bug in cijoe
$project_path = File.dirname(__FILE__) + '/app'
require 'cijoe'

class CIJoe
  def run_hook(hook)
    if File.exists?(file=".git/hooks/#{hook}") && File.executable?(file)
      data =
        if @last_build && @last_build.commit
          {
            "MESSAGE" => @last_build.commit.message,
            "AUTHOR" => @last_build.commit.author,
            "SHA" => @last_build.commit.sha,
            "OUTPUT" => @last_build.clean_output
          }
        else
          {}
        end
      env = data.collect { |k, v| %(#{k}=#{v.inspect}) }.join(" ")
      env.gsub!(/`/, %{'}) #Monkey patch in backtick escapage
      `#{env} sh #{file}`
    end
  end
end
 
# setup middleware
use Rack::CommonLogger
# configure joe
CIJoe::Server.configure do |config|
  config.set :project_path, $project_path
  config.set :show_exceptions, true
  config.set :lock, true
end

run CIJoe::Server
