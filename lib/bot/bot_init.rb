require 'discordrb'
require_relative 'http_request_helper'

bot = Discordrb::Bot.new token: ENV['DISCORD_TOKEN']
requester = HttpRequestHelper.new('https://zuvvo-discord-bot.herokuapp.com/')

bot.message(with_text: 'Ping!') do |event|
  event.respond "Pong zxc! #{Time.new}"
end

bot.message(with_text: 'rq') do |event|
  respond = requester.test_request
  event.respond "rq! #{Time.new} respond: \n #{respond}"
end

bot.run