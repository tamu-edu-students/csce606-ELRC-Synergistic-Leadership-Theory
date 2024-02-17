# frozen_string_literal: true

# rubocop:disable Style/Documentation

class CreateSurveyProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :survey_profiles do |t|
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :campus_name
      t.string :district_name

      t.timestamps
    end
    add_index :survey_profiles, :user_id, unique: true
  end
end
# rubocop:enable Style/Documentation
