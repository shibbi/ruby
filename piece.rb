require_relative 'pieces/sliding.rb'
require_relative 'pieces/stepping.rb'
require_relative 'pieces/pawn.rb'

class Piece
  STRAIGHT_DIRS = [[-1, 0], [1, 0], [0, -1], [0, 1]]
  DIAG_DIRS     = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
  KNIGHT_DIRS   = [[-1, 2], [-1, -2], [1, 2], [1, -2],
                   [-2, 1], [-2, -1], [2, 1], [2, -1]]
  PAWN_DIRS     = [[1, 0], [1, 1], [1, -1]]

  attr_reader :color
  attr_accessor :pos

  def initialize(color, pos, board)
    @color = color
    @pos = pos
    @board = board
  end

  def valid_moves
    moves.reject { |pos| move_into_check?(pos) }
  end

  def move_into_check?(new_pos)
    duped_board = @board.dup
    duped_board.move_piece(@pos, new_pos)
    duped_board.in_check?(color)
  end

  def dup
    self.class.new(@color, @pos, @board)
  end

  protected
    def attempt_move(new_pos)
      if @board.on_board?(new_pos)
        if @board.occupied?(new_pos)
          @board.piece_at(new_pos).color != @color ? 'eat' : 'invalid'
        else
          'empty'
        end
      else
        'invalid'
      end
    end

    def symbol_encode(color, unicode)
      color == :black ? new_color = :black : new_color = :light_white
      unicode.encode('utf-8').colorize(new_color)
    end
end
