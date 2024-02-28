# frozen_string_literal: true

# Controller for survey responses
class SurveyResponsesController < ApplicationController
  before_action :set_survey_response, only: %i[show edit update destroy]

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
    @sections = [
      {
        title: 'Part 1: Leadership Behavior - Management',
        prompt: 'To what extent do you agree the following behaviors reflect your personal leadership behaviors?',
      },
      {
        title: 'Part 2: Leadership Behavior - Interpersonal',
        prompt: 'To what extent do you agree the following behaviors reflect your personal leadership behaviors?',
      }
    ]
  end

  # GET /survey_responses/1/edit
  def edit
    # FIXME: DRY
    @questions = SurveyQuestion
    @sections = [
      {
        title: 'Part 1: Leadership Behavior - Management',
        prompt: 'To what extent do you agree the following behaviors reflect your personal leadership behaviors?',
      },
      {
        title: 'Part 2: Leadership Behavior - Interpersonal',
        prompt: 'To what extent do you agree the following behaviors reflect your personal leadership behaviors?',
      }
    ]
  end

  # POST /survey_responses or /survey_responses.json
  def create
    # If any of the survey_response_params values are nil, then the form is invalid
    if survey_response_params.values.any? { |value| value.nil? || value.empty? || survey_response_params.keys.length != SurveyResponse.column_names.length - 3 }
      respond_to do |format|
        format.html do
          redirect_to new_survey_response_url, notice: 'invalid form', status: :unprocessable_entity
        end
        format.json { render json: { error: 'invalid form' }, status: :unprocessable_entity }
      end

    else
      # FIXME: DRY
      begin
        profile = SurveyProfile.where(user_id: survey_response_params[:user_id]).first!
        survey_response_params.delete(:user_id)
      rescue ActiveRecord::RecordNotFound
        respond_to do |format|
          format.html do
            redirect_to new_survey_response_url, notice: 'invalid user id', status: :unprocessable_entity
          end

          format.json { render json: { error: 'invalid user id' }, status: :unprocessable_entity }
        end

        return
      end
      @survey_response = SurveyResponse.new(profile: profile)

      survey_response_params.each do |question_id, choice|
        question = SurveyQuestion.where(id: question_id).first!
        SurveyAnswer.create(choice: choice, question: question, response: @survey_response)
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
    if survey_response_params.values.any?(&:nil?)
      respond_to do |format|
        format.html do
          redirect_to edit_survey_response_url(@survey_response), notice: 'invalid form', status: :unprocessable_entity
        end
        format.json { render json: { error: 'invalid form' }, status: :unprocessable_entity }
      end
    else
      respond_to do |format|
        survey_response_params.each do |question_id, choice|
          # FIXME: Ensure that these exist
          question = SurveyQuestion.where(id: question_id).first
          answer = SurveyAnswer.where(question: question, response: @survey_response).first

          answer.update(choice: choice)
        end
        # if @survey_response.update(survey_response_params)
        #   format.html do
        #     redirect_to survey_response_url(@survey_response), notice: 'Survey response was successfully updated.'
        #   end
        #   format.json { render :show, status: :ok, location: @survey_response }

        # end
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
  def set_survey_response
    @survey_response = SurveyResponse.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def survey_response_params
    params.require(:survey_response).permit! # FIXME: Figure out how to use strong params with new model
  end
end
