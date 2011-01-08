Given /^I edit this multiple choice question$/ do |table|
  hash = table.hashes[0]
  question = Question.create_multiple_choices(hash['content'], MultipleChoice.string_to_options_hash(hash['options']))
  visit edit_question_path(question)
end

Then /^I should have this multiple choice question$/ do |table|
  hash = table.hashes[0]
  multiple_choice = MultipleChoice.find_by_content(hash['content'])
  multiple_choice.options.inject({}){|h, o| h[o.content] = o.correct; h}.should == MultipleChoice.string_to_options_hash(hash['options'])
end