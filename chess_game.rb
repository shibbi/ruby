require_relative 'chess_board'
require_relative 'chess_piece'

class LocationError < ArgumentError
end

class Game

  def initialize
  end

  def get_input(prompt)
    print prompt
    result = gets.chomp
    raise LocationError if result.split(",").map(&:chomp).count != 2
    #{ }"Which piece would you like to move?"

    #{ }"Where would you like to move your piece?"
  end

  def turn


  def play
    b = Board.new
    b.board_setup
    b.render
    # until checkmate?(:black) || checkmate?(:white)
  end

  end

end



if __FILE__ == $PROGRAM_NAME
  puts "Running from this file"
  # g = Game.new
  # g.play
end
