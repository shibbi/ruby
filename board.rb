require 'colorize'

require_relative 'piece'

class ExistingPieceError < StandardError
end

class NoPieceError < StandardError
end

class Board

  BOARD_SIZE = 8

  attr_accessor :grid

  def initialize
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
  end

  # def move_piece(old_pos, new_pos)
  #   old_x, old_y = old_pos
  #   new_x, new_y = new_pos
  #   @grid[new_x][new_y] = @grid[old_x][old_y].dup
  #   @grid[old_x][old_y] = nil
  #   @grid[new_x][new_y].pos = new_pos
  # end
  #

  def move!(start_pos, end_pos)
    old_x, old_y = start_pos
    new_x, new_y = end_pos
    @grid[new_x][new_y] = @grid[old_x][old_y].dup
    @grid[old_x][old_y] = nil
    @grid[new_x][new_y].pos = end_pos
  end

  #
  # def occupied?(pos)
  #   piece_at(pos).nil? ? false : true
  # end
  #
  def on_board?(pos)
    pos.min >= 0 && pos.max < BOARD_SIZE
  end

  def piece_at(pos)
    x, y = pos
    @grid[x][y]
  end

  #
  # def in_check?(king_color)
  #   king = color_pieces(king_color).find { |piece| piece.class == King }
  #   @grid.flatten.each do |piece|
  #     if piece && piece.color != king_color && piece.moves.include?(king.pos)
  #       return true
  #     end
  #   end
  #
  #   false
  # end
  #
  # def checkmate?(king_color)
  #   no_valid_moves = color_pieces(king_color).all? do |piece|
  #     piece.valid_moves.empty?
  #   end
  #
  #   in_check?(king_color) && no_valid_moves
  # end
  #
  # def color_pieces(color)
  #   @grid.flatten.compact.select { |piece| piece.color == color }
  # end
  #
  def setup
    assign = true
    (0...BOARD_SIZE).each do |row|
      (0...BOARD_SIZE).each do |col|
        pos = [row, col]
        if row < 3 && assign
          @grid[row][col] = add_piece(:red, pos)
        elsif row > 4 && assign
          @grid[row][col] = add_piece(:black, pos)
        end
        assign = !assign
      end
      assign = !assign
    end

    nil
  end

  def add_piece(color, pos)
    raise ExistingPieceError unless piece_at(pos).nil?
    Piece.new(color, pos, self)
  end

  def remove_piece(pos)
    raise NoPieceError if piece_at(pos).nil?
    x, y = pos
    @grid[x][y] = nil
  end

  # def dup
  #   board_copy = Board.new
  #   @grid.flatten.compact.each do |piece|
  #     x, y = piece.pos
  #     board_copy[[x, y]] = piece.dup
  #   end
  #
  #   board_copy
  # end

  def render
    system 'clear'
    light = true
    (0...BOARD_SIZE).each do |row|
      (0...BOARD_SIZE).each do |col|
        piece = @grid[row][col]
        if piece.nil?
          bg = light ? light_bg('   ') : dark_bg('   ')
        else
          symbol = piece.symbol
          bg = light ? light_bg(" #{symbol} ") : dark_bg(" #{symbol} ")
        end
        print bg
        light = !light
      end
      puts ''
      light = !light
    end
    puts ''

    nil
  end

  protected

  # def []=(pos, piece)
  #   @grid[pos.first][pos.last] = piece
  # end

  def light_bg(str)
    str.colorize(:background => :white)
  end

  def dark_bg(str)
    str.colorize(:background => :light_black)
  end
end
