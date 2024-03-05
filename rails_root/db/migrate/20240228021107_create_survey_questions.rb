class CreateSurveyQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :survey_questions do |t|
      t.text :text, null: false
      t.text :explanation
      t.integer :section, null: false

      t.timestamps
    end
  end
end
