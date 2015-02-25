require 'byebug'

class Piece
  STRAIGHT_DIRS = [[-1, 0], [1, 0], [0, -1], [0, 1]]
  DIAG_DIRS     = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
  KNIGHT_DIRS   = [[-1, 2], [-1, -2], [1, 2], [1, -2],
                   [-2, 1], [-2, -1], [2, 1], [2, -1]]
  PAWN_DIRS     = [[0, 1], [0, 2], [-1, 1], [1, 1]]

  attr_reader :pos, :color

  def initialize(color, pos, board)
    @color = color
    @pos = pos
    @board = board
  end

  def valid_moves()

  end

  def moved?

  end

  protected
    def attempt_move(new_pos)
      if @board.on_board?(new_pos)
        if @board.occupied?(new_pos)
          @board.piece_at?(new_pos).color != @color ? 'eat' : 'invalid'
        else
          'empty'
        end
      else
        'invalid'
      end
    end

end

class SlidingPiece < Piece
  def moves
    straight_arr, diag_arr = straight_moves, diag_moves

    case move_dirs
    when 'horizontal'
      straight_arr
    when 'diagonal'
      diag_arr
    when 'both'
      diag_arr + straight_arr
    end
  end

  private
    def straight_moves(pos = @pos)
      # debugger
      # return [] unless @board.on_board?(pos)
      straight_arr = []
      x, y = pos
      # FOUR_DIRS = [0, ]
      STRAIGHT_DIRS.each do |off_x, off_y|
        new_pos = [off_x + x, off_y + y]
        attempt_move_result = attempt_move(new_pos)
        until attempt_move_result == 'invalid' || attempt_move_result == 'eat'
          debugger
          straight_arr << new_pos
          new_pos[0] += off_x
          new_pos[1] += off_y
          attempt_move_result = attempt_move(new_pos)
        end
        straight_arr += new_pos if attempt_move_result == 'eat'
      end

      straight_arr
    end

    def diag_moves
      x, y = @pos
      [].tap do |diag_arr|
        pos_x, pos_y = x + 1, y + 1
        while pos_x < 8 && pos_y < 8
          # break if @board.piece_at(pos) && @board.piece_at(pos).color == @color
          diag_arr << [pos_x, pos_y]
          # break if @board.piece_at(pos) && @board.piece_at(pos).color != @color
          pos_x += 1
          pos_y += 1
        end
        pos_x, pos_y = x - 1, y - 1
        while pos_x >= 0 && pos_y >= 0
          diag_arr << [pos_x, pos_y]
          pos_x -= 1
          pos_y -= 1
        end
        pos_x, pos_y = x + 1, y - 1
        while pos_x < 8 && pos_y >= 0
          diag_arr << [pos_x, pos_y]
          pos_x += 1
          pos_y -= 1
        end
        pos_x, pos_y = x - 1, y + 1
        while pos_x >= 0 && pos_y < 8
          diag_arr << [pos_x, pos_y]
          pos_x -= 1
          pos_y += 1
        end
      end
    end
end

class Rook < SlidingPiece
  def move_dirs
    'horizontal'
  end

  def symbol
    @color == :black ? "\u265C".encode('utf-8') : "\u2656".encode('utf-8')
  end

end

class Bishop < SlidingPiece
  def move_dirs
    'diagonal'
  end

  def symbol
    @color == :black ? "\u265D".encode('utf-8') : "\u2657".encode('utf-8')
  end
end

class Queen < SlidingPiece
  def move_dirs
    'both'
  end

  def symbol
    @color == :black ? "\u265B".encode('utf-8') : "\u2655".encode('utf-8')
  end
end

class SteppingPiece < Piece
  def get_moves(all_dirs)
    [].tap do |possible_moves|
      all_dirs.each do |direction|
        new_pos = [@pos[0] + direction[0], @pos[1] + direction[1]]
        if attempt_move(new_pos) == 'empty' || attempt_move(new_pos) == 'eat'
          possible_moves << new_pos
        end
      end
    end
  end
end

class Knight < SteppingPiece
  def moves
    get_moves(KNIGHT_DIRS)
  end

  def symbol
    @color == :black ? "\u265E".encode('utf-8') : "\u2658".encode('utf-8')
  end

end

class King < SteppingPiece
  def moves
    get_moves(STRAIGHT_DIRS + DIAG_DIRS)
  end

  def symbol
    @color == :black ? "\u265A".encode('utf-8') : "\u2654".encode('utf-8')
  end

  def moves
    [].tap do |possible_moves|
      (STRAIGHT_DIRS + DIAG_DIRS).each do |direction|
        new_pos = [@pos[0] + direction[0], @pos[1] + direction[1]]
        if attempt_move(new_pos) == 'empty' || attempt_move(new_pos) == 'eat'
          possible_moves << new_pos
        end
      end
    end
  end

end

class Pawn < Piece
  def symbol
    @color == :black ? "\u265F".encode('utf-8') : "\u2659".encode('utf-8')
  end
end
