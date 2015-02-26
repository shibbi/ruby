class InputError < ArgumentError
end

class PlayerError < ArgumentError
end

class HumanPlayer
  POS_X = { "8" => 0, "7" => 1, "6" => 2, "5" => 3,
            "4" => 4, "3" => 5, "2" => 6, "1" => 7 }
  POS_Y = { "a" => 0, "b" => 1, "c" => 2, "d" => 3,
            "e" => 4, "f" => 5, "g" => 6, "h" => 7 }

  attr_reader :color, :name

  def initialize(color, name = "Dummy")
    @color, @name = color, name
  end

  def play_turn(board)
    begin
      from = check_input("Which piece would you like to move? ")
      from_pos = [POS_X[from[1]], POS_Y[from[0]]]
      to = check_input("Where would you like to move to? ")
      to_pos = [POS_X[to[1]], POS_Y[to[0]]]
      board.move(from_pos, to_pos)
    rescue LocationError => e
      puts "Uh oh, that's not on the board!"
      retry
    rescue NoPieceError => e
      puts "Oops, there isn't a piece there!"
      retry
    rescue InCheckError => e
      puts "Are you sure? That puts you in check!"
      retry
    rescue OtherMoveError => e
      puts "I don't know what happened but you can't make that move :("
      retry
    end
  end


  def get_input(prompt)
    print prompt
    result = gets.chomp
    pos = result.split("").map(&:chomp)
    raise InputError if pos.count != 2
    valid = ('a'..'h').include?(pos[0]) && (1..8).include?(pos[1].to_i)
    raise InputError unless valid

    pos
  end

  def check_input(prompt)
    begin
      pos = get_input(prompt)
    rescue InputError => e
      puts "Invalid input; please input in [letter][number] format (i.e. a8)"
      retry
    end

    pos
  end

  # def check_move(board, from_pos, to_pos)
  #   begin
  #     board.move(from_pos, to_pos)
  #   rescue LocationError => e
  #     puts "Uh oh, that's not on the board!"
  #     # retry
  #   rescue NoPieceError => e
  #     puts "Oops, there isn't a piece there!"
  #     # retry
  #   rescue InCheckError => e
  #     puts "Are you sure? That puts you in check!"
  #     # retry
  #   rescue OtherMoveError => e
  #     puts "I don't know what happened but you can't make that move :("
  #     # retry
  #   end
  # end

end

class ComputerPlayer
  def initialize(name = "Super Duper Computer")
    @name = name
  end
end
