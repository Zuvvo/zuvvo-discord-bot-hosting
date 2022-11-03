require 'discordrb'
require_relative 'http_request_helper'
require_relative 'math_game'

bot = Discordrb::Commands::CommandBot.new token: ENV['DISCORD_TOKEN'], prefix: '!'
requester = HttpRequestHelper.new('https://zuvvo-discord-bot.herokuapp.com/', 'https://zuvvo-discord-bot.herokuapp.com/math_game')

bot.command :ping do |event|
  event.respond "Pong zxc local! #{Time.new}"
end

bot.command :rq do |msg|
  respond = requester.test_request
  msg.respond "rq! #{Time.new} respond: \n #{respond}"
end

bot.command :math do |event|
  operators = ['*', '+', '-']
  numbers = []
  rand(3..5).times {numbers << rand(0..20) }
  equation = numbers.join(' x ').gsub(/x/) {operators.sample }
  riddle_result = eval(equation)
  game = MathGame.new('Zuvvo', "#{equation} = ? #{riddle_result}",30, 2, 5)

  event.respond "#{game.riddle}"

  event.user.await!(timeout: game.time) do |answer|
    guess = answer.message.content.to_i
    if guess == riddle_result
      answer.respond "correct #{event.user.name}"
      respond = requester.send_math_game_data(game)
      true
    else
      answer.respond "not correct"
      false
    end
  end

  event.respond "The answer was: `#{riddle_result}`."

end

#at_exit { bot.stop }
bot.run
#bot.join