require 'net/http'
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
      response = JSON.load(Net::HTTP.get(uri))
      if response['error']
        message = response['message'] ? response['message'] : 'Something went wrong'
        raise 'Error: ' + message
      else
        response
      end
    else
      raise 'No API key present.'
    end
  end
end
