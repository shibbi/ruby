require 'colorize'

# require_relative 'keypress'

require_relative 'board'
require_relative 'player'

class Game
  def initialize(player1 = HumanPlayer.new(:black, "Chris"), player2 = HumanPlayer.new(:white, "Shibo"))
    @player1, @player2 = player1, player2
    @board = Board.new
    @board.board_setup
  end

  def play
    player = @player1.color == :white ? @player1 : @player2
    until @board.checkmate?(player.color)
      @board.render
      puts "It's now #{player.name}'s (#{player.color}) turn!"
      player.play_turn(@board)
      player = toggle_player(player)
    end
    loser, winner = player.name, toggle_player(player).name
    puts "Game Over! #{winner} won and #{loser} lost!"
  end

  def toggle_player(player)
    player == @player1 ? @player2 : @player1
  end

end

if __FILE__ == $PROGRAM_NAME
  if ARGV.length == 2
    player1 = HumanPlayer.new(:white, ARGV.shift)
    player2 = HumanPlayer.new(:black, ARGV.shift)
    g = Game.new(player1, player2)
  else
    g = Game.new
  end
  g.play
end
