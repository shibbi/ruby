require 'byebug'

class HumanPlayer
  POS_X = { '8' => 0, '7' => 1, '6' => 2, '5' => 3,
            '4' => 4, '3' => 5, '2' => 6, '1' => 7 }
  POS_Y = { 'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3,
            'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7 }

  attr_reader :color, :name

  def initialize(color, name)
    @color, @name = color, name
  end

  def play_turn(board)
    get_move(board)
    rescue BoundaryError
      puts "You can't move something that's not on the board!"
      retry
    rescue NoPieceError
      puts "You can't move a nonexistent piece!"
      retry
    rescue PlayerError
      puts "That's not your piece!"
      retry
    rescue SameSpaceError
      puts "You can't move from and to the same space!"
      retry
    rescue InvalidMoveError
      puts "That's an invalid move!"
      retry
  end

  def get_move(board)
    from = check_input('Which piece would you like to move? ').first
    from_position = [POS_X[from[1]], POS_Y[from[0]]]
    to = check_input('Where would you like to move to? ')
    to_positions = []
    to.each do |to_pos|
      to_positions << [POS_X[to_pos[1]], POS_Y[to_pos[0]]]
    end
    # debugger
    board.attempt_move(self, from_position, to_positions)
  end

  def get_input(prompt)
    print prompt
    input = gets.chomp
    positions = input.split(' ').map(&:chomp)
    positions.each do |pos|
      raise InputError if pos.length != 2
      letter, num = pos[0], pos[1].to_i
      valid = ('a'..'h').include?(letter) && (1..8).include?(num)
      raise InputError unless valid
    end

    positions
  end

  def check_input(prompt)
    begin
      pos = get_input(prompt)
    rescue InputError
      puts 'Invalid input! Please type [letter][number] (i.e. c6 d5)'
      retry
    end

    pos
  end
end

# class ComputerPlayer
#   def initialize(name = "Super Duper Computer")
#     @name = name
#   end
# end
