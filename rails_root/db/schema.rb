# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_240_309_005_858) do
  create_table 'invitations', force: :cascade do |t|
    t.integer 'survey_response_id', null: false
    t.integer 'created_by_id', null: false
    t.boolean 'visited'
    t.datetime 'last_sent'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['created_by_id'], name: 'index_invitations_on_created_by_id'
    t.index ['survey_response_id'], name: 'index_invitations_on_survey_response_id'
  end

  create_table 'survey_answers', force: :cascade do |t|
    t.integer 'choice', null: false
    t.integer 'question_id', null: false
    t.integer 'response_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['question_id'], name: 'index_survey_answers_on_question_id'
    t.index ['response_id'], name: 'index_survey_answers_on_response_id'
  end

  create_table 'survey_profiles', force: :cascade do |t|
    t.integer 'user_id', null: false
    t.string 'first_name'
    t.string 'last_name'
    t.string 'campus_name'
    t.string 'district_name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_survey_profiles_on_user_id', unique: true
  end

  create_table 'survey_questions', force: :cascade do |t|
    t.text 'text', null: false
    t.text 'explanation'
    t.integer 'section', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'survey_responses', force: :cascade do |t|
    t.string 'share_code'
    t.integer 'profile_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['profile_id'], name: 'index_survey_responses_on_profile_id'
  end

  add_foreign_key 'invitations', 'survey_profiles', column: 'created_by_id'
  add_foreign_key 'invitations', 'survey_responses'
  add_foreign_key 'survey_answers', 'survey_questions', column: 'question_id'
  add_foreign_key 'survey_answers', 'survey_responses', column: 'response_id'
  add_foreign_key 'survey_responses', 'survey_profiles', column: 'profile_id'
end
