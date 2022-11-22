class MathGame
  require_relative 'math_game_riddle'
  require_relative 'graphql_sender'
  require_relative 'bot_message_async'
  include GraphqlSender

  CROSS_MARK = "\u274c"
  DELAY_BEFORE_STARTING = 1
  DELAY_BETWEEN_RIDDLES = 3
  FINAL_COUNTDOWN = 5

  SPECIAL_PLAYERS = ['xplode']

  attr_accessor :game_host_name, :time_for_answer, :difficulty, :event, :bot,
                :games_number, :riddles, :start_game_delay, :players, :results


  def initialize(event, host_name, bot, args)
    @event = event
    @game_host_name = host_name
    @bot = bot
    # puts GameDifficulty.constants
    @difficulty = args.size > 0 && valid_difficulty(args[0]) ? GameDifficulty.const_get(args[0].upcase.to_sym) : 2
    @games_number = args.size > 1 && valid_rounds(args[1])? args[1].to_i : 5
    @time_for_answer = args.size > 2 && valid_round_time(args[2])? args[2].to_i : 30
    @start_game_delay = args.size > 3 && valid_game_start_delay(args[3])? args[3].to_i : 30
    @results = {}
    @bot_msg_async = BotMessageAsync.new(bot)
  end

  def start_game
    @riddles = []
    @players = []

    base_msg_text = "Starting new #{ GameDifficulty.get_difficulty_by_value(difficulty) } game. There will be `#{games_number}` rounds and you have `#{time_for_answer}` seconds to solve each riddle. Click on emote below to sign in. You have `#{start_game_delay}` seconds to do it."
    msg = event.respond base_msg_text
    msg.react CROSS_MARK

    bot.add_await!(Discordrb::Events::ReactionAddEvent, message: msg, emoji: CROSS_MARK, timeout: start_game_delay) do |reaction_event|
      players << reaction_event.user.name unless players.include?(reaction_event.user.name)
      event.respond(" I was waiting for you mr. #{reaction_event.user.name}. Don't let me down!") if SPECIAL_PLAYERS.include?(reaction_event.user.name)
    end

    if players.size > 0 then
      if start_game_delay > DELAY_BEFORE_STARTING then

        FINAL_COUNTDOWN.downto(1) do|i|
          seconds_left = "`#{i}` #{i == 1 ? 'second' : 'seconds'}"
          @bot_msg_async.async.edit(msg, base_msg_text, players, seconds_left)
          bot.add_await!(Discordrb::Events::ReactionAddEvent, timeout: 1)
        end

        msg.edit base_msg_text
        event.respond "Starting the game for players: #{players.join(', ')}"
        bot.add_await!(Discordrb::Events::ReactionAddEvent, timeout: DELAY_BEFORE_STARTING)
      end
      games_number.times do |i| start_one_game(i) end
      set_results
      players.each {|player| event.respond("Oh, #{player}, you almost won an obrazek. You need to win a game with at least 3 players and 5 rounds to get it.") if SPECIAL_PLAYERS.include?(player) }
      event.respond get_scoreboard if players.size > 0
      if players.size >= 2 then
        send_mutation_query(self)
        ""
      end
    else
      event.respond "Not enough players. Closing the game."
    end
  end

  def start_one_game(game_index)
    bot.add_await!(Discordrb::Events::ReactionAddEvent, timeout: DELAY_BETWEEN_RIDDLES) unless game_index == 0
    riddle = MathGameRiddle.new(game_host_name, nil, time_for_answer, 0, difficulty, game_index)
    riddle.set_riddle
    event.respond "#{riddle.equation} = ?"

    guessed = false

    bot.add_await!(Discordrb::Events::MessageEvent, message: riddle.equation, timeout: time_for_answer) do |message_event|
      guess = message_event.message.content.to_i
      user_name =  message_event.user.name
      if guess == riddle.result
        unless players.include?(user_name) then
          event.respond "#{user_name}, don't spoil the game, you \\*\\*\\*  \\*\\*\\* \\*\\*\\*\\*\\*\\*! Too hard to sign in?"
          false
        else
          event.respond "Correct, #{user_name}! The answer is: `#{riddle.result}`."
          riddle.game_winner = user_name
          guessed = true
          true
        end
      else
        false
      end
    end

    event.respond "Too hard? The answer is: `#{riddle.result}`." if !guessed
    riddles << riddle
    riddle
  end

  def set_results
    @players.each do |player|
      results[player] = riddles.count { |el| el.game_winner == player }
    end
    @results = results.sort_by {|k,v| v}.reverse
  end

  def get_scoreboard
    results_for_scoreboard = results.map {|k,v| "#{k}: #{v}" + (v == 0 ? " - do you even lift?" : "") }
    "Game finished. Scoreboard:\n#{results_for_scoreboard.join("\n")}"
  end

  def validate_args(args)
    return true if args == 0
    valid_difficulty = args.size < 1 || valid_difficulty(args[0])
    valid_rounds = args.size < 2 || valid_rounds(args[1])
    valid_round_time = args.size < 3 || valid_round_time(args[2])
    valid_game_start_delay = args.size < 4 || valid_game_start_delay(args[3])

    valid_difficulty && valid_rounds && valid_round_time && valid_game_start_delay
  end

  def valid_difficulty(arg)
    GameDifficulty.constants.include?(arg.upcase.to_sym)
  end

  def valid_rounds(arg)
    arg.to_i.between?(1, 20)
  end

  def valid_round_time(arg)
    arg.to_i.between?(3, 120)
  end

  def valid_game_start_delay(arg)
    arg.to_i.between?(FINAL_COUNTDOWN, 120)
  end

end