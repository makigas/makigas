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

ActiveRecord::Schema.define(version: 2020_05_18_194042) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "links", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "description", null: false
    t.string "url", null: false
    t.bigint "video_id", null: false
    t.index ["video_id"], name: "index_links_on_video_id"
  end

  create_table "opinions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "from", null: false
    t.string "message", null: false
    t.string "url"
    t.string "photo_file_name", null: false
    t.string "photo_content_type", null: false
    t.bigint "photo_file_size", null: false
    t.datetime "photo_updated_at", null: false
  end

  create_table "playlists", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.string "youtube_id", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "topic_id"
    t.string "thumbnail_file_name"
    t.string "thumbnail_content_type"
    t.bigint "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.string "card_file_name"
    t.string "card_content_type"
    t.bigint "card_file_size"
    t.datetime "card_updated_at"
    t.index ["slug"], name: "index_playlists_on_slug", unique: true
  end

  create_table "topics", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.string "description", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "thumbnail_file_name"
    t.string "thumbnail_content_type"
    t.bigint "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.string "color"
    t.index ["slug"], name: "index_topics_on_slug", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.string "youtube_id", null: false
    t.integer "duration", null: false
    t.string "slug", null: false
    t.integer "playlist_id", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "unfeatured", default: false, null: false
    t.datetime "published_at", null: false
    t.boolean "private", default: false, null: false
    t.index ["slug"], name: "index_videos_on_slug"
    t.index ["youtube_id"], name: "index_videos_on_youtube_id", unique: true
  end

end
