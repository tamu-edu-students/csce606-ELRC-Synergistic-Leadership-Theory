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

  def supervisee_average_by_part(response)
    parts = [
      [0, 1],
      [2],
      [3],
      [4, 5]
    ]

    supervisee_responses = find_supervisees(response)

    parts.map do |sections|
      answers = {}
      supervisee_responses.each do |res|
        res.answers.select { |ans| sections.include? ans.question.section }.each do |ans|
          answers[ans.question_id] = (answers[ans.question_id] || 0) + ans.choice
        end
      end

      answers.transform_values! { |v| v.to_f / supervisee_responses.length }
    end
  end

  def average_of_supervisees(response)
    # returns the average score of the supervisees
    supervisee_responses = find_supervisees(response)
    total_scores = Array.new(97, nil)

    return nil if supervisee_responses.empty?

    n = supervisee_responses.length
    supervisee_responses.each do |res|
      res.answers.each do |ans|
        total_scores[ans.question_id] = (total_scores[ans.question_id] || 0) + (ans.choice.to_f / n)
      end
    end

    total_scores
  end

  def find_supervisor(response)
    SurveyResponse.joins(:profile).where(share_code: response.share_code, profile: { role: 'Supervisor' }).first!
  rescue StandardError
    nil
  end

  def find_supervisees(response)
    SurveyResponse.joins(:profile).where(share_code: response.share_code, profile: { role: 'Supervisee' })
  rescue StandardError
    nil
  end

  def get_answer(response, question_id)
    response.answers.where(question_id:).first!.choice
  rescue StandardError
    nil
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def get_supervisee_part_difference(response)
    parts = [
      [0, 1],
      [2],
      [3],
      [4, 5]
    ]

    supervisee_avgs = supervisee_average_by_part(response)

    parts.each_with_index.map do |sections, idx|
      answers = response.answers.select { |ans| sections.include? ans.question.section }
      supervisee_answers = supervisee_avgs[idx]

      if answers.empty?
        # puts "No answers for part #{idx + 1}"
        0
      else
        difference = 0
        nonempty_answers = answers.select { |ans| !ans.choice.nil? }

        nonempty_answers.each do |x|
          supervisee_choice = supervisee_answers[x.question_id]
          difference += (x.choice - supervisee_choice).abs unless supervisee_choice.nil?
        end

        length = nonempty_answers.length - supervisee_answers.select { |_, v| v.nil? }.length

        (difference.to_f / length).round
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
        nonempty_answers = answers.select { |ans| !ans.choice.nil? }
        nonempty_answers.each do |x|
          other_choice = other_answers.detect { |y| x.question_id == y.question_id }
          difference += (x.choice - other_choice.choice).abs unless (other_choice.nil?)
        end

        length = nonempty_answers.length - other_answers.select { |ans| ans.choice.nil? }.length
        (difference.to_f / length).round
      end
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
end
