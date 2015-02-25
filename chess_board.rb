class Board

  BOARD_SIZE = 8

  # UNSAFE, REMOVE LATER
  attr_accessor :grid

  def initialize
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }

  end

  def move_piece(piece, pos)
    x, y = pos
    old_x, old_y = piece.pos
    @grid[old_x][old_y] = nil
    @grid[x][y] = piece
  end

  def occupied?(pos)
    !!piece_at(pos)
  end

  def on_board?(pos)
    pos.min >= 0 && pos.max < BOARD_SIZE
  end

  def piece_at(pos)
    x, y = pos
    @grid[x][y]
  end

  # def in_check?(king_color)
  #   king_color == :black ? king = @black_king : king = @white_king
  #   @grid.flatten.each do |piece|
  #     if piece && piece.color != king_color && piece.moves.include?(king.pos)
  #       return true
  #     end
  #   end
  #
  #   false
  # end

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
      board_copy[[x, y]] = piece.class.new(piece.color, piece.pos, board_copy)
    end

    board_copy
  end

  def render
    @grid.each do |row|
      row.each do |space|
        if space.nil?
          print '|__|'
        else
          print "|#{space.symbol} |"
        end
      end
      puts ''
      # puts '----' * BOARD_SIZE
    end

    nil
  end

  protected

  def []=(pos, piece)
    @grid[pos.first][pos.last] = piece
  end
end
