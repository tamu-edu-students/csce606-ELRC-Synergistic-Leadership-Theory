class CreateSurveyAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :survey_answers do |t|
      t.integer :choice, null: false
      t.references :question, null: false, foreign_key: { to_table: :survey_questions }
      t.references :response, null: false, foreign_key: { to_table: :survey_responses }

      t.timestamps
    end
  end
end
