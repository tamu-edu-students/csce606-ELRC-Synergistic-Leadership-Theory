# spec/requests/survey_responses_spec.rb
require 'rails_helper'

RSpec.describe "SurveyResponses", type: :request do
    
    let(:survey_profile){ FactoryBot.create(:survey_profile)}
    let(:survey_response){ FactoryBot.create(:survey_response)}
    let(:survey_answer){ FactoryBot.create(:survey_answer)}
    let(:create_response_attr) do
    {
        '1': 1
    }
    end

    describe 'GET /index' do
        it 'renders a successful response' do
          get survey_responses_url
          expect(response).to be_successful
        end
      end

    describe 'GET /show/:id' do
        #TODO: show if user id matches
        it 'renders a successful response' do
            get survey_response_url(survey_response)
            expect(response).to be_successful
        end
    end

    describe "POST /create" do
        context "with valid parameters" do
        before do
            allow_any_instance_of(SurveyResponsesController).to receive(:session){ { user_id: survey_profile.user_id, page_number: 2} }
        end
    
          it "creates a new SurveyResponse" do
            expect {
              post survey_responses_path, params: { survey_response: create_response_attr }
            }.to change(SurveyResponse, :count).by(1)
          end
    
          it "redirects to the SurveyResponse edit page when click Next" do
            post survey_responses_path, params: { survey_response: create_response_attr, commit: "Next" }
            expect(response).to redirect_to(edit_survey_response_path(SurveyResponse.last))
          end
    
          it "redirects to the SurveyResponse edit page when click Save" do
            post survey_responses_path, params: { survey_response: create_response_attr, commit: "Save" }
            expect(response).to redirect_to(edit_survey_response_path(SurveyResponse.last))
          end
    
          it "redirects to the SurveyResponse edit page when click Previous" do
            post survey_responses_path, params: { survey_response: create_response_attr, commit: "Previous" }
            expect(response).to redirect_to(edit_survey_response_path(SurveyResponse.last))
          end

          it "redirects to the SurveyResponse show page when click Submit" do
            post survey_responses_path, params: { survey_response: create_response_attr, commit: "Submit" }
            expect(response).to redirect_to(survey_response_path(SurveyResponse.last))
          end
        end
    
        # context "with invalid parameters" do
        #   let(:invalid_attributes) do
        #     { survey_response: { answer: '', question_id: nil } }
        #   end
    
        #   it "does not create a new SurveyResponse" do
        #     expect {
        #       post survey_responses_path, params: invalid_attributes
        #     }.not_to change(SurveyResponse, :count)
        #   end
    
        #   it "re-renders the 'new' template" do
        #     post survey_responses_path, params: invalid_attributes
        #     expect(response).to render_template("new")
        #   end
        end
end
