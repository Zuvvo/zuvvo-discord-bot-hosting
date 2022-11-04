module GameDifficulty
  EASY = 1
  MID = 2
  HARD = 3
  INSANE = 4

  def self.get_difficulty_by_value(val)
    case val
    when 1 then return "EASY"
    when 2 then return "MID"
    when 3 then return "HARD"
    when 4 then return "INSANE"
    else return "WRONG DIFFICULTY"
    end
  end
end