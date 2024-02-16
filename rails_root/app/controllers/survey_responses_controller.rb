# frozen_string_literal: true

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
  end

  # GET /survey_responses/1/edit
  def edit; end

  # POST /survey_responses or /survey_responses.json
  def create
    p "HEREERERERERERERERERE\n\n\n\n\n"
    p survey_response_params
    if survey_response_params.values.any? { |value| value.nil? || value.empty? }
      respond_to do |format|
        format.html do
          redirect_to new_survey_response_url, notice: 'invalid form', status: :unprocessable_entity
        end
        format.json { render json: { error: 'invalid form' }, status: :unprocessable_entity }
      end
    else
      @survey_response = SurveyResponse.new(survey_response_params)

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
        if @survey_response.update(survey_response_params)
          format.html do
            redirect_to survey_response_url(@survey_response), notice: 'Survey response was successfully updated.'
          end
          format.json { render :show, status: :ok, location: @survey_response }

        end
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
    params.require(:survey_response).permit(:user_id, :leads_by_example, :ability_to_juggle, :communicator,
                                            :lifelong_learner, :high_expectations, :cooperative, :empathetic, :people_oriented)
  end
end
