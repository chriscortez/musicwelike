require 'net/http'
require 'json'
$api_key = ENV['MUSICWELIKE_API_KEY']
$root_url = 'http://ws.audioscrobbler.com/2.0'
$limit = '500' # TODO make this user-definable


class User
  attr_accessor :username

  def initialize username
    # Last.fm does not allow spaces in usernames
    @username = username.gsub(/\s+/, "")
  end

  def top_tracks
    if $api_key
      url = $root_url + '?method=user.getTopTracks&user=' + @username + '&api_key=' + $api_key + '&format=json' + '&limit=' + $limit
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
    baseTracks = map_tracks users.first.top_tracks
    partialMatches = initializeTrackCounts baseTracks


    users.drop(1).each do |u|
      u.top_tracks.each do |t|
        # ensure the song id AND artist id match
        if baseTracks[t['mbid']] && baseTracks[t['mbid']]['artist']['id'] == t['artist']['mbid']
          partialMatches[t['mbid']]['count'] += 1
        end
      end
    end

    # only matches for all users are returned
    partialMatches.select { |id, t| t['count'] == users.length }
  end

  private

  def self.map_tracks tracks
    # use the following schema for holding track information
    # {
    #   track_id => {
    #                 name,
    #                 artist => {
    #                             id,
    #                             name
    #                           }
    #               }
    # }
    Hash[tracks.map { |t| [t['mbid'],
                            {
                              'name' => t['name'],
                              'artist' => {
                                'id' => t['artist']['mbid'],
                                'name' => t['artist']['name']
                              }
                            }
                          ]}]
  end

  def self.initializeTrackCounts tracks
    tracks.each do |id, t|
      t['count'] = 1
    end
  end
end
