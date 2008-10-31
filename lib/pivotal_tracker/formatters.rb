module PivotalTracker::Formatters
  def self.formatter(options)
    if options[:formatter] == "pdf"
      PDFFormatter.new
    else
      ConsoleFormatter.new
    end
  end
end

require "pivotal_tracker/formatters/console_formatter"
require "pivotal_tracker/formatters/pdf_formatter"
