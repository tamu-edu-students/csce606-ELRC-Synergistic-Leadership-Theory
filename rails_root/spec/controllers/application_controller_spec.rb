# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe "#current_user" do
    it "returns nil if session[:userinfo] is not set" do
      session[:userinfo] = nil
      expect(controller.send(:current_user)).to be_nil
    end

    it "returns the current user if session[:userinfo] is set" do
      session[:userinfo] = { 'id' => 1, 'name' => 'Test User' }
      expect(controller.send(:current_user)).to be_present
      expect(controller.send(:current_user).id).to eq(1)
      expect(controller.send(:current_user).name).to eq('Test User')
    end
  end

  describe "#user_is_admin?" do
    it "returns false if session[:userinfo] is not set" do
      session[:userinfo] = nil
      expect(controller.send(:user_is_admin?)).to be_falsey
    end

    it "returns true if user_roles includes 'Admin'" do
      session[:userinfo] = { 'roles' => ['Admin'] }
      allow(controller).to receive(:user_roles).and_return(['Admin'])
      expect(controller.send(:user_is_admin?)).to be_truthy
    end

    it "returns false if user_roles does not include 'Admin'" do
      session[:userinfo] = { 'roles' => ['User'] }
      allow(controller).to receive(:user_roles).and_return(['User'])
      expect(controller.send(:user_is_admin?)).to be_falsey
    end
  end

  describe "#require_admin!" do
    it "redirects to root_path with flash error if user is not admin" do
      allow(controller).to receive(:user_is_admin?).and_return(false)
      expect(controller).to receive(:redirect_to).with(root_path)
      controller.send(:require_admin!)
      expect(flash[:error]).to eq("You must be an administrator to access this section")
    end

    it "does not redirect if user is admin" do
      allow(controller).to receive(:user_is_admin?).and_return(true)
      expect(controller).not_to receive(:redirect_to)
      controller.send(:require_admin!)
    end
  end
end