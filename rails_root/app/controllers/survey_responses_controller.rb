# frozen_string_literal: true

# Controller for survey responses

# rubocop:disable Metrics/ClassLength
class SurveyResponsesController < ApplicationController
  before_action :set_survey_data, only: %i[show edit update destroy]
  before_action :set_survey_sections, only: %i[show edit update new]

  # GET /survey_responses or /survey_responses.json
  def index
    if params[:query].present?
      @survey_responses = SurveyResponse.where(share_code: params[:query])
      flash[:warning] = "No survey responses found for share code #{params[:query]}" if @survey_responses.empty?
    else
      @survey_responses = SurveyResponse.all
    end
  end

  # GET /survey_responses/1 or /survey_responses/1.json
  def show
    flash.keep(:warning)
  end

  # GET /survey_responses/new
  def new
    @survey_response = SurveyResponse.new
    @questions = SurveyQuestion
  end

  # GET /survey_responses/1/edit
  def edit; end

  # POST /survey_responses or /survey_responses.json
  def create
    return respond_with_error 'invalid_form' if invalid_form?

    begin
      @survey_response = SurveyResponse.create_from_params survey_response_params
    rescue ActiveRecord::RecordNotFound
      return respond_with_error 'invalid survey response'
    end

    respond_to do |format|
      if @survey_response.save
        format.html do
          redirect_to survey_response_url(@survey_response), notice: 'Survey response was successfully created.'
        end
        format.json { render :show, status: :created, location: @survey_response }
      end
    end
  end

  # logic removed because it is not used in the application
  # PATCH/PUT /survey_responses/1 or /survey_responses/1.json
  def update
    return respond_with_error 'invalid form' if invalid_form?

    begin
      @survey_response.update_from_params survey_response_params
    rescue ActiveRecord::RecordNotFound
      return respond_with_error 'invalid user id'
    end

    respond_to do |format|
      format.html do
        redirect_to survey_response_url(@survey_response), notice: 'Survey response was successfully updated.'
        format.json { render :show, status: :ok, location: @survey_response }
      end
    end
  end

  # DELETE /survey_responses/1 or /survey_responses/1.json
  def destroy
    @survey_response.destroy!

    respond_to do |format|
      format.html { redirect_to survey_responses_url, notice: 'Survey response was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_survey_data
    @survey_response = SurveyResponse.find params[:id]
    @questions = @survey_response.questions
  end

  def set_survey_sections
    @sections = [
      {
        title: 'Part 1: Leadership Behavior - Management',
        prompt: 'To what extent do you agree the following behaviors reflect your personal leadership behaviors?'
      },
      {
        title: 'Part 1: Leadership Behavior - Interpersonal',
        prompt: 'To what extent do you agree the following behaviors reflect your personal leadership behaviors?'
      },
      {
        title: 'Part 2. External Forces',
        prompt: 'To what extent do you believe your board or immediate superior agrees to the importance of the following?'
      },
      {
        title: 'Part 3. Organizational Structure',
        prompt: 'To what extent do you agree the following characteristics apply to your organization?'
      },
      {
        title: 'Part 4. Values, Attitudes, and Beliefs',
        prompt: 'To what extent do you agree the following characteristics apply to you as the leader?'
      },
      {
        title: 'Part 4. Values, Attitudes, and Beliefs',
        prompt: 'To what extent do you agree the following apply to your external community
          (board, management, citizens)?'
      }
    ]
  end

  def invalid_form?
    survey_response_params.values.any? { |value| value.nil? || value.empty? }
  end

  def get_user_profile_from_params(params)
    SurveyProfile.where(user_id: params[:user_id]).first!
  end

  def respond_with_error(message, status = :unprocessable_entity)
    respond_to do |format|
      format.html do
        redirect_to new_survey_response_url, notice: message, status:
      end
      format.json { render json: { error: message }, status: }
    end
  end

  # Only allow a list of trusted parameters through.
  def survey_response_params
    params.require(:survey_response).permit! # FIXME: Figure out how to use strong params with new model
  end
end
# rubocop:enable Metrics/ClassLength
