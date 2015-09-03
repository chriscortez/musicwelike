require 'spec_helper'

describe User do
  before :each do
    @user = User.new "User1"
  end

  describe "#new" do
    it "returns a User object" do
      expect(@user).to be_an_instance_of User
    end
  end

  describe "#username" do
    it "should be 'User1'" do
      expect(@user.username).to eql('User1')
    end
  end

  describe "#toptracks" do
    it "should return an error if there is no api key present" do
      cached = false

      if ENV['MUSICWELIKE_API_KEY']
        cached = true
        cached_api_key = ENV['MUSICWELIKE_API_KEY']
      end

      $api_key = nil
      expect{@user.top_tracks}.to raise_error('No API key present.')

      if cached
        $api_key = cached_api_key
      end
    end

    it "should return a hash object" do
      response = @user.top_tracks
      expect(response.instance_of?(Hash)).to eql(true)
    end

    it "should raise an error if user is not found" do
      user = User.new "Invalid"
      expect{user.top_tracks}.to raise_error('Error: User not found')
    end
  end
end
