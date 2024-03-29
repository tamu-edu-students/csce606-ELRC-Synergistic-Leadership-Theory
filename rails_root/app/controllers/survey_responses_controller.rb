# frozen_string_literal: true

# Controller for survey responses

# rubocop:disable Metrics/ClassLength
class SurveyResponsesController < ApplicationController
  include Pagination

  before_action :set_survey_data, only: %i[show edit update destroy]
  before_action :set_survey_sections, only: %i[show edit update survey new]

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

  def new
    logger.info "========== new triggered =========="
    @pagination, @questions, @section = paginate(collection: SurveyQuestion.all, params: { per_page: 10, page: 1 })
    @survey_response = SurveyResponse.new
    session[:user_id] = nil 
    session[:survey_id] = nil
    session[:page_number] = 1

    if session.dig(:userinfo, 'sub').present? && (not session[:userinfo]['sub'].nil?)
      session[:user_id] = session[:userinfo]['sub']
      render :survey
    else
      flash[:warning] = "You are not logged in!"
      redirect_to survey_responses_path
    end

  end

  # GET /survey/page/:page
  def survey
    logger.info "========== survey triggered =========="
    @pagination, @questions, @section = paginate(collection: SurveyQuestion.all, params: { per_page: 10, page: params[:page] })
    @survey_response = SurveyResponse.find_by_id(session[:survey_id])
    render :survey
  end

  # GET /survey_responses/1/edit
  def edit
    logger.info "========== edit triggered =========="
    session[:survey_id] = @survey_response.id
    session[:page_number] = 1
    redirect_to survey_page_url(session[:page_number])
  end

  # POST /survey_responses or /survey_responses.json
  def create
    return respond_with_error 'invalid_form' if invalid_form?

    if session[:survey_id].nil?
      @survey_response = SurveyResponse.create_from_params session[:user_id], survey_response_params

      if @survey_response.nil?
        flash[:warning] = "Survey profile not found!"
        redirect_to survey_responses_path
      else
        session[:survey_id] = @survey_response.id
      end
    end

    if not survey_response_params.nil?
        @survey_response = SurveyResponse.find_by_id(session[:survey_id])
        @survey_response.add_from_params session[:user_id], survey_response_params
    else
      flash[:warning] = "survey_response_params is Nil!"
    end

    respond_to do |format|
      if params[:commit].in?(["Save","Next"])
        format.html do
          session[:page_number] += 1
          redirect_to survey_page_url(session[:page_number])
        end
      elsif params[:commit] == "Previous"
        format.html do
          session[:page_number] -= 1
          redirect_to survey_page_url(session[:page_number])
        end
      else
        @survey_response = SurveyResponse.find_by_id(session[:survey_id])
        logger.info "@survey_response: #{@survey_response}"
        format.html do
          redirect_to survey_response_url(@survey_response), notice: 'Survey response was successfully created.'
        end
        format.json { render :show, status: :created, location: @survey_response }
      end
    end
  end

  # PATCH/PUT /survey_responses/1 or /survey_responses/1.json
  def update
    logger.info "========== update triggered =========="
    return respond_with_error 'invalid form' if invalid_form?

    begin
      @survey_response.update_from_params session[:user_id], survey_response_params
    rescue ActiveRecord::RecordNotFound
      return respond_with_error message: 'invalid user id', status: :not_found
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
    logger.info "========== set_survey_data triggered =========="
    @survey_response = SurveyResponse.find params[:id]
    @questions = @survey_response.questions
  end

  def set_survey_sections
    logger.info "========== set_survey_sections triggered =========="
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
    if survey_response_params.nil?
      return false
    else
      return survey_response_params.values.any? { |value| value.nil? || value.empty? }
    end
  end

  def respond_with_error(message, status = :unprocessable_entity)
    respond_to do |format|
      format.html do
        redirect_to survey_page_path(1), notice: message, status:
      end
      format.json { render json: { error: message }, status: }
    end
  end

  def survey_response_params
    if params.include? :survey_response
      params.require(:survey_response).permit!
    end
  end
end
# rubocop:enable Metrics/ClassLength
