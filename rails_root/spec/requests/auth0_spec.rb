require 'rails_helper'

RSpec.describe "Auth0s", type: :request do
  describe "GET /callback" do
    it "returns http success" do
      get "/auth0/callback"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /failure" do
    it "returns http success" do
      get "/auth0/failure"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /logout" do
    it "returns http success" do
      get "/auth0/logout"
      expect(response).to have_http_status(:success)
    end
  end

end
