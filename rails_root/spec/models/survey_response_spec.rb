# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
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

      @question = SurveyQuestion.where(id: 1).first || SurveyQuestion.create!(question_params)
      @profile = SurveyProfile.where(user_id: 1).first || SurveyProfile.create!(profile_params)
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

      expect { SurveyResponse.create_from_params params[:user_id], params }.not_to raise_error
    end

    it 'returns nil with invalid params' do
      params = {
        :user_id => nil,
        '1' => 0
      }
      expect(SurveyResponse.create_from_params(params[:user_id], params)).to be_nil
    end

    it 'updating from valid params' do
      params = {
        :user_id => 1,
        '1' => 4
      }

      response = SurveyResponse.create_from_params params[:user_id], params
      params['1'] = 5

      response.update_from_params params[:user_id], params
      answer = response.answers.where(question: @question).first!

      expect(answer.choice).to eq(5)
    end

    it 'updating from invalid params' do
      params = {
        :user_id => 1,
        '1' => 4
      }

      response = SurveyResponse.create_from_params params[:user_id], params
      expect do
        params['1'] = nil
        response.update_from_params params[:user_id], params
      end.to raise_error ActiveRecord::NotNullViolation
    end
  end
end
# rubocop:enable Metrics/BlockLength
