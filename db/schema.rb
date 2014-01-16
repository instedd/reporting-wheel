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

ActiveRecord::Schema.define(:version => 20140116204402) do

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

  create_table "local_gateways", :force => true do |t|
    t.integer  "user_id"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pools", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "submit_url_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "voice_channels", :force => true do |t|
    t.string   "number"
    t.string   "language"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wheel_records", :force => true do |t|
    t.integer  "wheel_id"
    t.string   "code"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "original"
    t.string   "decoded"
    t.text     "values"
  end

  create_table "wheel_rows", :force => true do |t|
    t.integer  "index"
    t.string   "label"
    t.integer  "wheel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "render_configuration"
  end

  create_table "wheel_values", :force => true do |t|
    t.integer  "index"
    t.string   "value"
    t.integer  "code"
    t.integer  "wheel_row_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wheels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "factors"
    t.string   "url_callback"
    t.string   "ok_text"
    t.text     "render_configuration"
    t.integer  "user_id"
    t.integer  "pool_id"
    t.boolean  "allow_free_text",      :default => false
  end

end
