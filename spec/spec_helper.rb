require_relative '../user'
require 'support/fake_lastfm'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, /ws.audioscrobbler/).to_rack(FakeLastFm)
  end
end
