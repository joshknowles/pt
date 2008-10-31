module PivotalTracker
  class Story
    attr_reader :id, :name, :description, :estimate, :iteration

    def self.from_xml(doc)
      id          = doc.at("id").inner_html
      name        = doc.at("name").inner_html
      description = doc.at("description").inner_html
      estimate    = doc.at("estimate").inner_html
      iteration   = doc.at("iteration")

      iteration = Iteration.from_xml(iteration) unless iteration.nil?

      self.new(id, name, description, estimate, iteration)
    end

    def initialize(id, name, description, estimate, iteration)
      @id           = id
      @name         = name
      @description  = description
      @estimate     = estimate
      @iteration    = iteration
    end

    def current?(today = Date.today)
      !iteration.nil? && iteration.starts_on <= today && iteration.ends_on >= today
    end
  end
end