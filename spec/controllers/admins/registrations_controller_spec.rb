require 'spec_helper'

describe Admins::RegistrationsController, type: :controller do
  before :each do
    request.env["devise.mapping"] = Devise.mappings[:admin]
    request.env['HTTPS'] = 'on'
  end

  context "This a new install of Cuttlefish with no users" do
    it "should allow an admin to register" do
      get :new
      expect(response).to be_success
    end

    it "should allow an admin to register" do
      post :create
      expect(response).to be_success
    end
  end

  context "There is already one admin registered" do
    let(:team) { Team.create! }
    let(:admin) { team.admins.create!(email: "foo@bar.com", password: "guess this") }
    before :each do
      admin
    end

    it "should not allow an admin to register" do
      get :new
      expect(response).to_not be_success
    end

    it "should not allow an admin to register" do
      post :create
      expect(response).to_not be_success
    end

    it "should allow an admin to update their account details" do
      sign_in admin
      get :edit
      expect(response).to be_success
    end

    it "should allow an admin to update their account details" do
      sign_in admin
      post :update
      expect(response).to be_success
    end
  end
end
