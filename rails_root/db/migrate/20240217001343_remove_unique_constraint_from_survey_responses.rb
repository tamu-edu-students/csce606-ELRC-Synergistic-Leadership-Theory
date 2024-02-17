class RemoveUniqueConstraintFromSurveyResponses < ActiveRecord::Migration[7.1]
  def change
    remove_index :survey_responses, name: 'index_survey_responses_on_user_id'
    add_index :survey_responses, :user_id
  end
end
