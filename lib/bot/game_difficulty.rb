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

  def self.get_numbers_count(difficulty)
    case difficulty
    when 1 then return 3..3
    when 2 then return 4..5
    when 3 then return 6..7
    when 4 then return 8..20
    end
  end

  def self.get_number_of_hard_operators(difficulty)
    case difficulty
    when 1 then return 0..1
    when 2 then return 0..2
    when 3 then return 1..4
    when 4 then return 2..8
    end
  end

end