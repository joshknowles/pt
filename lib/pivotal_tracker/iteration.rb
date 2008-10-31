module PivotalTracker
  class Iteration
    attr_reader :number, :starts_on, :ends_on

    def self.from_xml(doc)
      number    = doc.at("number").inner_html
      starts_on = Date.parse(doc.at("start").inner_html)
      ends_on   = Date.parse(doc.at("finish").inner_html)

      self.new(number, starts_on, ends_on)
    end

    def initialize(number, starts_on, ends_on)
      @number     = number
      @starts_on  = starts_on
      @ends_on    = ends_on
    end
  end
end