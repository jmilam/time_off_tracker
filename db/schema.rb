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

ActiveRecord::Schema.define(version: 20170601175132) do

  create_table "departments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "holidays", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "managers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "department_id"
    t.string   "name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "email"
  end

  create_table "status_changes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "time_off_request_id"
    t.string   "start_change"
    t.string   "end_change"
    t.datetime "date"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "time_off_requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "time_off_type"
    t.datetime "date_start"
    t.datetime "date_end"
    t.string   "approved_by"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "hours",         default: 0
    t.integer  "manager_id"
    t.boolean  "approved"
    t.boolean  "cancelled",     default: false
    t.string   "note"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                  default: "",                null: false
    t.string   "encrypted_password",     default: "",                null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                 null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.boolean  "admin",                  default: false
    t.integer  "vacation_total",         default: 0
    t.integer  "personal_total",         default: 0
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "department_id"
    t.boolean  "payroll",                default: false
    t.boolean  "account_manager",        default: false
    t.string   "site",                   default: "Endura Products"
    t.string   "locations",              default: "NC"
    t.boolean  "terminated",             default: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
