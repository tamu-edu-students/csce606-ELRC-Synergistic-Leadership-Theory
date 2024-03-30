class RenameSurveyResponseIdAndAddResponseIdToInvitations < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :invitations, column: :survey_response_id
    rename_column :invitations, :survey_response_id, :parent_response_id
    add_foreign_key :invitations, :survey_responses, column: :parent_response_id

    add_column :invitations, :response_id, :integer
    add_foreign_key :invitations, :survey_responses, column: :response_id
  end
end
