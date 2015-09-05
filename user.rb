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
        response['toptracks']['track']
      end
    else
      raise 'No API key present.'
    end
  end

  def self.find_matches users
    baseTracks = mash_tracks users.first.top_tracks

    partialMatches = createCounterHashWithKeys baseTracks.keys

    users.drop(1).each do |u|
      u.top_tracks.each do |t|
        # ensure the song id AND artist id match
        if baseTracks[t['mbid']] && baseTracks[t['mbid']] == t['artist']['mbid']
          partialMatches[t['mbid']] += 1
        end
      end
    end

    # only matches for all users are returned
    partialMatches.select { |k,v| v == users.length }
  end

  private

  def self.mash_tracks tracks
    # use the song id as the key, and the artist id as the value
    Hash[tracks.map { |t| [t['mbid'], t['artist']['mbid']] }]
  end

  def self.createCounterHashWithKeys keys
    counterHash = {}
    keys.each do |k|
      counterHash[k] = 1
    end
    counterHash
  end
end
