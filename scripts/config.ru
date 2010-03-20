# Required so that we can set path correctly for Config, which is loaded statically due to a bug in cijoe
$project_path = File.dirname(__FILE__) + '/app'
require 'cijoe'

# setup middleware
use Rack::CommonLogger
# configure joe
CIJoe::Server.configure do |config|
  config.set :project_path, $project_path
  config.set :show_exceptions, true
  config.set :lock, true
end

run CIJoe::Server
