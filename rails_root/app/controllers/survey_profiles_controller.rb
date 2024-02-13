class SurveyProfilesController < ApplicationController
  before_action :set_survey_profile, only: %i[ show edit update destroy ]

  # GET /survey_profiles or /survey_profiles.json
  def index
    @survey_profiles = SurveyProfile.all
  end

  # GET /survey_profiles/1 or /survey_profiles/1.json
  def show
  end

  # GET /survey_profiles/new
  def new
    @survey_profile = SurveyProfile.new
  end

  # GET /survey_profiles/1/edit
  def edit
  end

  # POST /survey_profiles or /survey_profiles.json
  def create
    @survey_profile = SurveyProfile.new(survey_profile_params)

    respond_to do |format|
      if @survey_profile.save
        format.html { redirect_to survey_profile_url(@survey_profile), notice: "Survey profile was successfully created." }
        format.json { render :show, status: :created, location: @survey_profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @survey_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /survey_profiles/1 or /survey_profiles/1.json
  def update
    respond_to do |format|
      if @survey_profile.update(survey_profile_params)
        format.html { redirect_to survey_profile_url(@survey_profile), notice: "Survey profile was successfully updated." }
        format.json { render :show, status: :ok, location: @survey_profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @survey_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /survey_profiles/1 or /survey_profiles/1.json
  def destroy
    @survey_profile.destroy!

    respond_to do |format|
      format.html { redirect_to survey_profiles_url, notice: "Survey profile was successfully destroyed." }
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
