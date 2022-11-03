class MathGame

  attr_accessor :discord_user_name, :riddle, :time, :difficulty, :points

  def initialize(name, riddle, time, difficulty, points)
    @discord_user_name = name
    @riddle = riddle
    @time = time
    @difficulty = difficulty
    @points = points
  end

  def print_score
    "#Correct, #{name}! You answered in #{time} seconds and received #{points} points."
  end

end