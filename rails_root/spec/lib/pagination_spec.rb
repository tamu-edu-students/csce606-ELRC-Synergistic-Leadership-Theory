# frozen_string_literal: true

require_dependency Rails.root.join('lib', 'pagination')

# rubocop:disable Metrics/BlockLength
RSpec.describe Pagination do
  include Pagination

  context 'paginates questions' do
    before do
      question_params = {
        text: 'Text',
        explanation: 'Explanation',
        section: 0
      }

      @question1 = SurveyQuestion.where(id: 1).first || SurveyQuestion.create!(question_params)
      @question2 = SurveyQuestion.where(id: 2).first || SurveyQuestion.create!(question_params)

      question_params[:section] = 1
      @question3 = SurveyQuestion.where(id: 3).first || SurveyQuestion.create!(question_params)
    end

    after do
      @question1.destroy
      @question2.destroy
      @question3.destroy
    end

    it 'paginates based on per_page' do
      pagination, = paginate(collection: SurveyQuestion.all, params: { per_page: 1 })

      expect(pagination.total_pages).to eq(3)
    end

    it 'paginates based on section' do
      pagination, = paginate(collection: SurveyQuestion.all, params: { per_page: 10 })

      expect(pagination.total_pages).to eq(2)
    end

    it 'has previous page if not on first page' do
      pagination, = paginate(collection: SurveyQuestion.all, params: { page: 2, per_page: 1 })

      expect(pagination.prev_page?).to eq(true)
      expect(pagination.prev_page).to eq(1)
    end

    it 'has next page if not on last page' do
      pagination, = paginate(collection: SurveyQuestion.all, params: { page: 2, per_page: 1 })

      expect(pagination.next_page?).to eq(true)
      expect(pagination.next_page).to eq(3)
    end

    it 'next page is nil if on last page' do
      pagination, = paginate(collection: SurveyQuestion.all, params: { page: 3, per_page: 1 })

      expect(pagination.next_page?).to eq(false)
      expect(pagination.next_page).to eq(nil)
    end

    it 'prev page is nil if on first page' do
      pagination, = paginate(collection: SurveyQuestion.all, params: { page: 1, per_page: 1 })

      expect(pagination.prev_page?).to eq(false)
      expect(pagination.prev_page).to eq(nil)
    end

    it 'has effective count different than per page if not enough entries' do
      _, questions, = paginate(collection: SurveyQuestion.all, params: { page: 2, per_page: 2 })

      expect(questions.count).to eq(1)
    end
  end
end
# rubocop:enable Metrics/BlockLength
