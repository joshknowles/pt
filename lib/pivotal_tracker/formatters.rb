module PivotalTracker::Formatters
  def self.formatter(options)
    @formatter ||= begin
                    formatter   = options[:formatter]
                    initializer = "initialize_#{formatter}_formatter"

                    if self.respond_to?(initializer)
                      self.send(initializer)
                    else
                      raise "Unknown Formatter: #{formatter}"
                    end
                   end
  end

private

  def self.initialize_console_formatter
    require "pivotal_tracker/formatters/console_formatter"
    ConsoleFormatter.new
  end

  def self.initialize_pdf_formatter
    require "pivotal_tracker/formatters/pdf_formatter"
    PDFFormatter.new
  end
end