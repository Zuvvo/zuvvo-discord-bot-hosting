class MathGameRiddle

  require_relative 'game_difficulty'
  include GameDifficulty

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
    hard_operators = ['*']
    easy_operators = ['+', '-']
    operators = []
    numbers = []
    numbers_count = rand(GameDifficulty.get_numbers_count(difficulty))
    rand(GameDifficulty.get_number_of_hard_operators(difficulty)).times {operators << hard_operators.sample }
    (numbers_count - 1 - operators.size).times {operators << easy_operators.sample }
    operators.shuffle!
    numbers_count.times {numbers << rand(0..20) }
    numbers_with_operators = []
    numbers.each_with_index do |el, index|
      numbers_with_operators << el
      numbers_with_operators << operators[index] unless index == operators.size
    end
    @equation =  numbers_with_operators.join(' ')
    @result = eval(equation)
  end

end