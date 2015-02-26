require_relative 'chess_board'
require_relative 'chess_piece'
require_relative 'chess_player'

class Game
  def initialize(player1 = HumanPlayer.new(:black, "Chris"), player2 = HumanPlayer.new(:white, "Shibo"))
    @player1, @player2 = player1, player2
  end

  def play
    @board = Board.new
    @board.board_setup
    player = @player1.color == :black ? @player1 : @player2
    until @board.checkmate?(player.color)
      puts "It's now #{player.name}'s (#{player.color}) turn!"
      @board.render
      begin
        player.play_turn(@board)
      rescue PlayerError
        puts "You can't move a piece that doesn't belong to you :("
        retry
      rescue NoPieceError
        puts "Can't move a nonexistent piece; try again"
        retry
      end
      player = toggle_player(player)
    end
    loser = player.name
    winner = toggle_player(player).name
    puts "Game Over! #{winner} won and #{loser} lost!"
  end

  def toggle_player(player)
    player == @player1 ? @player2 : @player1
  end

end

if __FILE__ == $PROGRAM_NAME
  # puts "Running from this file"
  # g = Game.new
  # g.play
end
