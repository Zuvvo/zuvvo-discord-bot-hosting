require 'discordrb'

bot = Discordrb::Bot.new token: ENV['DISCORD_TOKEN']

bot.message(with_text: 'Ping!') do |event|
  event.respond "Pong production! #{Time.new}"
end

bot.run