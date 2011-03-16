# common methods

def find_users_by_list(user_list)
  user_list.split(' and ').map{|username| User.find_by_display_name(username)}
end

def create_match_for_users(league, users)
  users.concat([users.first]).each do |user|
    league.request_match(user.id)
  end
  match = MatchUser.find_by_user_id(users.first.id).match
  league.matches << match
  match
end

Given /^these users$/ do |table|
  table.raw.each{|row| User.create!(:display_name => row.first, :email => row.first + "@seamoo.com")}
end

Given /^category (\w+) is available$/ do |category_name|
  Category.create(:name => category_name)
end

Given /^league (\w+) of (\w+) is openning$/ do |league_name, category_name|
  League.create(:name => league_name, :category => Category.find_by_name(category_name), :level => 0)
end

When /^(\w+) (?:still )?want to join (\w+)?$/ do |username, league_name|
  League.find_by_name(league_name).request_match(User.find_by_display_name(username).id)
end

Then /^no match is formed for (\w+)$/ do |username|
  user = User.find_by_display_name(username)
  MatchUser.find_by_user_id(user.id).should == nil
end

Given /^(?:a|an) (\w+) match between ([\w\s]+) formed$/ do |league_name, user_list|
  users = find_users_by_list(user_list)
  create_match_for_users(League.find_by_name(league_name), users)
end

Given /^(?:a|an) (\w+) match between ([\w\s]+) is started$/ do |league_name, user_list|
  users = find_users_by_list(user_list)
  match = create_match_for_users(League.find_by_name(league_name), users)
  skip_timestamps(Match) do
    match.update_attribute(:created_at, Time.now - Matching.started_after.seconds)
  end
end

Given /^(?:a|an) (\w+) match between ([\w\s]+) is finished$/ do |league_name, user_list|
  users = find_users_by_list(user_list)
  match = create_match_for_users(League.find_by_name(league_name), users)
  skip_timestamps(Match) do
    match.update_attribute(:created_at, Time.now - Matching.started_after.seconds - Matching.ended_after.seconds)
  end
end

Then /^(?:a|an) (\w+) match is formed for ([\w\s]+)$/ do |league_name, user_list|
  users = find_users_by_list(user_list)
  League.find_by_name(league_name).matches.detect{|m| m.users.to_set == users.to_set}.should_not == nil
end

Given /^(\w+) want to join (\w+) (\d+) minutes ago$/ do |username, league_name, m|
  user = User.find_by_display_name(username)
  league = League.find_by_name(league_name)
  league.request_match(user.id)
  league.send(:user_lastseen)[user.id] = m.to_i.minutes.ago.to_i
end

Given /^all data is fresh$/ do
  Object.new.extend(Utils::Memcached::Common).client.flush_all
end

Then /^there is (?:only )?(\d+) (\w+) match(?:es)? for (\w+)$/ do |count, league_name, username|
  user = User.find_by_display_name(username)
  League.find_by_name(league_name).matches.select{|m| m.users.include?(user)}.count.should == count.to_i
end

When /^(\w+) match on league (\w+)$/ do |username, league_name|
  Informer.login_as = username
  visit matching_league_path(League.find_by_name(league_name))
end

Given /^first (\w+) match use default questions$/ do |league_name|
  league = League.find_by_name(league_name)
  match = league.matches.first
  Rails.logger.warn("But first league match is nil") if match.nil?
  match.questions.clear
  Matching.questions_per_match.times.each do |i|
    match.questions << Question.all[i]
  end
end

Given /^league (\w+) has (\d+) questions$/ do |league_name, count|
  league = League.find_by_name(league_name)
  count.to_i.times do |i|
    question = Question.create_multiple_choices("Question \##{i+1}", 
                                                {'Option #a' => true, 'Option #b' => false}, 
                                                :category => league.category, :level => league.level)
  end
end

Given /^league (\w+) has (\d+) multiple choice questions$/ do |league_name, count|
  Given %{league #{league_name} has #{count} questions}
end

Given /^league (\w+) has (\d+) follow pattern questions$/ do |league_name, count|
  league = League.find_by_name(league_name)
  count.to_i.times do |i|
    question = Question.create_follow_pattern("Follow Pattern \##{i+1}", 'patt[ern]', 
                                              :category => league.category, :level => league.level)
  end
end

def assert_recored_answer(username, position, answer)
user = User.find_by_display_name(username)
  match_user = MatchUser.find_by_user_id(user.id)
  match = match_user.match
  realized_answer = match.questions[position].data.realized_answer(match_user.answers[position])
  realized_answer.should == answer
end
Then /^(\w+)'s recorded answer of (\d+)(?:st|nd|rd|th) question should be "([^"]*)"$/ do |username, pos, answer|
  assert_recored_answer(username, pos.to_i - 1, answer)
  end

Then /^(\w+)'s recorded answer of (\d+)(?:st|nd|rd|th) question should be empty$/ do |username, pos|
  assert_recored_answer(username, pos.to_i - 1, nil)
end

Given /^(\w+) is already at the last question$/ do |username|
  match_user = MatchUser.find_by_user_id(User.find_by_display_name(username).id)
  match_user.send(:current_question_position=, Matching.questions_per_match - 1)
  match_user.save!
end

Given /^(\w+) finished his match$/ do |username|
  match_user = MatchUser.find_by_user_id(User.find_by_display_name(username).id)
  match_user.add_answer(Matching.questions_per_match - 1, 'u')
  match_user.save!
end

Given /^first (\w+) match is ended$/ do |league_name|
  league = League.find_by_name(league_name)
  skip_timestamps(Match) do
    league.matches.first.update_attribute(:created_at, (Matching.started_after + Matching.ended_after + 1).seconds.ago)
  end
end

Given /^first (\w+) match will be ended in (\d+) seconds$/ do |league_name, seconds|
  league = League.find_by_name(league_name)
  skip_timestamps(Match) do
    league.matches.first.update_attribute(:created_at, (Matching.started_after + Matching.ended_after - seconds.to_i).seconds.ago)
  end
end

When /^(\w+) request to leave his current (\w+) match$/ do |username, league_name|
  league = League.find_by_name(league_name)
  user = User.find_by_display_name(username)
  league.leave_current_match(user.id)
end

Given /^all matches will be started after (\d+) seconds$/ do |seconds|
  Matching.stub(:started_after).and_return(seconds.to_f)
end

Given /^all matches will immediately start$/ do
  Given %{all matches will be started after 0 seconds}
end

When /^\w{2,} fill in "([^"]*)" with "([^"]*)"$/ do |selector, value|
  When %{I fill in "#{selector}" with "#{value}"}
end

Given /^(\w+) has finished his match$/ do |username|
  user = User.find_by_display_name(username)
  match_user = MatchUser.find_by_user_id(user.id)
  match_user.update_attribute(:finished_at, 1.seconds.ago)
end

Given /^(\w+) made (\d+) ((?:in)?correct) answers$/ do |username, number, correct|
  correct = correct == "correct"
  user = User.find_by_display_name(username)
  match_user = MatchUser.find_by_user_id(user.id)

  def correct_answer(multiple_choice)
    multiple_choice.options.find_index{ |o| o.correct }
  end
  number.to_i.times.each do
    question = match_user.current_question
    multiple_choice = question.data
    answer = if correct
               correct_answer(multiple_choice)
             else 
               ((0...multiple_choice.options.size).to_a - [correct_answer(multiple_choice)]).first
             end
    match_user.add_answer(match_user.current_question_position, answer.to_s)
  end
  match_user.save!
end

Given /^submitting answers will be delayed$/ do
  page.execute_script %{
    $.old_ajax = $.ajax;
    $.ajax = function(){
      var args = arguments;
      window.ajaxDelayedCall = function(){
        $.old_ajax.apply($, args);
      } 
    }
  }
end

Given /^submitting answers is resumed$/ do
  page.execute_script %{
    window.ajaxDelayedCall();
  } 
end


