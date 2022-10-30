require 'discordrb'

bot = Discordrb::Bot.new token: ENV['DISCORD_TOKEN']
requester = HttpRequestHelper.new('https://zuvvo-discord-bot.herokuapp.com/')

bot.message(with_text: 'Ping!') do |event|
  event.respond "Pong production! #{Time.new}"
end

bot.message(with_text: 'rq') do |event|
  respond = requester.test_request
  event.respond "rq! #{Time.new} respond: #{respond}"
end

bot.run