After do |scenario|
  if scenario.failed? && scenario.source_tag_names.include?("@focus")
    puts "Scenario failed. You are in rails console because a hook set up inside #{__FILE__}. Type exit when you are done"
    require 'irb'
    require 'irb/completion'
    ARGV.clear
    IRB.start
  end
end

