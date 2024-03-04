# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'survey_questions/edit', type: :view do
  let(:survey_question) do
    SurveyQuestion.create!(
      text: 'MyText',
      explanation: 'MyText',
      section: 0
    )
  end

  before(:each) do
    assign(:survey_question, survey_question)
  end

  it 'renders the edit survey_question form' do
    render

    assert_select 'form[action=?][method=?]', survey_question_path(survey_question), 'post' do
      assert_select 'textarea[name=?]', 'survey_question[text]'

      assert_select 'textarea[name=?]', 'survey_question[explanation]'

      assert_select 'input[name=?]', 'survey_question[section]'
    end
  end
end
