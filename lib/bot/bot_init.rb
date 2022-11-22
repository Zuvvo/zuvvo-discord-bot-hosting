require 'discordrb'
require_relative 'math_game'
require_relative 'bot_messages'
require_relative 'game_difficulty'
require_relative 'graphql_sender'
require 'byebug'

include GameDifficulty
include GraphqlSender

MATH_GAME_START_COMMAND = :math
SEND_DATA_TEST = :sendql
HELP_COMMAND = 'help'

bot = Discordrb::Commands::CommandBot.new token: ENV['DISCORD_TOKEN'], prefix: '!'

bot.command MATH_GAME_START_COMMAND do |event|
  args = event.message.content.split(' ').drop(1)
  if args.size > 0 && args[0] == HELP_COMMAND
    difficulties = (1..4).map { |el| GameDifficulty.get_numbers_count(el) }
    event.respond BotMessages.help("#{bot.prefix}#{MATH_GAME_START_COMMAND.to_s}", difficulties)
  else
    game = MathGame.new(event, event.user.name, bot, args)
    game.start_game
  end
end

bot.command SEND_DATA_TEST do |event|
  args = event.message.content.split(' ').drop(1)
  game = MathGame.new(event, event.user.name, bot, args)
  game.results = "[[\"Mat\", 5], [\"Fat\", 5], [\"Gat\", 1]]"
  game.game_host_name = "test_host"
  game.time_for_answer = 12
  game.difficulty = 3
  game.riddles = []
  game.riddles << MathGameRiddle.new(nil, nil, nil, nil, nil, nil)
  game.riddles << MathGameRiddle.new(nil, nil, nil, nil, nil, nil)
  send_mutation_query(game)
end




bot.run