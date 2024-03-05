# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# seed data for the survey_profiles table

# rubocop:disable Layout/LineLength
SurveyProfile.create!([
                        { user_id: 5, first_name: 'John', last_name: 'Doe', campus_name: 'Campus 1',
                          district_name: 'District 1' },
                        { user_id: 6, first_name: 'Jane', last_name: 'Doe', campus_name: 'Campus 2',
                          district_name: 'District 2' },
                        { user_id: 7, first_name: 'Jim', last_name: 'Doe', campus_name: 'Campus 3',
                          district_name: 'District 3' }
                      ])

# seed data for the survey_responses table

SurveyProfile.all.each do |survey_profile|
  SurveyResponse.create!(profile: survey_profile, share_code: "debug#{survey_profile.user_id}")
end

question = SurveyQuestion.create!(text: "Leads by Example", explanation: "This is a placeholder.", section: 0)

SurveyResponse.all.each_with_index do |response, idx|
  SurveyAnswer.create!(choice: idx, question: question, response: response)
end

# rubocop:enable Layout/LineLength

# Path: csce606-ELRC-Synergistic-Leadership-Theory/rails_root/db/schema.rb
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new
