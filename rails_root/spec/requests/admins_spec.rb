# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminsController, type: :controller do
  describe 'GET #index' do
    context 'when user is an admin' do
      before do
        allow(controller).to receive(:user_is_admin?).and_return(true)
      end

      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'assigns @survey_responses' do
        survey_responses = double('survey_responses')
        allow(SurveyResponse).to receive(:get_all_responses).and_return(survey_responses)
        get :index
        expect(assigns(:survey_responses)).to eq(survey_responses)
      end

      it 'calls SurveyResponse.get_all_responses with correct parameters' do
        expect(SurveyResponse).to receive(:get_all_responses).with(page: nil, per_page: 20)
        get :index
      end
    end

    context 'when user is not an admin' do
      before do
        allow(controller).to receive(:user_is_admin?).and_return(false)
      end

      it 'redirects to root_url for HTML format' do
        get :index
        expect(response).to redirect_to(root_url)
      end

      it 'sets a notice message for HTML format' do
        get :index
        expect(flash[:notice]).to eq('You cannot view this result.')
      end
    end
  end
end
