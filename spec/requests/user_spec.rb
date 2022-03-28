require 'pry'
require "rails_helper"

RSpec.describe "Users", :type => :request do

  let(:user) do
    User.create!(
      first_name: "Niyanta", 
      last_name: "Prasad", 
      email: "niyanta16@gmail.coan"
    ) 
  end

  describe "POST /users" do
    it "creates a user" do
      headers = { "ACCEPT" => "application/json" }
      post "/users", :params => { :first_name => "Niyanta", :last_name => "Prasad", :email => "niyanta16@gmail.com" }, :headers => headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status :ok
    end
  end

  describe 'PATCH /users/:id' do

    context "with invalid parameters" do

      let(:params) do
        {
          first_name: ""
        }
      end

      it "returns unproccessable entity" do
        patch "/users/#{user.id}", params: params
        expect(response).to have_http_status(422)
      end

      it "does not update the user" do
        patch "/users/#{user.id}", params: params
        expect { user.reload }.to_not change(user, :first_name)
      end
    end

    context "with valid parameters" do

      let(:params) do
        {
          first_name: "NiyantaUpdated", 
          last_name: "PrasadUpdated", 
          email: "niyanta16updated@gmail.com"
        }
      end

      it "returns no content" do
        patch "/users/#{user.id}", params: params 
        expect(response).to have_http_status :ok
      end

      it "updates the user" do
        patch "/users/#{user.id}", params: params 
        expect { user.reload }.to change(user, :first_name)
        .to("NiyantaUpdated") 
      end
    end
  end

  describe 'GET /users' do
    before do
      get "/users"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "JSON body response contains expected user attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response[0].keys).to match_array(["_id", "email", "first_name", "last_name"])
    end
  end

  describe 'GET /users/:id' do
    
    before do
      get "/users/#{user.id}"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "should return particular user" do
      json_response = JSON.parse(response.body)
      expect(user[:first_name]).to eq json_response["first_name"]
    end
  end

  describe 'DELETE /users/:id' do
    before(:each) do
      user_id = user.id
      delete "/users/#{user.id}"
    end

    it 'should return status 204' do
      expect(response.status).to eq 204
    end

    it 'should delete the user' do
      expect { user.reload }
      expect(User.where(id: user.id)).to eq []
    end 
  end
end