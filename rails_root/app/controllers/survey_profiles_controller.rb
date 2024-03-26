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
    # If any of the survey_profile_params values are nil, then the form is invalid

    if survey_profile_params.values.any? { |value| value.nil? || value.empty? }
      respond_to do |format|
        format.html do
          redirect_to new_survey_profile_url, notice: 'invalid form', status: :unprocessable_entity
        end
        format.json { render json: { error: 'invalid form' }, status: :unprocessable_entity }
      end

    # if user_id is not unique, then the form is invalid
    elsif SurveyProfile.find_by(user_id: session[:userinfo]['sub'])
      respond_to do |format|
        format.html do
          redirect_to new_survey_profile_url, notice: 'user_id is not unique', status: :unprocessable_entity
        end
        format.json { render json: { error: 'user_id is not unique' }, status: :unprocessable_entity }
      end

    else
      @survey_profile = SurveyProfile.new(survey_profile_params)
      @survey_profile.user_id = session[:userinfo]['sub']

      respond_to do |format|
        if @survey_profile.save
          format.html do
            # default is below
            # redirect_to survey_profile_url(@survey_profile), notice: 'Survey profile was successfully created.'
            #
            # redirect to the home page after creating a new survey profile
            redirect_to root_url
          end
          format.json { render :show, status: :created, location: @survey_profile }

        end
      end
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

  # Use callbacks to share common setup or constraints between actions.
  def set_survey_profile
    @survey_profile = SurveyProfile.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def survey_profile_params
    params.require(:survey_profile).permit(:user_id, :first_name, :last_name, :campus_name, :district_name)
  end
end
