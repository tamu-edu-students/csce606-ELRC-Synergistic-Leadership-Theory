class RemoveCreatedByFromInvitations < ActiveRecord::Migration[7.1]
  def change
    remove_column :invitations, :created_by_id, :integer
  end
end
