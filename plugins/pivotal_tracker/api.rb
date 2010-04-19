module Pivotal
  module Api
    def from(xml)
      @xml = Nokogiri::XML::Document.parse(xml)
      self
    end

    def extract_element(path)
      @xml.xpath(path).inner_html
    end
  end
end
