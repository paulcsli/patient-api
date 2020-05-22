require "rails_helper"

RSpec.describe V1::PatientsController, :type => :controller do
  describe "GET index" do
    it "Get 10 patient profiles" do
      attrs = {
        :email=>"ran@gmail.com",
        :first_name=>"paul",
        :last_name=>"li",
        :birthdate=>"20110329",
        :sex=>"male",
      }
      patient = Patient.create!(attrs)     
      get :index

      body = JSON.parse(response.body).symbolize_keys
      first_patient = body[:data][0]

      expect(response).to have_http_status(:ok)
      expect(body).to have_key(:data)
      expect(first_patient['id']).to eq(patient.id) 
    end
  end

  describe "GET show" do
    it "Get patient by ID" do
      attrs = {
        :email=>"ran@gmail.com",
        :first_name=>"paul",
        :last_name=>"li",
        :birthdate=>"20110329",
        :sex=>"male",
      }
      patient = Patient.create!(attrs)     
      get :show, :params => { :id => patient.id }
      
      result = JSON.parse(response.body).symbolize_keys

      expect(response).to have_http_status(:ok)
      expect(result[:id]).to eq(patient.id) 
    end
  end

  describe "POST create" do
    it "create a patient" do
      attrs = {
        :email=>"ran@gmail.com",
        :first_name=>"paul",
        :last_name=>"li",
        :birthdate=>"20110329",
        :sex=>"male",
      }
      post :create, :params => { :data => attrs }, as: :json
      
      result = JSON.parse(response.body).symbolize_keys

      expect(response).to have_http_status(:created)
      expect(result[:email]).to eq(attrs[:email]) 
    end
  end
end
