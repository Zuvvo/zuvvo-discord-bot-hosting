class MathGameRiddle

  attr_accessor :game_host_name, :game_winner, :equation, :time, :answer_time, :difficulty, :points, :game_index, :result

  def initialize(host_name, winner, time, answer_time, difficulty, points, game_index)
    @game_host_name = host_name
    @game_winner = winner
    @time = time
    @answer_time = answer_time
    @difficulty = difficulty
    @points = points
    @game_index = game_index
  end

  def set_riddle
    operators = ['*', '+', '-']
    numbers = []
    rand(3..5).times {numbers << rand(0..20) }
    @equation = numbers.join(' x ').gsub(/x/) {operators.sample }
    @result = eval(equation)
  end

end