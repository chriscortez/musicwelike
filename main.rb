require 'sinatra'
require 'slim'
require_relative 'user'

get '/' do
  slim :index
end

post '/matches' do
  begin
    @users = []
    params[:users].each_value do |name|
      new_user = User.new name
      @users << new_user
    end
    
    @matches = User.find_matches @users
    slim :matches
  rescue Exception => e
    @message = e.message
    slim :error
  end
end

post '/toptracks' do
  @username = params[:username]
  u = User.new @username

  begin
    response = u.top_tracks
    if response
      @tracks = response
      slim :toptracks
    end
  rescue Exception => e
    @message = e.message
    slim :error
  end
end
