json.extract! survey_question, :id, :text, :explanation, :section, :created_at, :updated_at
json.url survey_question_url(survey_question, format: :json)
