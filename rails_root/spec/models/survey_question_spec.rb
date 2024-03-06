# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SurveyQuestion, type: :model do
  it 'validates the presence of text' do
    question = SurveyQuestion.new
    question.valid?
    expect(question.errors[:text]).to include("can't be blank")
  end
end
