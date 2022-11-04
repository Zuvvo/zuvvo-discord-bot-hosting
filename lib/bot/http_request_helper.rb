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

    params =  { 'host' => game.game_host_name, 'winner'=>game.game_winner, 'time'=>game.time_for_answer.to_s,
                'difficulty'=>game.difficulty.to_s, 'points'=>game.points.to_s,
                'results' => game.results.to_s
    }

    x = Net::HTTP.post_form(game_send_uri, params)
    x.body
  end

end