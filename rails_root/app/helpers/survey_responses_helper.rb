# frozen_string_literal: true

# Helper methods for the survey responses controller
module SurveyResponsesHelper
  # method to calculate the average score of a survey response
  def average_score(survey_response)
    # returns the average score of the survey response
    survey_response.answers.average(:choice).to_f
  end

  # method to format the date of a survey response
  def formatted_date(survey_response)
    survey_response.created_at.strftime('%B %d, %Y')
  end

  #  method to find the user of a survey response
  def user_of_response(survey_response)
    # returns profile_id of the survey response
    survey_response.profile_id
  end

  def average_of_teachers(survey_response)
    # returns the average score of the teachers
    @survey_responses = find_teachers(survey_response)
    total_scores = Array.new(97, nil)

    n = @survey_responses.length
    return nil if n.zero?

    @survey_responses.each do |response|
      response.answers.each do |ans|
        total_scores[ans.question_id] = 0 if total_scores[ans.question_id].nil?
        total_scores[ans.question_id] += ans.choice.to_f / n
      end
    end
    total_scores
  end

  def find_superintendent(survey_response)
    @survey_profiles = SurveyProfile.where(role: 'Superintendent')
    @survey_profiles_id = @survey_profiles.map(&:id)
    @survey_responses = SurveyResponse.find_by(share_code: survey_response.share_code, profile_id: @survey_profiles_id)
  end

  def find_teachers(survey_response)
    @survey_profiles = SurveyProfile.where(role: 'Teacher')
    @survey_profiles_id = @survey_profiles.map(&:id)
    @survey_responses = SurveyResponse.where(share_code: survey_response.share_code, profile_id: @survey_profiles_id)
  end

  def get_answer(survey_response, question_id)
    @survey_answer = survey_response.answers.where(question_id:).first!

    @survey_answer.choice
  rescue StandardError
    nil
  end

  def answers_L1(principal_survey_response, other_survey_response)
    other_answers = other_survey_response.answers

    parts = [
      [1, 2],
      [3],
      [4],
      [5, 6]
    ]

    # sections = SurveyQuestion.all.map(&:section).uniq
    answers = parts.each_with_index.map do |sections, part|
      principal_answers = principal_survey_response.answers.select { |ans| sections.include? ans.question.section }
      other_answers = other_survey_response.answers.select { |ans| sections.include? ans.question.section }

      [part, [principal_answers, other_answers]]
    end

    # [[section_id, [principal answers, other answers]], ...]

    answers.map do |part, ans|
      principal_answers, other_answers = ans

      principal_answers.each_with_index.map { |x, i| (x - other_answers[i]).abs }
    end
  end
end
