class EditSurveyProfile < ActiveRecord::Migration[7.1]
  def change
    # make user_id now be a string
    change_column :survey_profiles, :user_id, :string, null: false
  end
end
