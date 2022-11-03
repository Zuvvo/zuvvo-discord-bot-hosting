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
  game = MathGame.new('Zuvvo', "#{equation} = ?    (#{riddle_result})",30, 2, 5)

  event.respond "#{game.riddle}"

  #message: riddle_result doesnt work as intended
  bot.add_await!(Discordrb::Events::MessageEvent, message: riddle_result, timeout: 5) do |message_event|
    guess = message_event.message.content.to_i
    if guess == riddle_result
      winner = message_event.user.name
      event.respond "Correct, #{winner}!"
      game.discord_user_name = winner
      respond = requester.send_math_game_data(game)
      true
    else
      false
    end
  end

  event.respond "The answer was: `#{riddle_result}`."

end

bot.run