# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SurveyResponsesHelper. For example:
#
# describe SurveyResponsesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end

# rubocop:disable Metrics/BlockLength

RSpec.describe SurveyResponsesHelper, type: :helper do
  # create other models necessary for testing survey_responses_helper

  let(:survey_profile) do
    SurveyProfile.create!(
      user_id: 1,
      first_name: 'John',
      last_name: 'Doe',
      campus_name: 'Main',
      district_name: 'District',
      role: 'Principal'
    )
  end

  let(:survey_response) do
    SurveyResponse.create!(
      profile_id: survey_profile.id,
      share_code: '123456'
    )
  end

  let(:survey_question) do
    SurveyQuestion.create!(
      text: 'Question',
      section: 1
    )
  end
  let(:survey_profile2) do
    SurveyProfile.create!(
      user_id: 2,
      first_name: 'John',
      last_name: 'Wick',
      campus_name: 'Main',
      district_name: 'District',
      role: 'Supervisee'
    )
  end
  let(:survey_profile3) do
    SurveyProfile.create!(
      user_id: 3,
      first_name: 'John',
      last_name: 'Lennon',
      campus_name: 'Main',
      district_name: 'District',
      role: 'Supervisor'
    )
  end
  let(:survey_profile4) do
    SurveyProfile.create!(
      user_id: 4,
      first_name: 'John',
      last_name: 'Lewis',
      campus_name: 'Main',
      district_name: 'District',
      role: 'Supervisee'
    )
  end
  let(:survey_response2) do
    SurveyResponse.create!(
      profile_id: survey_profile2.id,
      share_code: '123456'
    )
  end
  let(:survey_response3) do
    SurveyResponse.create!(
      profile_id: survey_profile3.id,
      share_code: '123456'
    )
  end
  let(:survey_response4) do
    SurveyResponse.create!(
      profile_id: survey_profile4.id,
      share_code: '123456'
    )
  end
  let(:survey_answers) do
    SurveyAnswer.create!(
      choice: 4,
      question_id: survey_question.id,
      response_id: survey_response.id
    )
    SurveyAnswer.create!(
      choice: 3,
      question_id: survey_question.id,
      response_id: survey_response2.id
    )
    SurveyAnswer.create!(
      choice: 2,
      question_id: survey_question.id,
      response_id: survey_response3.id
    )
    SurveyAnswer.create!(
      choice: 1,
      question_id: survey_question.id,
      response_id: survey_response4.id
    )
  end

  describe '#average_score' do
    it 'returns the average score of a survey response' do
      # returns average score of the survey response answers
      expect(helper.average_score(survey_response)).to eq(survey_response.answers.average(:choice).to_f)
    end

    it 'returns nil when response has no answers' do
      expect(helper.average_score(survey_response)).to eq(0.0)
    end
  end

  describe '#formatted_date' do
    it 'returns the formatted date of a survey response' do
      expect(helper.formatted_date(survey_response)).to eq(survey_response.created_at.strftime('%B %d, %Y'))
    end
  end

  describe '#user_of_response' do
    it 'returns the user of a survey response' do
      expect(helper.user_of_response(survey_response)).to eq(survey_response.profile_id)
    end

    it 'returns nil if the survey response does not have a user' do
      survey_response.update(profile_id: nil)
      expect(helper.user_of_response(survey_response)).to eq(nil)
    end
  end

  describe '#supervisee_average_by_part' do
    it 'returns a list of average responses for each question for each supervisee survey response grouped by part' do
      survey_answers

      expected = [{ 1 => 2.0 }, {}, {}, {}]

      expect(helper.supervisee_average_by_part(survey_response)).to eq expected
    end

    it 'returns a list of empty hashes when response has no corresponding supervisees' do
      expected = [{}, {}, {}, {}]
      expect(helper.supervisee_average_by_part(survey_response)).to eq expected
    end
  end

  describe '#average_of_supervisees' do
    it 'returns a list of average responses for each question for each supervisee survey response' do
      # returns average score of the survey response answers
      survey_answers
      averages = Array.new(97, nil)
      averages[1] = 2.0
      expect(helper.average_of_supervisees(survey_response)).to eq(averages)
    end

    it 'return nil when no corresponding supervisees' do
      expect(helper.average_of_supervisees(survey_response)).to eq(nil)
    end
  end

  describe '#find_supervisees' do
    it 'returns survey responses of supervisees having same share code with principal' do
      survey_answers
      ids = []
      supervisees_responses = helper.find_supervisees(survey_response)
      supervisees_responses.each do |response|
        ids.append(response.id)
      end
      expect(ids).to eq([2, 4])
    end

    it 'returns an empty array if no supervisee responses exist' do
      expect(helper.find_supervisees(survey_response).pluck(:id)).to eq([])
    end
  end

  describe '#find_supervisor' do
    it 'returns survey responses of supervisor having same share code with principal' do
      survey_answers
      expect(helper.find_supervisor(survey_response).id).to eq(3)
    end

    it 'returns nil if no supervisor response exists' do
      survey_response3.destroy
      expect(helper.find_supervisor(survey_response)).to eq(nil)
    end
  end

  describe '#get_answer' do
    it 'returns the answer with certain id of response' do
      survey_answers
      expect(helper.get_answer(survey_response, 1)).to eq(4)
    end
    it 'returns nil if the survey response not exist' do
      expect(helper.get_answer(nil, 1)).to eq(nil)
    end
    it 'returns nil if no answer certain id exists' do
      expect(helper.get_answer(survey_response, 1)).to eq(nil)
    end
  end

  describe '#get_part_difference' do
    it 'returns the average difference in choices by part compared to the supervisor' do
      survey_answers
      other_response = helper.find_supervisor(survey_response)
      expect(helper.get_part_difference(survey_response, other_response)).to eq([0, 0, 0, 0])
    end
  end

  describe '#get_supervisee_part_difference' do
    it 'returns a list the average difference in choices by part against the average supervisee' do
      survey_answers

      expected = [0, 0, 0, 0]
      expect(helper.get_supervisee_part_difference(survey_response)).to eq expected
    end

    it 'returns 0 for parts with no supervisee answers' do
      empty_response = SurveyResponse.create!(profile_id: survey_profile.id, share_code: '654321')
      expect(helper.get_supervisee_part_difference(empty_response)).to eq([0, 0, 0, 0])
    end
  end
end

# rubocop:enable Metrics/BlockLength
