# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SurveyProfilesHelper. For example:
#
# describe SurveyProfilesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SurveyProfilesHelper, type: :helper do
  let(:survey_profile) do
    SurveyProfile.create!(
      user_id: 1,
      first_name: 'John',
      last_name: 'Doe',
      campus_name: 'Campus',
      district_name: 'District'
    )
  end

  describe '#full_name' do
    it 'returns the full name of a survey profile' do
      expect(helper.full_name(survey_profile)).to eq('John Doe')
    end
  end

  describe '#campus_name' do
    it 'returns the campus name of a survey profile' do
      expect(helper.campus_name(survey_profile)).to eq('Campus')
    end
  end

  describe '#district_name' do
    it 'returns the district name of a survey profile' do
      expect(helper.district_name(survey_profile)).to eq('District')
    end
  end

  describe '#get_survey_profile_id' do
    it 'returns the id of a survey profile' do
      expect(helper.get_survey_profile_id(survey_profile.user_id)).to eq(survey_profile.id)
    end
  end
end
