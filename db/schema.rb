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

ActiveRecord::Schema.define(:version => 20110712153408) do

  create_table "features", :force => true do |t|
    t.string   "name"
    t.string   "priority"
    t.string   "state"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "weight",      :default => 1
    t.date     "start"
    t.date     "finish"
    t.integer  "sprint_id"
    t.integer  "project_id"
    t.string   "kind"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sprints", :force => true do |t|
    t.string   "name"
    t.text     "objective"
    t.date     "start"
    t.date     "finish"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.date     "start"
    t.string   "state"
    t.date     "finish"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "feature_id"
    t.integer  "effort"
    t.integer  "user_id"
    t.integer  "pending"
  end

  create_table "tracks", :force => true do |t|
    t.integer  "task_id"
    t.integer  "pending"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "day"
    t.integer  "sprint_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rol"
    t.integer  "location_id"
    t.string   "email"
    t.string   "surname"
    t.string   "login"
  end

end
