  # encoding: utf-8
  # This file should contain all the record creation needed to seed the database with its default values.
  # The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
  #
  # Examples:
  #
  #   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
  #   Mayor.create(:name => 'Daley', :city => cities.first)
  math = Category.create!(
    :alias => 'math', 
    :name=>'Toán', 
    :description => %{Bạn am hiểu bao nhiêu nguyên lí toán học? 
      Tốc độ phán đoán và luận logic của bạn? 
      Câu trả lời sẽ có ở đây},
    :image => 'categories/math.png'
  )

  english = Category.create!(
    :alias => 'english', 
    :name=>'English', 
    :description => %{Bạn biết và nhận diện bao nhiêu từ tiếng Anh? 
      Bạn có thể nghe, ráp một câu tiếng anh hoàn chỉnh? 
      Câu trả lời sẽ có ở đây},
    :image => 'categories/english.png'
  )



  math_eggs = League.create!(
    :category => math, 
    :alias => 'math_eggs',
    :name => 'Basic Math',
    :description => 'Dành cho người mới bắt đầu',
    :image => 'leagues/eng-eggs.png',
    :level => 0,
    :use_formulae => true
  )

  League.create!(
    :category => english,
    :alias => 'english_chick',
    :name => 'Intermediate English',
    :description => 'Dành cho người khá',
    :image => 'leagues/eng-chick.png',
    :level => 1,
    :status => 'coming_soon'
  )

  League.create!(
    :category => english,
    :alias => 'english_rooster',
    :name => 'Advanced English',
    :description => 'Dành cho người giỏi',
    :image => 'leagues/eng-rooster.png',
    :level => 2,
    :status => 'coming_soon'
  )

  League.create!(
    :category => english,
    :alias => 'english_eagle',
    :name => 'Pro English',
    :description => 'Dành cho người *pro',
    :image => 'leagues/eng-eagle.png',
    :level => 3,
    :status => 'coming_soon'
  )

  Question.create_multiple_choices(
    "What's your formulae of $\\pi$", 
    {'$\\sigma$' => true, '$\\beta$' => false, '$\\alpha$' => false}, 
    {:category => math, :level => 0}
  )

  Question.create_follow_pattern(
    "My $\\lambda$", 'ph[uo]ng ng[uy]en', 
    {:category => math, :level => 0}
  )

  Question.create_multiple_choices(
    "What's your best $\\omega$", 
    {'thuc$\\omega$' => true, 'trien' => false, 'toan' => false}, 
    {:category => math, :level => 0}
  )
  Question.create_multiple_choices(
    "What's your pet $\\sigma$ name",
    {'na' => true, 'trien$\\omega$' => false, 'toan' => false},
    {:category => math, :level => 0}
  )
    Question.create_fill_in_the_blank(
      "Please fill in: {na[m]e1}, or {name|name2} or {name3}",
      {:category => math, :level => 0}
    )

  ["phuong", "hung", "thuc", "trien", "toan", "quan", "tien", "huy", "cuong", "mai", "thuy", "hoa"].each_with_index do |name, index|
    user = User.create(:display_name => name, :email => "#{name}@#{SiteSettings.domain}")
    Membership.create(:league => math_eggs, :user => user, :matches_count => index, :matches_score => index * 75)
  end
