class Piece
  DOWN_DIRS = [[1, 1], [1, -1], [2, 2], [2, -2]]
  UP_DIRS   = [[-1, 1], [-1, -1], [-2, 2], [-2, -2]]

  # PIECE_UNICODE = { black: "\u26AB", white: "\u26AA" }
  PIECE_UNICODE = { black: "\u25CF", red: "\u25CF" }
  KING_UNICODE  = { black: "\u25C9", red: "\u25C9" }

  attr_reader :color, :board
  attr_accessor :pos, :king

  def initialize(color, pos, board, king = false)
    @color = color
    @pos = pos
    @board = board
    @king = king
  end

  def move_dirs
    x, y = pos
    if king
      all_dirs = DOWN_DIRS + UP_DIRS
    else
      all_dirs = color == :red ? DOWN_DIRS : UP_DIRS
    end
    all_dirs.select { |dir| board.on_board?(dir.pos) }

    all_dirs.map { |dir| [x + dir[0], y + dir[1]] }
  end

  def perform_slide(end_pos)
    return false unless move_dirs.include?(end_pos)

    board.move!(pos, end_pos)
  end

  def perform_jump(end_pos)
    return false unless move_dirs.include?(end_pos)

    jumped_pos = [(pos[0] + end_pos[0]) / 2, (pos[1] + end_pos[1]) / 2]
    return false unless board.piece_at(jumped_pos)

    board.remove_piece(jumped_pos)
    board.move!(pos, end_pos)
  end

  def dup
    new(@color, @pos, @board, @king)
  end

  # def valid_moves
  #   # moves.reject { |pos| move_into_check?(pos) }
  # end
  #
  #
  # # def attempt_move(new_pos)
  # #   if @board.on_board?(new_pos)
  # #     if @board.occupied?(new_pos)
  # #       @board.piece_at(new_pos).color != @color ? 'eat' : 'invalid'
  # #     else
  # #       'empty'
  # #     end
  # #   else
  # #     'invalid'
  # #   end
  # # end

  def symbol
    unicode = king ? KING_UNICODE[color] : PIECE_UNICODE[color]
    unicode.colorize(color)
  end
end
