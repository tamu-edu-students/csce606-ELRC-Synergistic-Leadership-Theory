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
      role: 'Teacher'
    )
  end
  let(:survey_profile3) do
    SurveyProfile.create!(
      user_id: 3,
      first_name: 'John',
      last_name: 'Lennon',
      campus_name: 'Main',
      district_name: 'District',
      role: 'Superintendent'
    )
  end
  let(:survey_profile4) do
    SurveyProfile.create!(
      user_id: 4,
      first_name: 'John',
      last_name: 'Lewis',
      campus_name: 'Main',
      district_name: 'District',
      role: 'Teacher'
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
  end

  describe '#average_of_teachers' do
    it 'returns a list of average scores of survey responses of teachers' do
      # returns average score of the survey response answers
      survey_answers
      averages = Array.new(97, 0.0)
      averages[1] = 2.0
      expect(helper.average_of_teachers(survey_response)).to eq(averages)
    end

    it 'return nil when no corresponding teachers' do
      expect(helper.average_of_teachers(survey_response)).to eq(nil)
    end
  end

  describe '#find_teachers' do
    it 'returns survey responses of teachers having same share code with principal' do
      survey_answers
      ids = []
      teachers_responses = helper.find_teachers(survey_response)
      teachers_responses.each do |response|
        ids.append(response.id)
      end
      expect(ids).to eq([2, 4])
    end
  end
  describe '#find_superintendent' do
    it 'returns survey responses of superintendent having same share code with principal' do
      survey_answers
      expect(helper.find_superintendent(survey_response).first.id).to eq(3)
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
end

# rubocop:enable Metrics/BlockLength
