class AddTokenToInvitations < ActiveRecord::Migration[7.1]
  def change
    add_column :invitations, :token, :string
  end
end
