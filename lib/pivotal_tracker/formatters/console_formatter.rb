class PivotalTracker::Formatters::ConsoleFormatter
  def format(stories, options)
    stories.each do |story|
      puts "Story: #{story.name} (#{story.estimate})"
    end
  end
end