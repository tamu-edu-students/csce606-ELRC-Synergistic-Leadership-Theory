# frozen_string_literal: true

Given('I have an invalid set of attributes for all models') do
  @model_attributes = {}

  @model_attributes['SurveyQuestion'] = {}
  SurveyQuestion.column_names.each do |name|
    @model_attributes['SurveyQuestion'][name] = nil if name != 'id' && name != 'created_at' && name != 'updated_at'
  end

  @model_attributes['SurveyProfile'] = {}
  SurveyProfile.column_names.each do |name|
    @model_attributes['SurveyProfile'][name] = nil if name != 'id' && name != 'created_at' && name != 'updated_at'
  end

  @model_attributes['SurveyResponse'] = {}
  SurveyResponse.column_names.each do |name|
    @model_attributes['SurveyResponse'][name] = nil if name != 'id' && name != 'created_at' && name != 'updated_at'
  end

  @model_attributes['SurveyAnswer'] = {}
  SurveyAnswer.column_names.each do |name|
    @model_attributes['SurveyAnswer'][name] = nil if name != 'id' && name != 'created_at' && name != 'updated_at'
  end
end

Then('the models were not created') do
  expect(SurveyQuestion.last).to be_nil
  expect(SurveyProfile.last).to be_nil
  expect(SurveyResponse.last).to be_nil
  expect(SurveyAnswer.last).to be_nil
end

Given('I have an valid set of attributes for all models') do
  @model_attributes = {}

  @model_attributes['SurveyQuestion'] = {}
  SurveyQuestion.column_names.each do |name|
    @model_attributes['SurveyQuestion'][name] = 10 if name != 'created_at' && name != 'updated_at'
  end

  @model_attributes['SurveyProfile'] = {}
  SurveyProfile.column_names.each do |name|
    @model_attributes['SurveyProfile'][name] = 10 if name != 'created_at' && name != 'updated_at'
  end

  @model_attributes['SurveyResponse'] = {}
  @model_attributes['SurveyResponse']['id'] = 10
  @model_attributes['SurveyResponse']['profile_id'] = 10

  @model_attributes['SurveyAnswer'] = {}
  SurveyAnswer.column_names.each do |name|
    @model_attributes['SurveyAnswer'][name] = 10 if name != 'created_at' && name != 'updated_at'
  end
end

Then('the models were created') do
  expect(SurveyQuestion.last).to be_truthy
  expect(SurveyProfile.last).to be_truthy
  expect(SurveyResponse.last).to be_truthy
  expect(SurveyAnswer.last).to be_truthy
end
