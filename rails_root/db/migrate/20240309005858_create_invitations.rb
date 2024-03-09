class CreateInvitations < ActiveRecord::Migration[7.1]
  def change
    create_table :invitations do |t|
      t.references :survey_response, null: false, foreign_key: true
      t.references :created_by, null: false, foreign_key: { to_table: :survey_profiles }
      t.boolean :visited
      t.datetime :last_sent
      # TODO: (minseo) maybe good idea to have a datetime for visited timestamp?

      t.timestamps
    end
  end
end
