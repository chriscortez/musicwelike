require 'sinatra'
require 'slim'
require_relative 'user'

get '/' do
  slim :index
end

post '/toptracks' do
  @username = params[:username]
  u = User.new @username

  begin
    response = u.top_tracks
    if response
      @tracks = response['track']
      slim :toptracks
    end
  rescue Exception => e
    @message = e.message
    slim :error
  end
end
