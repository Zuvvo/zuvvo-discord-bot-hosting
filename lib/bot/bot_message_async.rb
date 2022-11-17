class BotMessageAsync
  require 'concurrent'
  include Concurrent::Async

  def initialize(bot )
    @bot = bot
  end

  def edit(msg, base_msg_text, players, seconds_left)
    msg.edit "#{base_msg_text} \n Players: #{players.join(', ')}. Game will start in #{seconds_left}!"
  end

end