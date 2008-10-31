require "rubygems"
require 'optparse'
require 'ostruct'
require "net/https"
require "uri"
require "hpricot"
require "date"

require "pivotal_tracker/story"
require "pivotal_tracker/iteration"
require "pivotal_tracker/formatters"

module PivotalTracker
  SERVER = "https://www.pivotaltracker.com/services/v1"

  def self.generate(args)
    options = parse_args(args)

    uri = URI.parse("#{SERVER}/projects/#{options[:project_id]}/stories")

    connection = Net::HTTP.new(uri.host, 443)
    connection.use_ssl      = true
    connection.verify_mode  = OpenSSL::SSL::VERIFY_NONE

    response = connection.get(uri.path, {'Token' => options[:token]})

    current_stories = Hpricot(response.body).search("story").inject([]) do |stories, story|
      story = Story.from_xml(story)
      stories << story if story.current?
      stories
    end

    PivotalTracker::Formatters.formatter(options).format(current_stories, options)
  end

  def self.parse_args(args)
    options = default_options
    options.merge!(load_options_from_config)

    opts = OptionParser.new do |opts|
      opts.banner = "Usage: pt [options]"

      opts.on("-p", "--project PROJECT_ID", "Specify the project id") do |project_id|
        options[:project_id] = project_id
      end

      opts.on("-t", "--token TOKEN"," Specify the API token") do |token|
        options[:token] = token
      end

      opts.on("-f", "--formatter FORMATTER", "Specify the formatter to use (current options are console or pdf)") do |formatter|
        options[:formatter] = formatter
      end

      opts.on("-o", "--output FILE_NAME", "Specify the output filename (default stories.pdf)") do |file_name|
        options[:file_name] = file_name
      end

      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit!
      end
    end

    opts.parse!(args)

    if validate_options(options)
      options
    else
      puts opts
      exit!
    end
  end

  def self.default_options
    {
      :formatter => "console",
      :file_name => "stories.pdf"
    }
  end

  def self.load_options_from_config
    if File.exist?(".tracker")
      YAML::load(IO.read(".tracker")).inject({}) do |options, option|
        options[option[0].to_sym] = option[1]
        options
      end
    else
      Hash.new
    end
  end

  def self.validate_options(options)
    return false if options[:project_id].nil?
    return false if options[:token].nil?
    return true
  end
end