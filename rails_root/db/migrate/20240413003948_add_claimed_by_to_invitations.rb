class AddClaimedByToInvitations < ActiveRecord::Migration[7.1]
  def change
    add_reference :invitations, :claimed_by, foreign_key: { to_table: :survey_profiles }, null: true
  end
end
