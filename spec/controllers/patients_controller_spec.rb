require "rails_helper"

RSpec.describe V1::PatientsController, :type => :controller do
  let(:attrs) {
    {
      :email => "randf@gmail.com",
      :first_name => "paul",
      :last_name => "li",
      :birthdate => "2011-03-29",
      :sex => "M",
    }
  }

  describe "GET index" do
    it "Get 10 patient profiles" do
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
      patient = Patient.create!(attrs)     
      get :show, :params => { :id => patient.id }
      
      result = JSON.parse(response.body).symbolize_keys

      expect(response).to have_http_status(:ok)
      expect(result[:id]).to eq(patient.id) 
    end

    it "try to get a patient with an invalid ID" do     
      get :show, :params => { :id => 100 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST create" do
    it "create a patient" do
      post :create, :params => { :data => attrs }, as: :json
      
      result = JSON.parse(response.body).symbolize_keys

      expect(response).to have_http_status(:created)
      expect(result[:email]).to eq(attrs[:email]) 
    end
    
    it "try to create a patient with existing email" do
      patient = Patient.create!(attrs)
      post :create, :params => { :data => attrs }, as: :json
      expect(response).to have_http_status(:conflict)
    end
    
    it "try to create a patient with missing attributes" do
      post :create, :params => { :data => {} }, as: :json
      expect(response).to have_http_status(:bad_request)
    end
  end
end
