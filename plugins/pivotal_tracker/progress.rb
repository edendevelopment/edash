require 'nokogiri'

class Pivotal::Progress
  attr_reader :state

  include Pivotal::Api

  def initialize(xml)
    @state = from(xml).extract_element('//stories//story//current_state')
  end
end
