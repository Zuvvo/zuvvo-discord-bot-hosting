class BotMessages

  def self.help(arg, difficulties)
    "Please start game using following command: #{arg} easy/mid/hard/insane <number_of_rounds> <round_time> <game_start_delay>
Example: `#{arg} mid 10 30 60`
Above example will start mid difficulty game with 10 rounds, 60s for answer, from 2 to 3 numbers in riddle and 60s registration time.
Limits => number_of_rounds: 1-20, round_time: 3s-120s, game_start_delay: 5s-120s
Easy - #{difficulties[0]} numbers
Mid - #{difficulties[1]} numbers
Hard - #{difficulties[2]} numbers
Insane - #{difficulties[3]} numbers
"
  end

end