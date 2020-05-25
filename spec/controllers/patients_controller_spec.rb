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
    context "with zero patients in DB" do
      it "get for page 1" do
        get :index
        body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(body).to eql({
          "data" => [],
          "links" => {
            "self" => "#{request.base_url}/v1/patients?page_number=1",
            "next" => nil,
          },
        })
      end

      it "get for page 2" do
        get :index, :params => { :page_number => 2 }
        body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(body).to eql({
          "data" => [],
          "links" => {
            "self" => "#{request.base_url}/v1/patients?page_number=2",
            "next" => nil,
          },
        })
      end
    end

    context "25 patients in DB" do
      before(:all) do
        for i in 1..25 do
          Patient.create!({
            :email => "#{SecureRandom.hex}@gmail.com",
            :first_name => "paul",
            :last_name => "li",
            :birthdate => "2011-03-29",
            :sex => "M",
          })
        end
      end

      # TODO: figure out how to clean up db after each example
      after(:all) do
        Patient.delete_all
      end

      it "get the first 10 patients" do
        get :index
        body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)

        expected_ids = body["data"].map { |p| p["attributes"]["id"] }
        expect(expected_ids).to eql((1..10).to_a.map(&:to_s))
        expect(body["links"]).to eql({
          "self" => "#{request.base_url}/v1/patients?page_number=1",
          "next" => "#{request.base_url}/v1/patients?page_number=2",
        })
      end

      it "get the last 5 patients" do
        get :index, :params => { :page_number => 3 }
        body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)

        expected_ids = body["data"].map { |p| p["attributes"]["id"] }
        expect(expected_ids).to eql((21..25).to_a.map(&:to_s))
        expect(body["links"]).to eql({
          "self" => "#{request.base_url}/v1/patients?page_number=3",
          "next" => nil,
        })
      end
    end
  end

  describe "GET show" do
    it "Get patient by ID" do
      patient = Patient.create!(attrs)     
      get :show, :params => { :id => patient.id }
      
      result = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(result["attributes"]["id"]).to eq(patient.id.to_s) 
    end

    it "try to get a patient with an invalid ID" do     
      get :show, :params => { :id => 100 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST create" do
    it "create a patient" do
      post :create, :params => { :data => attrs }, as: :json
      
      result = JSON.parse(response.body)

      expect(response).to have_http_status(:created)
      expect(result["attributes"]["email"]).to eq(attrs[:email]) 
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

    it "try to create a patient with missing params" do
      post :create
      expect(response).to have_http_status(:bad_request)
    end
  end
end
