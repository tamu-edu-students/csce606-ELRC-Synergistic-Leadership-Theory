require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the HomeHelper. For example:
#
# describe HomeHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe HomeHelper, type: :helper do
  describe "#greeting_message" do
    it "returns the correct greeting based on the time of day" do
      allow(Time.zone).to receive(:now).and_return(Time.zone.parse("2024-01-01 10:00:00"))
      expect(helper.greeting_message).to eq("Good morning!")

      allow(Time.zone).to receive(:now).and_return(Time.zone.parse("2024-01-01 14:00:00"))
      expect(helper.greeting_message).to eq("Good afternoon!")

      allow(Time.zone).to receive(:now).and_return(Time.zone.parse("2024-01-01 20:00:00"))
      expect(helper.greeting_message).to eq("Good evening!")
    end
  end
end
