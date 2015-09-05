require 'spec_helper'

describe User do
  before :each do
    @userOne = User.new "UserOne"
  end

  describe "#new" do
    it "returns a User object" do
      expect(@userOne).to be_an_instance_of User
    end
  end

  describe "#username" do
    it "is 'User1'" do
      expect(@userOne.username).to eql("UserOne")
    end
  end

  describe "#toptracks" do
    it "raises an error if there is no api key present" do
      cached = false

      if ENV['MUSICWELIKE_API_KEY']
        cached = true
        cached_api_key = ENV['MUSICWELIKE_API_KEY']
      end

      $api_key = nil
      expect{@userOne.top_tracks}.to raise_error("No API key present.")

      if cached
        $api_key = cached_api_key
      end
    end

    context "when user exists" do
      context "with plays" do
        it "returns a non-empty array" do
          response = @userOne.top_tracks
          expect(response.empty?).to be false
        end
      end

      context "without plays" do
        it "returns an empty array" do
          userFour = User.new "UserFour"
          response = userFour.top_tracks
          expect(response.empty?).to be true
        end
      end
    end

    context "when user doesn't exist" do
      it "raises an error" do
        user = User.new "Invalid"
        expect{user.top_tracks}.to raise_error("Error: User not found")
      end
    end
  end

  describe ".find_matches" do

    context "when no matches exist" do
      before :each do
        @userTwo = User.new "UserTwo"
      end

      it "returns an empty hash" do
        matches = User.find_matches [@userOne, @userTwo]
        expect(matches.empty?).to be true
      end
    end

    context "when matches exist" do
      before :each do
        @userThree = User.new "UserThree"
      end

      it "returns a Hash of matches" do
        matches = User.find_matches [@userOne, @userThree]
        expect(matches['76cc0d1b-c44f-4252-829e-9f55ef45b1ab']).to eql(2)
      end
    end
  end
end
