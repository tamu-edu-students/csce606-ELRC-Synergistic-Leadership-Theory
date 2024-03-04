# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'survey_questions/new', type: :view do
  before(:each) do
    assign(:survey_question, SurveyQuestion.new(
                               text: 'MyText',
                               explanation: 'MyText',
                               section: 0
                             ))
  end

  it 'renders new survey_question form' do
    render

    assert_select 'form[action=?][method=?]', survey_questions_path, 'post' do
      assert_select 'textarea[name=?]', 'survey_question[text]'

      assert_select 'textarea[name=?]', 'survey_question[explanation]'

      assert_select 'input[name=?]', 'survey_question[section]'
    end
  end
end
