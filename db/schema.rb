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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150720060938) do

  create_table "question_options", force: true do |t|
    t.integer  "question_id"
    t.string   "description"
    t.string   "ordinal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_options", ["question_id"], name: "index_question_options_on_question_id", using: :btree

  create_table "questions", force: true do |t|
    t.string   "title"
    t.string   "answer"
    t.string   "category"
    t.integer  "level"
    t.string   "explain"
    t.integer  "status",     default: 0
    t.integer  "quiz_type",  default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "train_logs", force: true do |t|
    t.integer  "user_id",                 null: false
    t.integer  "question_id",             null: false
    t.integer  "total_times", default: 0
    t.integer  "right_times", default: 0
    t.integer  "diamond",     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "train_logs", ["user_id", "question_id"], name: "index_train_logs_on_user_id_and_question_id", unique: true, using: :btree

  create_table "train_scores", force: true do |t|
    t.integer  "user_id",                                           null: false
    t.integer  "diamond",                             default: 0
    t.integer  "right_times",                         default: 0
    t.decimal  "ratio",       precision: 3, scale: 2, default: 0.0
    t.datetime "end_at"
    t.integer  "spend",                               default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "train_scores", ["user_id"], name: "index_train_scores_on_user_id", unique: true, using: :btree

  create_table "user_tokens", force: true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "nick_name",              null: false
    t.string   "email"
    t.integer  "age"
    t.integer  "sex",        default: 1
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["nick_name"], name: "index_users_on_nick_name", using: :btree

end
