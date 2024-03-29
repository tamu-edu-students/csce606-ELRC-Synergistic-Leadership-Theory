# frozen_string_literal: true

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

# rubocop:disable Metrics/BlockLength
RSpec.describe '/survey_responses', type: :request do
  # This should return the minimal set of attributes required to create a valid
  # SurveyResponse. As you add validations to SurveyResponse, be sure to
  # adjust the attributes here as well.

  let(:survey_profile) do
    SurveyProfile.create!(
      user_id: 1,
      first_name: 'John',
      last_name: 'Doe',
      campus_name: 'Main',
      district_name: 'District'
    )
  end

  let(:survey_response) do
    SurveyResponse.create!(
      profile_id: survey_profile.id,
      share_code: '123'
    )
  end

  let(:valid_attributes) do
    {
      profile_id: survey_profile.user_id
    }
  end

  let(:invalid_attributes) do
    # any value in form is null
    {
      profile_id: nil,
      share_code: 1
    }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      SurveyResponse.create! valid_attributes
      get survey_responses_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      survey_response = SurveyResponse.create! valid_attributes
      get survey_response_url(survey_response)
      expect(response).to be_successful
    end
  end

  describe 'GET /survey/page/' do
    context 'with valid parameters' do
      let!(:survey_question) do
        SurveyQuestion.create!(
          text: 'Question',
          section: 1
        )
      end

      it 'renders a successful response' do
        get survey_page_url(1)
        expect(response).to be_successful
      end
    end

    # context 'with invalid parameters' do
    #   it 'renders a successful response' do
    #     get survey_page_url(1)
    #     expect(response).to be_successful
    #   end
    # end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      survey_response = SurveyResponse.create! valid_attributes
      get edit_survey_response_url(survey_response)
      expect(response).to redirect_to(survey_page_url(1))
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      # creat new question to be in the database for the test
      let!(:survey_question) do
        SurveyQuestion.create!(
          text: 'Question',
          section: 1
        )
      end

      let(:create_response_attr) do
        {

          user_id: survey_profile.user_id, # replace with the ID of a valid user
          '1': 1
        }
      end
      it 'creates a new SurveyResponse' do
        expect do
          session[:user_id] = 1
          post survey_responses_url, params: { survey_response: create_response_attr }
        end.to change(SurveyResponse, :count).by(1)
      end

      it 'redirects to the created survey_response' do
        post survey_responses_url, params: { survey_response: create_response_attr }
        expect(response).to redirect_to(survey_response_url(SurveyResponse.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new SurveyResponse - bad attributes' do
        expect do
          post survey_responses_url, params: { survey_response: invalid_attributes }
        end.to_not change(SurveyResponse, :count)
      end

      it 'does not create a new SurveyResponse - bad user' do
        invalid_attributes[:profile_id] = 100_000
        expect do
          post survey_responses_url, params: { survey_response: invalid_attributes }
        end.to_not change(SurveyResponse, :count)
      end

      it 'returns a failure response (i.e., to display the "new" template)' do
        post survey_responses_url, params: { survey_response: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  # removed because it is not used in the application
  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:survey_question) do
        SurveyQuestion.create!(
          text: 'Question',
          explanation: 'Explanation',
          section: 1
        )
      end

      let(:new_attributes) do
        {
          user_id: survey_profile.user_id,
          survey_question.id => 2
        }
      end

      it 'updates the requested survey_response answers' do
        survey_answer = SurveyAnswer.create!(
          choice: 1,
          question: survey_question,
          response: survey_response
        )

        patch survey_response_url(survey_response), params: { survey_response: new_attributes }
        survey_answer.reload
        expect(survey_answer.choice).to eq(2)
      end

      it 'redirects to the survey_response' do
        SurveyAnswer.create!(
          choice: 1,
          question: survey_question,
          response: survey_response
        )

        patch survey_response_url(survey_response), params: { survey_response: new_attributes }
        survey_response.reload
        expect(response).to redirect_to(survey_response_url(survey_response))
      end
    end

    context 'with invalid parameters' do
      it 'responds with status 422 for nil input' do
        invalid_response = {
          :user_id => nil,
          '1' => 1
        }

        survey_response = SurveyResponse.create! valid_attributes
        patch survey_response_url(survey_response), params: { survey_response: invalid_response }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with status 422 for invalid user id' do
        invalid_response = {
          :user_id => -1,
          '1' => 1
        }

        survey_response = SurveyResponse.create! valid_attributes
        patch survey_response_url(survey_response), params: { survey_response: invalid_response }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested survey_response' do
      survey_response = SurveyResponse.create! valid_attributes
      expect do
        delete survey_response_url(survey_response)
      end.to change(SurveyResponse, :count).by(-1)
    end

    it 'redirects to the survey_responses list' do
      survey_response = SurveyResponse.create! valid_attributes
      delete survey_response_url(survey_response)
      expect(response).to redirect_to(survey_responses_url)
    end
  end
end
# rubocop:enable Metrics/BlockLength
