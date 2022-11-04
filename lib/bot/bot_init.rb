require 'discordrb'
require_relative 'http_request_helper'
require_relative 'math_game'

bot = Discordrb::Commands::CommandBot.new token: ENV['DISCORD_TOKEN'], prefix: '!' #ENV['DISCORD_TOKEN']
requester = HttpRequestHelper.new('https://zuvvo-discord-bot.herokuapp.com/', 'https://zuvvo-discord-bot.herokuapp.com/math_game')

bot.command :math do |event|
  game = MathGame.new(event, event.user.name, bot, requester, 20, 3, 2, 10)
  game.start_game

end

bot.run