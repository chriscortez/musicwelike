require 'sinatra/base'

class FakeLastFm < Sinatra::Base
  get '/2.0' do
    json_response 200, 'toptracks.json'
  end

  private

  def json_response(response_code, filename)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + filename, 'rb').read
  end
end
