# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'survey_questions/show', type: :view do
  before(:each) do
    assign(:survey_question, SurveyQuestion.create!(
                               text: 'MyText',
                               explanation: 'MyText',
                               section: 0
                             ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
