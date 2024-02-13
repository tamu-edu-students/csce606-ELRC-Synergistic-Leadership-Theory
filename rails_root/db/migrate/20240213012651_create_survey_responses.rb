class CreateSurveyResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :survey_responses do |t|
      t.integer :user_id
      t.integer :leads_by_example
      t.integer :ability_to_juggle
      t.integer :communicator
      t.integer :lifelong_learner
      t.integer :high_expectations
      t.integer :cooperative
      t.integer :empathetic
      t.integer :people_oriented

      t.timestamps
    end
    add_index :survey_responses, :user_id, unique: true
  end
end
