require 'colorize'

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
    def straight_moves
      get_moves(STRAIGHT_DIRS)
    end

    def diag_moves
      get_moves(DIAG_DIRS)
    end

    def get_moves(all_dirs)
      x, y = @pos
      [].tap do |moves|
        all_dirs.each do |off_x, off_y|
          new_pos = [off_x + x, off_y + y]
          attempt_move_result = attempt_move(new_pos)
          until attempt_move_result == 'invalid' || attempt_move_result == 'eat'
            moves << [new_pos[0], new_pos[1]]
            new_pos[0] += off_x
            new_pos[1] += off_y
            attempt_move_result = attempt_move(new_pos)
          end
          moves << new_pos if attempt_move_result == 'eat'
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
  #
  # def moves
  #   [].tap do |possible_moves|
  #     (STRAIGHT_DIRS + DIAG_DIRS).each do |direction|
  #       new_pos = [@pos[0] + direction[0], @pos[1] + direction[1]]
  #       if attempt_move(new_pos) == 'empty' || attempt_move(new_pos) == 'eat'
  #         possible_moves << new_pos
  #       end
  #     end
  #   end
  # end
end

class Pawn < Piece
  def moves
    x, y = @pos
    possible_moves = []
    if color == :black
      if x == 1
        new_x = x + 2
        possible_moves << [new_x, y] if attempt_move([new_x, y]) == 'empty'
      end
      PAWN_DIRS.each do |dir|
        new_pos = [x + dir[0], y + dir[1]]
        if attempt_move(new_pos) == 'empty' && !DIAG_DIRS.include?(dir) ||
           attempt_move(new_pos) == 'eat' && !STRAIGHT_DIRS.include?(dir)
          possible_moves << new_pos
        end
      end
    elsif color == :white
      if x == 6
        new_x = x - 2
        possible_moves << [new_x, y] if attempt_move([new_x, y]) == 'empty'
      end
      PAWN_DIRS.each do |dir|
        new_pos = [x - dir[0], y - dir[1]]
        if attempt_move(new_pos) == 'empty' && !DIAG_DIRS.include?(dir) ||
           attempt_move(new_pos) == 'eat' && !STRAIGHT_DIRS.include?(dir)
          possible_moves << new_pos
        end
      end
    end

    possible_moves
  end

  def symbol
    @color == :black ? "\u265F".encode('utf-8') : "\u2659".encode('utf-8')
  end
end
