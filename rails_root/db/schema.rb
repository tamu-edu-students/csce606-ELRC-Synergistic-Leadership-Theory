# frozen_string_literal: true

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

# rubocop:disable Metrics/BlockLength
ActiveRecord::Schema[7.1].define(version: 20_240_217_001_343) do
  create_table 'posts', force: :cascade do |t|
    t.string 'title'
    t.text 'body'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'survey_profiles', force: :cascade do |t|
    t.integer 'user_id'
    t.string 'first_name'
    t.string 'last_name'
    t.string 'campus_name'
    t.string 'district_name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_survey_profiles_on_user_id', unique: true
  end

  create_table 'survey_responses', force: :cascade do |t|
    t.integer 'user_id'
    t.integer 'leads_by_example'
    t.integer 'ability_to_juggle'
    t.integer 'communicator'
    t.integer 'lifelong_learner'
    t.integer 'high_expectations'
    t.integer 'cooperative'
    t.integer 'empathetic'
    t.integer 'people_oriented'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_survey_responses_on_user_id'
  end
end
# rubocop:enable Metrics/BlockLength
