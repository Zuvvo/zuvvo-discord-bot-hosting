class HttpRequestHelper
  require 'uri'
  require 'net/http'

  attr_reader :uri

  def initialize(uri)
    @uri = URI(uri)
  end

  def test_request
    res = Net::HTTP.get_response(uri)
    res.body if res.is_a?(Net::HTTPSuccess)
  end

end