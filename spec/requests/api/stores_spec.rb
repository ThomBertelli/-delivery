require "rails_helper"



RSpec.describe "/stores", type: :request do
  let (:user) {
    user = User.new(
      email: "user@example.com",password: "123456", password_confirmation: "123456", role: "seller"
    )
    user.save!
    user
  }

  let(:valid_attributes) {
    {name: "Great Restaurant", user: user}
  }

  before {
    sign_in(user)
  }

  let(:credential) { Credential.create_access(:seller) }
  let(:signed_in) { api_sign_in(user, credential) }


  describe "GET /show" do
    it "renders a successful responde with stores data" do
      store = Store.create! valid_attributes
      get(
        "/stores/#{store.id}",
        headers:{
          "Accept" => "application/json",
          "Authorization" => "Bearer #{signed_in['token']}"
        }
      )
      json = JSON.parse(response.body)
      expect(json["name"]).to eq valid_attributes[:name]
    end
  end
end
