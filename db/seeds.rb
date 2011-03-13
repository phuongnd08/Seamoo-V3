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

League.create!(:category => english, :alias => 'english_eggs', :name => 'Eggs', :description => 'Dành cho người mới bắt đầu', :level => 0)
League.create!(:category => english, :alias => 'english_chick', :name => 'Chicks', :description => 'Dành cho người khá', :level => 1)
League.create!(:category => english, :alias => 'english_chicken', :name => 'Chicken', :description => 'Dành cho người giỏi', :level => 2)
League.create!(:category => english, :alias => 'english_eagle', :name => 'Eagle', :description => 'Dành cho người RẤT giỏi', :level => 3)
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

User.create(:display_name => "phuong", :email => "phuong@seamoo.com")
User.create(:display_name => "hung", :email => "hung@seamoo.com")
