class EditSurveyProfiles < ActiveRecord::Migration[7.1]
  def change
    change_column_null :survey_profiles, :user_id, false
  end
end
