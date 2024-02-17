# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe '/survey_responses', type: :request do
  let(:valid_attributes) do
    {
      user_id: 1,
      leads_by_example: 1,
      ability_to_juggle: 1,
      communicator: 1,
      lifelong_learner: 1,
      high_expectations: 1,
      cooperative: 1,
      empathetic: 1,
      people_oriented: 1
    }
  end

  let(:invalid_attributes) do
    {
      user_id: 1,
      leads_by_example: 1,
      ability_to_juggle: nil,
      communicator: 1,
      lifelong_learner: 1,
      high_expectations: 1,
      cooperative: 1,
      empathetic: 1,
      people_oriented: nil
    }
  end

  let(:new_attributes) do
    {
      leads_by_example: 5
    }
  end

  let!(:survey_response) { SurveyResponse.create! valid_attributes }

  describe 'GET /index' do
    before { get survey_responses_url }

    it 'renders a successful response' do
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    before { get survey_response_url(survey_response) }

    it 'renders a successful response' do
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    before { get new_survey_response_url }

    it 'renders a successful response' do
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    before { get edit_survey_response_url(survey_response) }

    it 'renders a successful response' do
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      def post_request
        post survey_responses_url, params: { survey_response: valid_attributes }
      end

      it 'creates a new SurveyResponse' do
        expect { post_request }.to change(SurveyResponse, :count).by(1)
      end

      it 'redirects to the created survey_response' do
        post_request
        expect(response).to redirect_to(survey_response_url(SurveyResponse.last))
      end
    end

    context 'with invalid parameters' do
      def post_request
        post survey_responses_url, params: { survey_response: invalid_attributes }
      end

      it 'does not create a new SurveyResponse' do
        expect { post_request }.to_not change(SurveyResponse, :count)
      end

      it 'returns a failure response (i.e., to display the "new" template)' do
        post_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      before do
        patch survey_response_url(survey_response), params: { survey_response: new_attributes }
        survey_response.reload
      end

      it 'updates the requested survey_response' do
        expect(survey_response.leads_by_example).to eq(5)
      end

      it 'redirects to the survey_response' do
        expect(response).to redirect_to(survey_response_url(survey_response))
      end
    end

    context 'with invalid parameters' do
      before do
        patch survey_response_url(survey_response), params: { survey_response: invalid_attributes }
      end

      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested survey_response' do
      expect do
        delete survey_response_url(survey_response)
      end.to change(SurveyResponse, :count).by(-1)
    end

    it 'redirects to the survey_responses list' do
      delete survey_response_url(survey_response)
      expect(response).to redirect_to(survey_responses_url)
    end
  end
end
# rubocop:enable Metrics/BlockLength
