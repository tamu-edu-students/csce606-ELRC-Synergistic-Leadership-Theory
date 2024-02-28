class EditSurveyResponses < ActiveRecord::Migration[7.1]
  def change
    drop_table :survey_responses

    create_table :survey_responses do |t|
      t.string :share_code
      t.references :profile, null: false, foreign_key: { to_table: :survey_profiles }

      t.timestamps
    end
  end
end
