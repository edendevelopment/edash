require 'nokogiri'

class Pivotal::Project
  attr_reader :name

  include Pivotal::Api

  def initialize(xml)
    @name = from(xml).extract_element('project/name')
  end
end

