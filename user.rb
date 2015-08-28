require 'json'
$api_key = ENV['MUSICWELIKE_API_KEY']
$root_url = 'http://ws.audioscrobbler.com/2.0'


class User
  attr_accessor :username

  def initialize username
    @username = username
  end

  def top_tracks
    if $api_key
      url = $root_url + '?method=user.getTopTracks&user=' + @username + '&api_key=' + $api_key + '&format=json'
      uri = URI(url)
      puts uri
      response = JSON.load(Net::HTTP.get(uri))
      response.to_json
    else
      raise 'No API key present in the environment.'
    end
  end
end
