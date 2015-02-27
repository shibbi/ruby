require 'colorize'
require_relative 'piece'

class Board
  BOARD_SIZE = 8

  # attr_accessor :grid

  def initialize
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
  end

  def move!(start_pos, end_pos)
    old_x, old_y = start_pos
    new_x, new_y = end_pos
    piece = self[[old_x, old_y]]
    self[[new_x, new_y]] = piece
    self[[old_x, old_y]] = nil
    piece.pos = end_pos
    piece.king = true if piece.maybe_promote

    nil
  end

  def on_board?(pos)
    pos.min >= 0 && pos.max < BOARD_SIZE
  end

  def [](pos)
    raise BoundaryError unless on_board?(pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    @grid[x][y] = value
  end

  def add_piece(color, pos)
    raise ExistingPieceError unless self[pos].nil?

    self[pos] = Piece.new(color, pos, self)
  end

  def remove_piece(pos)
    raise NoPieceError if self[pos].nil?

    self[pos] = nil
  end

  def attempt_move(player, from_position, to_positions)
    raise NoPieceError unless self[from_position]
    raise PlayerError if player.color != self[from_position].color
    raise SameSpaceError if from_position == to_positions.first
    self[from_position].perform_moves(to_positions)
  end

  def no_pieces_left(color)
    @grid.flatten.compact.none? { |piece| piece.color == color }
  end

  def dup
    new_board = Board.new
    @grid.flatten.compact.each do |piece|
      new_board[piece.pos] = piece.dup(new_board)
    end

    new_board
  end

  def setup
    assign = true
    (0...BOARD_SIZE).each do |row|
      (0...BOARD_SIZE).each do |col|
        pos = [row, col]
        if row < 3 && assign
          add_piece(:red, pos)
        elsif row > 4 && assign
          add_piece(:black, pos)
        end
        assign = !assign
      end
      assign = !assign
    end

    nil
  end

  def render
    system 'clear'
    light = true
    puts '    ' + %w(a b c d e f g h).join('  ')
    (0...BOARD_SIZE).each do |x|
      print " #{BOARD_SIZE - x} "
      (0...BOARD_SIZE).each do |y|
        piece = self[[x, y]]
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

  def light_bg(str)
    str.colorize(:background => :white)
  end

  def dark_bg(str)
    str.colorize(:background => :light_black)
  end
end

def test_game
  test_board = Board.new
  test_board.setup
  test_board.move!([2, 0], [3, 1])
  test_board.move!([3, 1], [4, 2])
  test_board.move!([5, 3], [4, 2])
  test_board.render

  test_board
end
