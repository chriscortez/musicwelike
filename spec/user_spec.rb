require 'spec_helper'

describe User do
  before :each do
    @user = User.new "Username"
  end

  describe "#new" do
    it "returns a User object" do
      expect(@user).to be_an_instance_of User
    end
  end

  describe "#username" do
    it "should be 'Username'" do
      expect(@user.username).to eql('Username')
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

    it "should return a JSON object" do
      response = @user.top_tracks
      expect{JSON.parse(response)}.to_not raise_error
    end
  end
end
