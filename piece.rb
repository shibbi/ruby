class Piece
  DOWN_DIRS = { slide: [[1, 1], [1, -1]],
                jump: [[2, 2], [2, -2]] }
  UP_DIRS   = { slide: [[-1, 1], [-1, -1]],
                jump: [[-2, 2], [-2, -2]] }

  # PIECE_UNICODE = { black: "\u26AB", white: "\u26AA" }
  PIECE_UNICODE = { black: "\u25C9", red: "\u25C9" }
  KING_UNICODE  = { black: "\u265B", red: "\u265B" }

  attr_reader :color, :board
  attr_accessor :pos, :king

  def initialize(color, pos, board, king = false)
    @color = color
    self.pos = pos
    @board = board
    self.king = king
  end

  def move_dirs(type)
    if king
      all_dirs = DOWN_DIRS[type] + UP_DIRS[type]
    else
      all_dirs = color == :red ? DOWN_DIRS[type] : UP_DIRS[type]
    end
    all_pos = all_dirs.map { |dir| get_end_position(dir) }

    all_pos.select { |dir| board.on_board?(dir) }
  end

  def get_end_position(offset)
    x, y = pos
    [x + offset[0], y + offset[1]]
  end

  def perform_slide(end_pos)
    return false unless move_dirs(:slide).include?(end_pos)
    return false if board[end_pos]

    board.move!(pos, end_pos)

    true
  end

  def perform_jump(end_pos)
    return false unless move_dirs(:jump).include?(end_pos)

    jumped_piece = board[get_jumped_pos(end_pos)]
    if jumped_piece.nil? || jumped_piece.color == color
      return false
    end

    board.remove_piece(get_jumped_pos(end_pos))
    board.move!(pos, end_pos)

    true
  end

  def get_jumped_pos(end_pos)
    [(pos[0] + end_pos[0]) / 2, (pos[1] + end_pos[1]) / 2]
  end

  def perform_moves(moves)
    raise InvalidMoveError unless valid_move_seq?(moves)
    perform_moves!(moves)
  end

  def valid_move_seq?(moves)
    new_board = board.dup
    new_piece = new_board[pos]
    begin
      new_piece.perform_moves!(moves)
    rescue InvalidMoveError
      return false
    end

    true
  end

  def perform_moves!(moves)
    raise NoMoveError if moves.empty?
    # debugger

    if moves.length == 1
      slide = perform_slide(moves.first)
      return true if slide
      raise InvalidMoveError unless perform_jump(moves.first)
    else
      moves.each do |move|
        raise InvalidMoveError unless perform_jump(move)
        break if king
      end
    end

    true
  end

  def maybe_promote
    color == :red && pos[0] == 7 || color == :black && pos[0] == 0
  end

  def dup(new_board)
    Piece.new(@color, @pos, new_board, @king)
  end

  def symbol
    unicode = king ? KING_UNICODE[color] : PIECE_UNICODE[color]
    unicode.colorize(color)
  end
end
