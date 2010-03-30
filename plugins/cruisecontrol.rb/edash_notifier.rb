# A cruisecontrol.rb plugin to send notifications to edash (http://github.com/edendevelopment/edash)
#  - put it in $CRUISE_DATA_ROOT/builder_plugins and restart cruisecontrol.rb
#
# notify building status to edash
#
# You might need to change the host and port in the post line
require 'builder_error'
require 'rest_client'

class EdashNotifier < BuilderPlugin
  def build_started(build)
    set_status :building
  end

  def build_finished(build)
    set_status (build.failed? ? :fail : :pass)
  end

  private

  def set_status(status)
    RestClient.post('http://localhost:9292/build', :project => project.name, :status => status.to_s, :author => project.source_control.latest_revision.author)
  end

end

Project.plugin :edash_notifier
