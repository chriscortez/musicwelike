require 'sinatra/base'

class FakeLastFm < Sinatra::Base
set :show_exceptions, false

  get '/2.0' do
    if params[:method] == 'user.getTopTracks'
      user = params[:user]
      json_response 200, user + '_toptracks.json'
    end
  end

  private

  def json_response(response_code, filename)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + filename, 'rb').read
  end
end
