require 'discordrb'
require_relative 'http_request_helper'
require_relative 'math_game'
require_relative 'bot_messages'
require_relative 'game_difficulty'
require 'byebug'

include GameDifficulty

MATH_GAME_START_COMMAND = :math
HELP_COMMAND = 'help'

bot = Discordrb::Commands::CommandBot.new token: ENV['DISCORD_TOKEN'], prefix: '!'
requester = HttpRequestHelper.new('https://zuvvo-discord-bot.herokuapp.com/', 'https://zuvvo-discord-bot.herokuapp.com/math_game')

bot.command MATH_GAME_START_COMMAND do |event|
  args = event.message.content.split(' ').drop(1)
  if args.size > 0 && args[0] == HELP_COMMAND
    event.respond BotMessages.help("#{bot.prefix}#{MATH_GAME_START_COMMAND.to_s}")
  else
    game = MathGame.new(event, event.user.name, bot, requester, args)
    game.start_game
  end
end

bot.run