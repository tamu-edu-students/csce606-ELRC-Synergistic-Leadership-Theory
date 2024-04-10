class AddRoleToSurveyProfile < ActiveRecord::Migration[7.1]
  def change
    add_column :survey_profiles, :role, :integer, default: 0
  end
end
