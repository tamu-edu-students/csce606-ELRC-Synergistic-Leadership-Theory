# frozen_string_literal: true

When('I try to create model instances') do |table|
  table.hashes.each do |model|
    @attributes = @model_attributes[model['model_name']]

    if @attributes.values.any?(&:nil?)
      expect do
        model['model_name'].constantize.create!(@attributes)
      rescue ActiveRecord::RecordInvalid, ActiveRecord::NotNullViolation => e
        raise "Expected exception: #{e.class.name}"
      end.to raise_error(/Expected exception: (ActiveRecord::RecordInvalid|ActiveRecord::NotNullViolation)/)
    else
      model['model_name'].constantize.create!(@attributes)
    end
  end
end

Then('the model was not created') do
  expect(SurveyProfile.last).to be_nil
  expect(SurveyResponse.last).to be_nil
end

Then('the model was created') do
  expect(SurveyProfile.last.user_id).to eq(10)
  expect(SurveyResponse.last).to be_truthy
end
