require File.join(File.dirname(__FILE__), "spec_helper")

require "pivotal_tracker"

describe PivotalTracker do
  describe "default_options" do
    it "should default to the console formatter" do
      PivotalTracker.default_options[:formatter].should == "console"
    end

    it "should default file_name to stories.pdf" do
      PivotalTracker.default_options[:file_name].should == "stories.pdf"
    end
  end

  describe "validate_options" do
    before :each do
      @valid_options = {
        :project_id => "111",
        :token      => "AAasdADasdASD"
      }
    end

    it "should return true if all required options are present" do
      PivotalTracker.validate_options(@valid_options).should == true
    end

    it "should return false if project_id is missing" do
      @valid_options[:project_id] = nil
      PivotalTracker.validate_options(@valid_options).should == false
    end

    it "should return false if token is missing" do
      @valid_options[:token] = nil
      PivotalTracker.validate_options(@valid_options).should == false
    end
  end
end