# frozen_string_literal: true

# Controller for survey responses
class SurveyResponsesController < ApplicationController
  before_action :set_survey_data, only: %i[show edit update destroy]
  before_action :set_survey_sections, only: %i[show edit update new]

  # GET /survey_responses or /survey_responses.json
  def index
    @survey_responses = SurveyResponse.all
  end

  # GET /survey_responses/1 or /survey_responses/1.json
  def show; end

  # GET /survey_responses/new
  def new
    @survey_response = SurveyResponse.new
    @questions = SurveyQuestion
  end

  # GET /survey_responses/1/edit
  def edit; end

  # POST /survey_responses or /survey_responses.json
  def create
    # If any of the survey_response_params values are nil, then the form is invalid
    if survey_response_params.values.any? { |value| value.nil? || value.empty? }
      respond_to do |format|
        format.html do
          redirect_to new_survey_response_url, notice: 'invalid form', status: :unprocessable_entity
        end
        format.json { render json: { error: 'invalid form' }, status: :unprocessable_entity }
      end
    else
      begin
        # FIXME: Validation
        profile = get_user_profile_from_params(survey_response_params)
      rescue ActiveRecord::RecordNotFound
        return respond_with_error 'invalid user_id'
      end
      @survey_response = SurveyResponse.new(profile:)
      survey_response_params.each do |question_id, choice|
        next if question_id == 'user_id'

        # FIXME: Validation
        question = SurveyQuestion.where(id: question_id).first!
        SurveyAnswer.create(choice:, question:, response: @survey_response)
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
  end

  # PATCH/PUT /survey_responses/1 or /survey_responses/1.json
  def update
    return respond_with_error 'invalid form' if survey_response_params.values.any?(&:nil?)

    begin
      # FIXME: Validation
      get_user_profile_from_params(survey_response_params)
    rescue ActiveRecord::RecordNotFound
      return respond_with_error 'invalid user id'
    end

    respond_to do |format|
      survey_response_params.each do |question_id, choice|
        next if question_id == 'user_id'

        begin
          # FIXME: Validation
          question = SurveyQuestion.where(id: question_id).first!
          answer = SurveyAnswer.where(question:, response: @survey_response).first!
        rescue ApplicationRecord::RecordNotFound
          return respond_with_error 'invalid question or answer'
        end

        answer.update(choice:)
      end

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
    @survey_response = SurveyResponse.find(params[:id])
    @questions = @survey_response.questions
  end

  def set_survey_sections
    @sections = [
      {
        title: 'Part 1: Leadership Behavior - Management',
        prompt: 'To what extent do you agree the following behaviors reflect your personal leadership behaviors?'
      },
      {
        title: 'Part 2: Leadership Behavior - Interpersonal',
        prompt: 'To what extent do you agree the following behaviors reflect your personal leadership behaviors?'
      }
    ]
  end

  def get_user_profile_from_params(params)
    SurveyProfile.where(user_id: params[:user_id]).first!
    # params.delete(:user_id)
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
