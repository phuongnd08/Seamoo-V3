# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
english = Category.create!(
  :alias => 'english', 
  :name=>'English', 
  :description => %{Bạn biết và nhận diện bao nhiêu từ tiếng Anh? 
    Bạn có thể nghe, ráp một câu tiếng anh hoàn chỉnh? 
    Câu trả lời sẽ có ở đây},
  :image => 'categories/english.png'
)

math = Category.create!(
  :alias => 'math', 
  :name=>'Toán', 
  :description => %{Bạn am hiểu bao nhiêu nguyên lí toán học? 
    Tốc độ phán đoán và luận logic của bạn? 
    Câu trả lời sẽ có ở đây},
  :image => 'categories/math.png',
  :status => 'coming_soon'
)

english_eggs = League.create!(
  :category => english, 
  :alias => 'english_eggs',
  :name => 'Basic English',
  :description => 'Dành cho người mới bắt đầu',
  :image => 'leagues/eng-eggs.png',
  :level => 0
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
  "What's your name", 
  {'phuong' => true, 'trien' => false, 'toan' => false}, 
  {:category => english, :level => 0}
)

Question.create_follow_pattern(
  "My name", 'ph[uo]ng ng[uy]en', 
  {:category => english, :level => 0}
)

Question.create_multiple_choices(
  "What's your best friend name", 
  {'thuc' => true, 'trien' => false, 'toan' => false}, 
  {:category => english, :level => 0}
)
Question.create_multiple_choices(
  "What's your pet name",
  {'na' => true, 'trien' => false, 'toan' => false},
  {:category => english, :level => 0}
)

["phuong", "hung", "thuc", "trien", "toan", "quan", "tien", "huy", "cuong", "mai", "thuy", "hoa"].each_with_index do |name, index|
  user = User.create(:display_name => name, :email => "#{name}@#{Site.domain}")
  Membership.create(:league => english_eggs, :user => user, :matches_count => index, :matches_score => index * 75)
end
