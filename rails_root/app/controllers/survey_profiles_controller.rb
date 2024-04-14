# frozen_string_literal: true

# Controller for the survey_profiles resource
class SurveyProfilesController < ApplicationController
  include Secured
  before_action :set_survey_profile, only: %i[show edit update destroy]

  # GET /survey_profiles or /survey_profiles.json
  def index
    @survey_profiles = SurveyProfile.all
  end

  # GET /survey_profiles/1 or /survey_profiles/1.json
  def show; end

  # GET /survey_profiles/new
  def new
    @survey_profile = SurveyProfile.new
  end

  # GET /survey_profiles/1/edit
  def edit; end

  # POST /survey_profiles or /survey_profiles.json
  def create
    if invalid_form? || non_unique_user?
      handle_invalid_form
    else
      create_survey_profile
    end
  end

  # PATCH/PUT /survey_profiles/1 or /survey_profiles/1.json
  def update
    # if anything in survey_profile_params is nil, then the form is invalid

    if survey_profile_params.values.any?(&:nil?)
      respond_to do |format|
        format.html do
          redirect_to edit_survey_profile_url(@survey_profile), notice: 'invalid form', status: :unprocessable_entity
        end
        format.json { render json: { error: 'invalid form' }, status: :unprocessable_entity }
      end

      # check if trying access a non-existing user_id
    elsif SurveyProfile.find_by(user_id: survey_profile_params[:user_id]).nil?
      respond_to do |format|
        format.html do
          redirect_to edit_survey_profile_url(@survey_profile), notice: 'user_id does not exist',
                                                                status: :unprocessable_entity
        end
        format.json { render json: { error: 'user_id does not exist' }, status: :unprocessable_entity }
      end

    else
      respond_to do |format|
        if @survey_profile.update(survey_profile_params)
          format.html do
            redirect_to survey_profile_url(@survey_profile), notice: 'Survey profile was successfully updated.'
          end
          format.json { render :show, status: :ok, location: @survey_profile }

        end
      end
    end
  end

  # DELETE /survey_profiles/1 or /survey_profiles/1.json
  def destroy
    @survey_profile.destroy!

    respond_to do |format|
      format.html { redirect_to survey_profiles_url, notice: 'Survey profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def create_survey_profile
    @survey_profile = SurveyProfile.new(survey_profile_params)
    @survey_profile.user_id = session[:userinfo]['sub']

    if session[:invitation] && claim_invitation
      # claim_invitation method will handle the redirect
    else
      respond_to do |format|
        if @survey_profile.save
          format.html { redirect_to root_url }
          format.json { render :show, status: :created, location: @survey_profile }
        end
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_survey_profile
    @survey_profile = SurveyProfile.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def survey_profile_params
    params.require(:survey_profile).permit(:user_id, :first_name, :last_name, :campus_name, :district_name, :role)
  end

  def invalid_form?
    survey_profile_params.values.any? { |value| value.nil? || value.empty? }
  end

  def non_unique_user?
    SurveyProfile.find_by(user_id: session[:userinfo]['sub'])
  end

  def handle_invalid_form
    respond_to do |format|
      format.html do
        redirect_to new_survey_profile_url, notice: 'invalid form', status: :unprocessable_entity
      end
      format.json { render json: { error: 'invalid form' }, status: :unprocessable_entity }
    end
  end

  def claim_invitation
    temporary_invitation_session_var = session[:invitation]

    if temporary_invitation_session_var && temporary_invitation_session_var['expiration'] > Time.now
      invitation = Invitation.find_by(id: temporary_invitation_session_var['from'])
      if invitation
        sharecode_from_invitation = invitation.parent_response.share_code
        # survey_profile = SurveyProfile.find_by(user_id: session[:userinfo]['sub'])
        new_response_to_fill = SurveyResponse.create(profile: @survey_profile, share_code: sharecode_from_invitation)
        invitation.update(claimed_by_id: @survey_profile.id, response_id: new_response_to_fill.id)
        redirect_to edit_survey_response_path(new_response_to_fill)
        return true
      end
    end

    session.delete(:invitation)
    false
  end
end
