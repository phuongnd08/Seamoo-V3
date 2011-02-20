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
  visit "/auth/signin/#{username}"
  Then %{#{username} should see "Hello #{username}"}
  visit matching_league_path(League.find_by_name(league_name))
end

When /^\w{2,} press "([^"]*)"$/ do |button|
  When %{I press "#{button}"}
end

Then /^\w{2,} should be on (.+)$/ do |page|
  Then %{I should be on #{page}}
end

Then /^\w{2,} should soon be on (.+)$/ do |page|
  wait_for_true Capybara.default_wait_time, false do
    URI.parse(current_url).path == path_to(page)
  end
  Then %{I should be on #{page}}
end

When /^\w{2,} visit (.+)$/ do |page|
  Then %{I visit #{page}}
end

Then /^\w{2,} should see "([^"]*)"(.*)$/ do |text, scope_definition|
  text.split(/\s+[\*\?]\s+/).each do |part|
    Then %{I should see "#{part}"#{scope_definition}}
  end
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
    question = Question.create_multiple_choices("Question \##{i+1}", {'Option #a' => true, 'Option #b' => false})
    question.update_attributes(:category => league.category, :level => league.level)
  end
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

