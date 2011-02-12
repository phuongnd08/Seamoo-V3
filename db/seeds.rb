# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
english = Category.create!(:alias => 'english', :name=>'English', :description => 'Thử sức sự thành thạo Anh ngữ của bạn')
math = Category.create!(:alias => 'math', :name=>'Toán', :description => 'Thử sức kĩ năng toán học của bạn')
League.create!(:category => english, :alias => 'english_eggs', :name => 'Eggs', :description => 'Dành cho người mới bắt đầu')
League.create!(:category => english, :alias => 'english_chick', :name => 'Chicks', :description => 'Dành cho người khá')
League.create!(:category => english, :alias => 'english_chicken', :name => 'Chicken', :description => 'Dành cho người giỏi')
League.create!(:category => english, :alias => 'english_eagle', :name => 'Eagle', :description => 'Dành cho người RẤT giỏi')
Question.create_multiple_choices("What's your name", {'phuong' => true, 'trien' => false, 'toan' => false})
Question.create_follow_pattern("My name", 'ph[uo]ng')

User.create(:display_name => "phuong", :email => "phuong@seamoo.com")
User.create(:display_name => "hung", :email => "hung@seamoo.com")
