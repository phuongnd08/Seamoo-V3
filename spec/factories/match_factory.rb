Factory.define(:match) do |m|
  m.league{ Factory(:league_with_questions) }
end
