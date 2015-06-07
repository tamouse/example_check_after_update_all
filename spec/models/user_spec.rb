require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#set_all_seen" do
    before do
      FactoryGirl.create_list(:user, 20)
    end

    it "finds 20 users unseen" do
      expect(User.unseen.count).to eq(20)
    end

    it "returns 20 users as unseen" do
      expect(User.set_all_seen.count).to eq(20)
    end

  end

end
