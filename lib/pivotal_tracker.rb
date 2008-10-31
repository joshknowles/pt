require "rubygems"
require 'optparse'
require 'ostruct'
require "net/https"
require "uri"
require "hpricot"

require "pivotal_tracker/story"
require "pivotal_tracker/iteration"
require "pivotal_tracker/formatters"

module PivotalTracker
  SERVER      = "https://www.pivotaltracker.com/services/v1"

  def self.generate(args)
    options = parse_args(args)

    uri = URI.parse("#{SERVER}/projects/#{options.project_id}/stories")

    connection = Net::HTTP.new(uri.host, 443)
    connection.use_ssl      = true
    connection.verify_mode  = OpenSSL::SSL::VERIFY_NONE

    response = connection.get(uri.path, {'Token' => options.token})

    current_stories = Hpricot(response.body).search("story").inject([]) do |stories, story|
      story = Story.from_xml(story)
      stories << story if story.current?
      stories
    end

    PivotalTracker::Formatters::PDF.generate(current_stories, options.file_name)
  end

  def self.parse_args(args)
    options = OpenStruct.new

    opts = OptionParser.new do |opts|
      opts.banner = "Usage: pt [options] FILE_NAME"

      opts.on("-p", "--project PROJECT_ID","Specify the project id") do |project_id|
        options.project_id = project_id
      end

      opts.on("-t", "--token TOKEN","Specify the API token") do |token|
        options.token = token
      end

      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit!
      end
    end

    opts.parse!(args)

    if args.empty?
      puts opts
      exit!
    else
      options.file_name = args.shift
      return options
    end
  end
end