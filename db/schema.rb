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

ActiveRecord::Schema.define(:version => 20131027004811) do

  create_table "devices", :force => true do |t|
    t.integer  "patient_id"
    t.string   "access_token"
    t.integer  "max_threshold"
    t.integer  "min_threshold"
    t.string   "device_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "api_user_id"
  end

  create_table "patients", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "phone"
    t.string   "email"
    t.integer  "age"
    t.string   "gender"
    t.string   "mobile"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.integer  "patient_id"
    t.string   "email"
    t.string   "phone"
    t.string   "relationship"
    t.string   "password"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
  end

end
