class MathGame
  require_relative 'math_game_riddle'
  require_relative 'http_request_helper'

  CROSS_MARK = "\u274c"
  DELAY_BEFORE_STARTING = 2

  SPECIAL_PLAYERS = ['xplode']

  attr_accessor :game_host_name, :game_winner, :time_for_answer, :difficulty, :event, :bot, :games_number, :requester, :riddles, :start_game_delay, :players


  def initialize(event, host_name, bot, requester, time, games_number, difficulty, start_game_delay)
    @event = event
    @game_host_name = host_name
    @bot = bot
    @requester = requester
    @time_for_answer = time
    @games_number = games_number
    @difficulty = difficulty
    @start_game_delay = start_game_delay
  end

  def start_game
    @riddles = []
    @players = []

    msg = event.respond "Starting new game. There will be `#{@games_number}` rounds and you have `#{time_for_answer}` seconds to solve each riddle. Click on emote below to sign in. Game will start in `#{start_game_delay}` seconds."

    msg.react CROSS_MARK

    bot.add_await!(Discordrb::Events::ReactionAddEvent, message: msg, emoji: CROSS_MARK, timeout: start_game_delay) do |reaction_event|
      @players << reaction_event.user.name unless @players.include?(reaction_event.user.name)
      event.respond("I was waiting for you mr. #{reaction_event.user.name}. Don't let me down!") if SPECIAL_PLAYERS.include?(reaction_event.user.name)
    end

    if @players.size > 0 then
      if start_game_delay > DELAY_BEFORE_STARTING then
        event.respond "Starting the game in `#{DELAY_BEFORE_STARTING}` seconds for players: #{@players.join(', ')}"
        bot.add_await!(Discordrb::Events::ReactionAddEvent, timeout: DELAY_BEFORE_STARTING)
      else
        event.respond "Starting the game for players: #{@players.join(', ')}"
      end
      games_number.times do start_one_game end
    else
      event.respond "Not enough players. Closing the game."
    end

    event.respond get_scoreboard
  end

  def start_one_game
    riddle = MathGameRiddle.new(game_host_name, nil, time_for_answer, 0, difficulty, 0, 0)
    riddle.set_riddle
    event.respond "#{riddle.equation} = ?"

    bot.add_await!(Discordrb::Events::MessageEvent, message: riddle.equation, timeout: time_for_answer) do |message_event|
      guess = message_event.message.content.to_i
      user_name =  message_event.user.name
      if guess == riddle.result
        unless players.include?(user_name) then
          event.respond "#{user_name}, don't spoil the game, you \\*\\*\\*  \\*\\*\\* \\*\\*\\*\\*\\*\\*! Too hard to sign in?"
          false
        else
          event.respond "Correct, #{user_name}!"
          riddle.game_winner = user_name
          #respond = requester.send_math_game_data(game)
          true
        end
      else
        false
      end
    end

    event.respond "The answer was: `#{riddle.result}`."
    riddles << riddle
    riddle
  end

  def get_scoreboard
    result_hash = {}
    @players.each do |player|
      result_hash[player] = riddles.count { |el| el.game_winner == player }
    end
    results = result_hash.sort_by {|k,v| v}.reverse.map {|k,v| "#{k}: #{v}" + (v == 0 ? " - do you even lift?" : "") }
    "Game finished. Scoreboard:\n#{results.join("\n")}"
  end


end