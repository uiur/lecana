# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20120330115447) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "activities", :force => true do |t|
    t.integer  "activity_type"
    t.integer  "target_id"
    t.string   "target_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "target2_id"
    t.string   "target2_type"
  end

  add_index "activities", ["activity_type", "target_id"], :name => "index_activities_on_activity_type_and_target_id"
  add_index "activities", ["user_id"], :name => "index_activities_on_user_id"

  create_table "colleges", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faculties", :force => true do |t|
    t.string   "name"
    t.string   "name2"
    t.integer  "college_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "faculties", ["college_id"], :name => "index_faculties_on_college_id"

  create_table "favs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "favable_id"
    t.string   "favable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favs", ["favable_id"], :name => "index_favs_on_favable_id"
  add_index "favs", ["user_id"], :name => "index_favs_on_user_id"

  create_table "info_terms", :force => true do |t|
    t.integer  "subject_info_id"
    t.integer  "term_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "info_terms", ["subject_info_id"], :name => "index_info_terms_on_subject_info_id"
  add_index "info_terms", ["term_id"], :name => "index_info_terms_on_term_id"

  create_table "notes", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["subject_id"], :name => "index_notes_on_subject_id"
  add_index "notes", ["user_id"], :name => "index_notes_on_user_id"

  create_table "periods", :force => true do |t|
    t.integer  "day"
    t.integer  "ord"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "periods", ["day", "ord"], :name => "index_periods_on_day_and_ord"

  create_table "periods_subject_infos", :id => false, :force => true do |t|
    t.integer "period_id"
    t.integer "subject_info_id"
  end

  add_index "periods_subject_infos", ["period_id"], :name => "index_periods_subject_infos_on_period_id"
  add_index "periods_subject_infos", ["subject_info_id"], :name => "index_periods_subject_infos_on_subject_info_id"

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.integer  "postable_id"
    t.string   "postable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["postable_id"], :name => "index_posts_on_postable_id"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "reviews", :force => true do |t|
    t.integer  "user_id"
    t.integer  "subject_id"
    t.integer  "rating"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rating2"
  end

  add_index "reviews", ["subject_id"], :name => "index_reviews_on_subject_id"
  add_index "reviews", ["user_id"], :name => "index_reviews_on_user_id"

  create_table "settings", :force => true do |t|
    t.integer  "faculty_id"
    t.integer  "college_id"
    t.integer  "user_id"
    t.integer  "entered_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["college_id"], :name => "index_settings_on_college_id"
  add_index "settings", ["faculty_id"], :name => "index_settings_on_faculty_id"
  add_index "settings", ["user_id"], :name => "index_settings_on_user_id"

  create_table "subject_infos", :force => true do |t|
    t.string   "room"
    t.integer  "year"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subject_infos", ["subject_id"], :name => "index_subject_infos_on_subject_id"

  create_table "subject_infos_users", :force => true do |t|
    t.integer  "subject_info_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subject_infos_users", ["subject_info_id"], :name => "index_subject_infos_users_on_subject_info_id"
  add_index "subject_infos_users", ["user_id"], :name => "index_subject_infos_users_on_user_id"

  create_table "subjects", :force => true do |t|
    t.string   "name"
    t.integer  "college_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects_teachers", :id => false, :force => true do |t|
    t.integer "subject_id"
    t.integer "teacher_id"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "teachers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "terms", :force => true do |t|
    t.integer  "ord"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploads", :force => true do |t|
    t.integer  "subject_id"
    t.integer  "user_id"
    t.string   "name"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uploads", ["subject_id"], :name => "index_uploads_on_subject_id"
  add_index "uploads", ["user_id"], :name => "index_uploads_on_user_id"

  create_table "userauths", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "screen_name"
    t.string   "token"
    t.string   "secret"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url"
    t.boolean  "admin",      :default => false
  end

end
