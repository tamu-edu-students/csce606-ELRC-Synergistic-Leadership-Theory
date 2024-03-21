# frozen_string_literal: true

require 'rails_helper'

# RSpec.describe SurveyResponse, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
RSpec.describe SurveyResponse, type: :model do
  context 'with valid params' do
    before do
      profile_params = {
        user_id: 1,
        first_name: 'John',
        last_name: 'Doe',
        campus_name: 'College Station',
        district_name: 'Texas A&M'
      }

      question_params = {
        text: 'text',
        explanation: 'explanation',
        section: 0
      }

      @question = SurveyQuestion.where(id: 1).first() || SurveyQuestion.create!(question_params)
      @profile = SurveyProfile.where(user_id: 1).first() || SurveyProfile.create!(profile_params)
    end

    after do
      @profile.destroy
      @question.destroy
    end

    it 'creates from valid params' do
      params = {
        :user_id => 1,
        '1' => 0
      }

      expect { SurveyResponse.create_from_params params }.not_to raise_error
    end

    it 'creating raises exception with invalid params' do
      params = {
        :user_id => nil,
        '1' => 0
      }

      expect { SurveyResponse.create_from_params params }.to raise_error
    end

    it 'updating from valid params' do
      params = {
        :user_id => 1,
        '1' => 4
      }

      response = SurveyResponse.create_from_params params
      params['1'] = 5

      response.update_from_params params
      answer = response.answers.where(question: @question).first!

      expect(answer.choice).to eq(5)
    end

    it 'updating from invalid params' do
      params = {
        :user_id => 1,
        '1' => 4
      }

      response = SurveyResponse.create_from_params params
      expect {
        params['1'] = nil
        response.update_from_params params
      }.to raise_error
    end
  end
end
