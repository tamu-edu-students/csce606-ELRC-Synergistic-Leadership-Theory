# require 'rails_helper'

RSpec.describe ApplicationJob, type: :job do
  describe '#perform' do
    it 'performs the job' do
      expect do
        described_class.perform_later
      end.to have_enqueued_job(described_class)
    end
  end
end
