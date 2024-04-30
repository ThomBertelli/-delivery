require 'rails_helper'

RSpec.describe Store, type: :model do
  describe "validations" do
    # it "should be valid when name is filled" do
    #   store = Store.new name: "Greatest store ever!"
    #   # expect(store.valid?).to eq true
    #   expect(store).to be_valid
    # end

    # it "should not be valid when name is emply" do
    #   store = Store.new
    #   #expect(store).to_not be_valid
    #   expect(store.valid?).to eq false
    # end

    # it "should not be valid when name lengh is < 3 " do
    #   store = Store.new name: "ab"
    #   expect(store).to_not be_valid
    # end

    # usando shoulda
    it {should validate_presence_of :name}
    it {should validate_length_of(:name).is_at_least(3)}
    it {should belong_to(:user)}

  end
  
  describe "belongs_to" do
    let(:admin) {
        User.create!(
          email: "admin@example.com",
          password: "123456",
          password_confirmation: "123456",
          role: :admin
        )
    }
    it "should not belong to admin users" do
      store = Store.create(name: "store", user: admin)
      expect(store.errors.full_messages).to eq ["User must exist"]
    end
  end
end
