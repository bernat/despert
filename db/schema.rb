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

ActiveRecord::Schema.define(:version => 20110605130537) do

  create_table "attachments", :force => true do |t|
    t.text     "description"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_id"
    t.string   "author"
    t.string   "attach"
  end

  create_table "clients", :force => true do |t|
    t.string   "name",                              :null => false
    t.text     "information"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "codename"
    t.string   "phone"
    t.string   "address"
    t.string   "email"
    t.string   "nif"
    t.string   "secondary_phone"
    t.string   "lang",            :default => "ca", :null => false
    t.string   "billing_name"
    t.string   "bank_name"
    t.string   "bank_account"
  end

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "commentable_id"
    t.string   "commentable_type"
  end

  create_table "cyberpac_responses", :force => true do |t|
    t.string  "Ds_AuthorisationCode"
    t.string  "Ds_Hour"
    t.string  "Ds_SecurePayment"
    t.string  "Ds_Terminal"
    t.string  "Ds_Response"
    t.string  "Ds_Currency"
    t.string  "Ds_ErrorCode"
    t.string  "Ds_MerchantCode"
    t.string  "Ds_Amount"
    t.string  "Ds_ConsumerLanguage"
    t.string  "Ds_Signature"
    t.string  "Ds_Order"
    t.string  "Ds_Date"
    t.string  "Ds_TransactionType"
    t.string  "Ds_MerchantData"
    t.string  "origin_type"
    t.integer "origin_id"
    t.string  "Ds_Card_Country"
    t.string  "Ds_Card_Type"
    t.string  "Ds_PayMethod"
    t.string  "Ds_SumTotal"
    t.string  "Ds_MerchantPartialPayment"
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

  create_table "event_timers", :force => true do |t|
    t.string   "subject_type"
    t.integer  "subject_id"
    t.datetime "run_at"
  end

  create_table "events", :force => true do |t|
    t.string   "event_type"
    t.string   "subject_type"
    t.string   "actor_type"
    t.string   "context_type"
    t.integer  "subject_id"
    t.integer  "actor_id"
    t.integer  "context_id"
    t.datetime "created_at"
    t.string   "subdescrip"
    t.boolean  "published",       :default => false
    t.string   "author"
    t.string   "background_type"
    t.integer  "background_id"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ref",         :null => false
    t.string   "color"
    t.string   "email"
  end

  create_table "invoices", :force => true do |t|
    t.string   "concept",                               :null => false
    t.float    "base",                                  :null => false
    t.float    "iva",                 :default => 0.18, :null => false
    t.integer  "project_id"
    t.date     "payment_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.datetime "last_sent_at"
    t.string   "author_type"
    t.integer  "author_id"
    t.integer  "transaction_version", :default => 0,    :null => false
    t.string   "billing_name"
    t.string   "billing_cif"
    t.string   "billing_address"
    t.string   "billing_town"
    t.string   "billing_zip"
    t.string   "billing_province"
    t.string   "billing_country"
    t.string   "number"
    t.date     "issue_date"
  end

  create_table "memberships", :id => false, :force => true do |t|
    t.integer "project_id"
    t.integer "employee_id"
  end

  create_table "messages", :force => true do |t|
    t.string   "subject"
    t.text     "body",                              :null => false
    t.integer  "user_id"
    t.integer  "project_id",                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "author"
    t.boolean  "html",           :default => false
    t.boolean  "from_email",     :default => false
    t.integer  "comments_count"
  end

  create_table "milestones", :force => true do |t|
    t.string   "name",                              :null => false
    t.date     "finishes_at",                       :null => false
    t.integer  "project_id",                        :null => false
    t.boolean  "completed",      :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count"
  end

  create_table "page_translations", :force => true do |t|
    t.integer  "page_id"
    t.string   "locale"
    t.text     "content"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_translations", ["page_id"], :name => "index_page_translations_on_page_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "permalink",                 :null => false
    t.text     "content"
    t.integer  "ordre",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["permalink"], :name => "index_pages_on_permalink", :unique => true

  create_table "payments", :force => true do |t|
    t.integer  "ref"
    t.datetime "payment_date",                  :null => false
    t.string   "concept",                       :null => false
    t.float    "base",                          :null => false
    t.float    "iva",          :default => 0.0, :null => false
    t.integer  "supplier_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attach"
    t.integer  "employee_id"
  end

  create_table "project_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "monthly_fee", :default => 0.0,   :null => false
    t.boolean  "internal",    :default => false, :null => false
    t.string   "color"
  end

  create_table "projects", :force => true do |t|
    t.string   "name",                                   :null => false
    t.date     "starting_date",                          :null => false
    t.integer  "client_id"
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_type_id",     :default => 0
    t.string   "ref",                 :default => "",    :null => false
    t.integer  "manager_id",                             :null => false
    t.string   "comercial_extern"
    t.string   "state"
    t.string   "contract"
    t.integer  "status",              :default => 0,     :null => false
    t.text     "status_description"
    t.boolean  "variable",            :default => false, :null => false
    t.string   "production_hostname"
    t.float    "variable_part"
    t.float    "total_hours"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "subscriptions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.integer  "billing_day"
    t.float    "iva"
    t.float    "base"
    t.string   "concept"
  end

  create_table "suppliers", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.integer  "phone"
    t.string   "email"
    t.string   "nif"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "task_lists", :force => true do |t|
    t.string   "name",                            :null => false
    t.integer  "project_id",                      :null => false
    t.integer  "milestone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.boolean  "archived",     :default => false, :null => false
    t.float    "hours"
    t.text     "description"
  end

  add_index "task_lists", ["project_id"], :name => "index_task_lists_on_project_id"

  create_table "tasks", :force => true do |t|
    t.text     "description"
    t.datetime "completed_at"
    t.integer  "task_list_id",                      :null => false
    t.integer  "employee_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "duration",       :default => 0.0,   :null => false
    t.string   "title"
    t.integer  "position"
    t.integer  "comments_count", :default => 0,     :null => false
    t.boolean  "closed",         :default => false
  end

  add_index "tasks", ["task_list_id"], :name => "index_tasks_on_task_list_id"

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "email"
    t.string   "password_salt",                                :null => false
    t.boolean  "admin"
    t.string   "phone"
    t.integer  "group_id"
    t.string   "skype"
    t.boolean  "receive_emails",       :default => true
    t.integer  "client_id"
    t.string   "type"
    t.string   "bank_name"
    t.string   "bank_account"
    t.string   "billing_cif"
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "secondary_phone"
    t.string   "lang",                 :default => "ca",       :null => false
    t.string   "role",                 :default => "employee", :null => false
    t.string   "username"
    t.string   "billing_name"
    t.string   "billing_address"
    t.string   "billing_town"
    t.string   "billing_zip"
    t.string   "billing_province"
    t.string   "billing_country"
    t.float    "variable_part",        :default => 0.0,        :null => false
  end

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.string   "concept"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

  create_table "wages", :force => true do |t|
    t.string   "concept"
    t.float    "base"
    t.float    "iva"
    t.float    "ret"
    t.integer  "employee_id"
    t.string   "billing_name"
    t.string   "billing_cif"
    t.string   "billing_address"
    t.string   "billing_town"
    t.string   "billing_zip"
    t.string   "billing_province"
    t.string   "billing_country"
    t.string   "number"
    t.date     "issue_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
