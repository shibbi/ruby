# issues
# not deleting pieces properly
# not throwing errors when trying to move to slide into space with piece
# not killing game when no pieces left or no moves left

require 'byebug'
require 'colorize'
# require_relative 'keypress'
require_relative 'board'
require_relative 'player'
require_relative 'errors'

class Game

  attr_reader :board

  def initialize(player1 = HumanPlayer.new(:red, "Red"), player2 = HumanPlayer.new(:black, "Black"))
    @player1, @player2 = player1, player2
    @board = Board.new
    @board.setup
  end

  def play
    player = @player1.color == :red ? @player1 : @player2

    loop do
      board.render
      puts "It's now #{player.name}'s (#{player.color}) turn!"
      begin
        player.play_turn(board)
      rescue NoMoveError
        puts "There are no moves left!"
        break
      end
      break if board.no_pieces_left(player.color)
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
