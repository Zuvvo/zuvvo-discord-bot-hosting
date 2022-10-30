class HttpRequestHelper
  require 'uri'
  require 'net/http'

  attr_reader :uri

  def initialize(uri)
    @uri = uri
  end

  def test_request
    Net::HTTP.get_response(uri)
    res.body if res.is_a?(Net::HTTPSuccess)
  end

end