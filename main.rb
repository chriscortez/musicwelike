require 'sinatra'
require 'slim'
require_relative 'user'

get '/' do
  slim :index
end

post '/toptracks' do
  @username = params[:username]
  u = User.new @username
  responseJson = JSON.parse(u.top_tracks)
  if responseJson
    @tracks = responseJson['toptracks']['track']
    slim :toptracks
  end
end
