require File.join(File.dirname(__FILE__), %w[.. spec_helper])

require "pivotal_tracker/story"
require "pivotal_tracker/iteration"

describe PivotalTracker::Story do
  include PivotalTracker

  describe "current?" do
    it "should return false if the iteration is nil" do
      story = PivotalTracker::Story.new(:id, :name, :description, :estimate, nil)
      story.should_not be_current
    end

    it "should return true if the today falls within the iteration's start & end date" do
      iteration = PivotalTracker::Iteration.new(1, Date.today - 7, Date.today + 7)
      story     = PivotalTracker::Story.new(:id, :name, :description, :estimate, iteration)
      story.should be_current
    end
  end
end