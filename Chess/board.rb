require_relative 'piece'
require_relative 'pieces/sliding.rb'
require_relative 'pieces/stepping.rb'
require_relative 'pieces/pawn.rb'

class LocationError < ArgumentError
end

class NoPieceError < ArgumentError
end

class PlayerError < ArgumentError
end

class SameSpaceError <ArgumentError
end

class InCheckError < ArgumentError
end

class OtherMoveError < ArgumentError
end

class Board

  BOARD_SIZE = 8

  def initialize
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
  end

  def move_piece(old_pos, new_pos)
    old_x, old_y = old_pos
    new_x, new_y = new_pos
    @grid[new_x][new_y] = @grid[old_x][old_y].dup
    @grid[old_x][old_y] = nil
    @grid[new_x][new_y].pos = new_pos
  end

  def move(player, pos1, pos2)
    fail LocationError unless on_board?(pos2)
    fail NoPieceError if piece_at(pos1).nil?
    fail PlayerError if player.color != piece_at(pos1).color
    fail SameSpaceError if pos1 == pos2
    fail InCheckError if piece_at(pos1).move_into_check?(pos2)
    fail OtherMoveError unless piece_at(pos1).valid_moves.include?(pos2)
    move_piece(pos1, pos2)
  end

  def occupied?(pos)
    piece_at(pos).nil? ? false : true
  end

  def on_board?(pos)
    pos.min >= 0 && pos.max < BOARD_SIZE
  end

  def piece_at(pos)
    x, y = pos
    @grid[x][y]
  end

  def in_check?(king_color)
    king = color_pieces(king_color).find { |piece| piece.class == King }
    @grid.flatten.each do |piece|
      if piece && piece.color != king_color && piece.moves.include?(king.pos)
        return true
      end
    end

    false
  end

  def checkmate?(king_color)
    no_valid_moves = color_pieces(king_color).all? do |piece|
      piece.valid_moves.empty?
    end

    in_check?(king_color) && no_valid_moves
  end

  def color_pieces(color)
    @grid.flatten.compact.select { |piece| piece.color == color }
  end

  def board_setup
    color, x = :black, 0
    2.times do
      @grid[x][0] = Rook.new(color, [x, 0], self)
      @grid[x][1] = Knight.new(color, [x, 1], self)
      @grid[x][2] = Bishop.new(color, [x, 2], self)
      @grid[x][3] = Queen.new(color, [x, 3], self)
      @grid[x][4] = King.new(color, [x, 4], self)
      @grid[x][5] = Bishop.new(color, [x, 5], self)
      @grid[x][6] = Knight.new(color, [x, 6], self)
      @grid[x][7] = Rook.new(color, [x, 7], self)
      color, x = :white, 7
    end
    0.upto(BOARD_SIZE - 1) { |y| @grid[1][y] = Pawn.new(:black, [1, y], self) }
    0.upto(BOARD_SIZE - 1) { |y| @grid[6][y] = Pawn.new(:white, [6, y], self) }

    nil
  end

  def dup
    board_copy = Board.new
    @grid.flatten.compact.each do |piece|
      x, y = piece.pos
      board_copy[[x, y]] = piece.dup
    end

    board_copy
  end

  def render
    system 'clear'
    puts '    a  b  c  d  e  f  g  h '
    pink = true
    @grid.each_index do |row|
      print " #{BOARD_SIZE - row} "
      @grid[row].each_index do |space|
        if @grid[row][space].nil?
          bg = pink ? pink_bg('   ') : cyan_bg('   ')
        else
          symbol = @grid[row][space].symbol
          bg = pink ? pink_bg(" #{symbol} ") : cyan_bg(" #{symbol} ")
        end
        print bg
        pink = !pink
      end
      puts ''
      pink = !pink
    end
    puts ''

    nil
  end

  protected

  def []=(pos, piece)
    @grid[pos.first][pos.last] = piece
  end

  def pink_bg(str)
    str.colorize(:background => :light_magenta)
  end

  def cyan_bg(str)
    str.colorize(:background => :cyan)
  end


end
