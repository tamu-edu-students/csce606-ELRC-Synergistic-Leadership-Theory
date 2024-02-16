# frozen_string_literal: true

module SurveyProfilesHelper
  def full_name(survey_profile)
    "#{survey_profile.first_name} #{survey_profile.last_name}"
  end

  def campus_name(survey_profile)
    "#{survey_profile.campus_name}"
  end

  def district_name(survey_profile)
    "#{survey_profile.district_name}"
  end

  def get_survey_profile_id(user_id)
    survey_profile = SurveyProfile.find_by(user_id: user_id)
    survey_profile.id
  end
end
