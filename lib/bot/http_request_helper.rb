class HttpRequestHelper
  require 'uri'
  require 'net/http'

  attr_reader :uri, :game_send_uri

  def initialize(uri, game_send_uri)
    @uri = URI(uri)
    @game_send_uri = URI(game_send_uri)
  end

  def test_request
    res = Net::HTTP.get_response(uri)
    res.body if res.is_a?(Net::HTTPSuccess)
  end

  def send_math_game_data(game)

    puts game.results.to_s
    params =  { 'host' => game.game_host_name, 'time'=>game.time_for_answer.to_s,
                'difficulty'=>game.difficulty.to_s, 'riddles_count'=>game.riddles.size.to_s,
                'results' => game.results.to_s
    }

    x = Net::HTTP.post_form(game_send_uri, params)
    x.body
  end

end