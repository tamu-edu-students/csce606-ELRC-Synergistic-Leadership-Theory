# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'survey_questions/index', type: :view do
  before(:each) do
    assign(:survey_questions, [
             SurveyQuestion.create!(
               text: 'MyText',
               explanation: 'MyText',
               section: 0
             ),
             SurveyQuestion.create!(
               text: 'MyText',
               explanation: 'MyText',
               section: 0
             )
           ])
  end

  it 'renders a list of survey_questions' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new('MyText'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('MyText'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
