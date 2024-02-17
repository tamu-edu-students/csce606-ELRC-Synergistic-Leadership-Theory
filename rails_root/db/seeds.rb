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
                        { user_id: 1, first_name: 'John', last_name: 'Doe', campus_name: 'Campus 1',
                          district_name: 'District 1' },
                        { user_id: 2, first_name: 'Jane', last_name: 'Doe', campus_name: 'Campus 2',
                          district_name: 'District 2' },
                        { user_id: 3, first_name: 'Jim', last_name: 'Doe', campus_name: 'Campus 3',
                          district_name: 'District 3' }
                      ])

# seed data for the survey_responses table

SurveyResponse.create!([
                         { user_id: 1, leads_by_example: 5, ability_to_juggle: 5, communicator: 5, lifelong_learner: 5, high_expectations: 5,
                           cooperative: 5, empathetic: 5, people_oriented: 5 },
                         { user_id: 2, leads_by_example: 4, ability_to_juggle: 4, communicator: 4, lifelong_learner: 4, high_expectations: 4,
                           cooperative: 4, empathetic: 4, people_oriented: 4 },
                         { user_id: 3, leads_by_example: 3, ability_to_juggle: 3, communicator: 3, lifelong_learner: 3, high_expectations: 3,
                           cooperative: 3, empathetic: 3, people_oriented: 3 }
                       ])
# rubocop:enable Layout/LineLength

# Path: csce606-ELRC-Synergistic-Leadership-Theory/rails_root/db/schema.rb
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new
