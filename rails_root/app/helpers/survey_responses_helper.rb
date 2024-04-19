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

  def teacher_average_by_part(response)
    parts = [
      [0, 1],
      [2],
      [3],
      [4, 5]
    ]

    teacher_responses = find_teachers(response)

    parts.map do |sections|
      answers = {}
      teacher_responses.each do |res|
        res.answers.select { |ans| sections.include? ans.question.section }.each do |ans|
          answers[ans.question_id] = (answers[ans.question_id] || 0) + ans.choice
        end
      end

      answers.transform_values! { |v| v.to_f / teacher_responses.length }
    end
  end

  def average_of_teachers(response)
    # returns the average score of the teachers
    teacher_responses = find_teachers(response)
    total_scores = Array.new(97, nil)

    return nil if teacher_responses.empty?

    n = teacher_responses.length
    teacher_responses.each do |res|
      res.answers.each do |ans|
        total_scores[ans.question_id] = (total_scores[ans.question_id] || 0) + (ans.choice.to_f / n)
      end
    end

    total_scores
  end

  def find_superintendent(response)
    SurveyResponse.joins(:profile).where(share_code: response.share_code, profile: { role: 'Superintendent' }).first!
  rescue StandardError
    nil
  end

  def find_teachers(response)
    SurveyResponse.joins(:profile).where(share_code: response.share_code, profile: { role: 'Teacher' })
  rescue StandardError
    nil
  end

  def get_answer(response, question_id)
    response.answers.where(question_id:).first!.choice
  rescue StandardError
    nil
  end

  def get_teacher_part_difference(response)
    parts = [
      [0, 1],
      [2],
      [3],
      [4, 5]
    ]

    teacher_avgs = teacher_average_by_part(response)

    parts.each_with_index.map do |sections, idx|
      answers = response.answers.select { |ans| sections.include? ans.question.section }
      teacher_answers = teacher_avgs[idx]

      if answers.empty?
        0
      else
        difference = 0

        answers.each do |x|
          teacher_choice = teacher_answers[x.question_id]
          difference += (x.choice - teacher_choice).abs unless teacher_choice.nil?
        end

        (difference.to_f / answers.length).round
      end
    end
  end

  def get_part_difference(response, other)
    parts = [
      [0, 1],
      [2],
      [3],
      [4, 5]
    ]

    parts.map do |sections|
      answers = response.answers.select { |ans| sections.include? ans.question.section }
      other_answers = other.answers.select { |ans| sections.include? ans.question.section }

      if answers.empty?
        0
      else
        difference = 0

        answers.each do |x|
          other_choice = other_answers.detect { |y| x.question_id == y.question_id }
          difference += (x.choice - other_choice.choice).abs unless other_choice.nil?
        end

        (difference.to_f / answers.length).round
      end
    end
  end
end
