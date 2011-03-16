# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110316133112) do

  create_table "authorizations", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "alias"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",      :default => "active"
    t.string   "image"
  end

  create_table "debugger_signals", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "follow_patterns", :force => true do |t|
    t.text     "instruction"
    t.string   "pattern"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leagues", :force => true do |t|
    t.integer  "category_id"
    t.string   "alias"
    t.string   "name"
    t.string   "description"
    t.string   "image"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",      :default => "active"
  end

  create_table "match_questions", :force => true do |t|
    t.integer  "match_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "match_users", :force => true do |t|
    t.integer  "match_id"
    t.integer  "user_id"
    t.integer  "rank"
    t.float    "score"
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_question_position", :default => 0
    t.text     "answers"
  end

  create_table "matches", :force => true do |t|
    t.integer  "league_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.time     "finished_at"
  end

  create_table "multiple_choice_options", :force => true do |t|
    t.integer  "parent_id"
    t.text     "content"
    t.boolean  "correct"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "multiple_choices", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "packages", :force => true do |t|
    t.string   "path"
    t.text     "entries"
    t.boolean  "done"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.integer  "level"
  end

  create_table "questions", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_type"
    t.integer  "data_id"
    t.integer  "category_id"
  end

  create_table "users", :force => true do |t|
    t.string   "display_name"
    t.string   "email"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

end
