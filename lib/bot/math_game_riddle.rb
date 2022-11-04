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
    rand(get_numbers_count).times {numbers << rand(0..20) }
    @equation = numbers.join(' x ').gsub(/x/) {operators.sample }
    @result = eval(equation)
  end

  def get_numbers_count
    case difficulty
    when 1 then return 2..3
    when 2 then return 3..5
    when 3 then return 5..8
    when 4 then return 8..20
    end
  end

end