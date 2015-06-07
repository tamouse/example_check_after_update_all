require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#set_all_seen" do
    before do
      FactoryGirl.create_list(:user, 20)
    end

    context "when using count" do
      it "finds 20 users unseen" do
        expect(User.unseen.count).to eq(20)
      end

      it "set_all_seen returns 20" do
        expect(User.set_all_seen.count).to eq(20)
      end

      it "set_all_seen_with_update returns 20" do
        expect(User.set_all_seen_with_update.count).to eq(20)
      end

      it "set_all_seen_as_array returns 20" do
        expect(User.set_all_seen_as_array.count).to eq(20)
      end
    end

    context "when using size" do
      it "finds 20 users unseen" do
        expect(User.unseen.size).to eq(20)
      end

      it "set_all_seen returns 20" do
        expect(User.set_all_seen.size).to eq(20)
      end

      it "set_all_seen_with_update returns 20" do
        expect(User.set_all_seen_with_update.size).to eq(20)
      end

      it "set_all_seen_as_array returns 20" do
        expect(User.set_all_seen_as_array.size).to eq(20)
      end
    end

  end
end
