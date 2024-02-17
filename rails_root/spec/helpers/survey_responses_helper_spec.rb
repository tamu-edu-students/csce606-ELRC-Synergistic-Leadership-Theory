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

RSpec.describe SurveyResponsesHelper, type: :helper do
  let(:survey_response) do
    SurveyResponse.create!(
      user_id: 1,
      leads_by_example: 1,
      ability_to_juggle: 1,
      communicator: 1,
      lifelong_learner: 1,
      high_expectations: 1,
      cooperative: 1,
      empathetic: 1,
      people_oriented: 1
    )
  end

  describe '#average_score' do
    it 'returns the average score of a survey response' do
      expect(helper.average_score(survey_response)).to eq(1.0)
    end
  end

  require 'rails_helper'

  describe '#formatted_date' do
    it 'returns the formatted date of a survey response' do
      expect(helper.formatted_date(survey_response)).to eq(survey_response.created_at.strftime('%B %d, %Y'))
    end
  end

  describe '#user_of_response' do
    it 'returns the user of a survey response' do
      expect(helper.user_of_response(survey_response)).to eq(survey_response.user_id)
    end
  end
end
