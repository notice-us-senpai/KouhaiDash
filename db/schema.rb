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

ActiveRecord::Schema.define(version: 20160703172524) do

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "type_no"
    t.integer  "group_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "is_public",  default: true
  end

  add_index "categories", ["group_id"], name: "index_categories_on_group_id"

  create_table "contacts", force: :cascade do |t|
    t.string   "name"
    t.string   "organisation"
    t.string   "position"
    t.string   "email"
    t.string   "phone"
    t.string   "website"
    t.text     "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "category_id"
  end

  create_table "google_accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "access_token"
    t.string   "refresh_token"
    t.datetime "expires_at"
    t.string   "gmail"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "google_accounts", ["gmail"], name: "index_google_accounts_on_gmail", unique: true
  add_index "google_accounts", ["user_id"], name: "index_google_accounts_on_user_id", unique: true

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "members_public", default: true
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "approved",   default: false
  end

  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id"
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id"

  create_table "task_assignments", force: :cascade do |t|
    t.integer  "task_id"
    t.integer  "membership_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "task_assignments", ["membership_id"], name: "index_task_assignments_on_membership_id"
  add_index "task_assignments", ["task_id"], name: "index_task_assignments_on_task_id"

  create_table "tasks", force: :cascade do |t|
    t.string   "name"
    t.date     "deadline"
    t.text     "description"
    t.boolean  "done"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "category_id"
  end

  add_index "tasks", ["category_id"], name: "index_tasks_on_category_id"

  create_table "text_pages", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "title"
    t.text     "contents"
    t.boolean  "load_from_google"
    t.string   "file_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "google_account_id"
  end

  add_index "text_pages", ["category_id"], name: "index_text_pages_on_category_id"
  add_index "text_pages", ["google_account_id"], name: "index_text_pages_on_google_account_id"

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password"
    t.string   "name"
    t.string   "email"
    t.date     "birthday"
    t.text     "description"
    t.string   "image"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
