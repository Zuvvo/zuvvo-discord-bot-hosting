class BotMessages

  def self.help(arg)
    "Please start game using following command: #{arg} easy/mid/hard/insane <number_of_rounds> <round_time> <game_start_delay>
Example: `#{arg} mid 10 30 60`
Above example will start mid difficulty game with 10 rounds, 60s for answer, from 2 to 3 numbers in riddle and 60s registration time.
Limits => number_of_rounds: 1-20, round_time: 3s-120s, game_start_delay: 5s-120s
Easy - 2..3 numbers
Mid - 3..5 numbers
Hard - 5..8 numbers
Insane - 8..20 numbers
"
  end

end