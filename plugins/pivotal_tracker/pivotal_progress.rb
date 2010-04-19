require 'nokogiri'

class PivotalProgress
  attr_reader :state

  def initialize(xml)
    reader = Nokogiri::XML::Document.parse(xml)
    @state = reader.xpath('//stories//story//current_state').inner_html
  end

end
