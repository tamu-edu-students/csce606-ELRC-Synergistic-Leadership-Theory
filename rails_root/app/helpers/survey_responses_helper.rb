# frozen_string_literal: true

module SurveyResponsesHelper
  # method to calculate the average score of a survey response
  def average_score(survey_response)
    score_fields = %i[leads_by_example ability_to_juggle communicator lifelong_learner high_expectations
                      cooperative empathetic people_oriented]
    scores = score_fields.map { |field| survey_response.send(field) }
    scores.sum.to_f / scores.size
  end

  # method to format the date of a survey response
  def formatted_date(survey_response)
    survey_response.created_at.strftime('%B %d, %Y')
  end

  #  method to find the user of a survey response
  def user_of_response(survey_response)
    # returns user_id of the survey response
    survey_response.user_id
  end
end
