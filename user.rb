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
        response['toptracks']
      end
    else
      raise 'No API key present.'
    end
  end

  def self.find_matches users
    # TODO refactor this
    trackHash = mash_tracks users.first.top_tracks['track']

    matches = {}
    trackHash.each_key do |k|
      matches[k] = 1
    end

    users.drop(1).each do |u|
      top_tracks = u.top_tracks['track']
      top_tracks.each do |t|
        if trackHash[t['mbid']] && trackHash[t['mbid']] == t['artist']['mbid']
          matches[t['mbid']] += 1
        end
      end
    end

    matches.select { |k,v| v == users.length }
  end

  private

  def self.mash_tracks tracks
    Hash[tracks.map { |t| [t['mbid'], t['artist']['mbid']] }]
  end
end
