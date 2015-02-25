class Board

  BOARD_SIZE = 8

  def initialize
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }

    board_setup
  end

  def occupied?(pos)
    !!piece_at?(pos)
  end

  def piece_at?(pos)
    @grid[pos[0]][pos[1]]
  end

  def on_board?(pos)
    pos.min >= 0 && pos.max < BOARD_SIZE
  end

  def board_setup
    color, x = :white, 0
    2.times do
      @grid[x][0] = Rook.new(color, [x, 0], self)
      @grid[x][1] = Knight.new(color, [x, 1], self)
      @grid[x][2] = Bishop.new(color, [x, 2], self)
      @grid[x][3] = Queen.new(color, [x, 3], self)
      @grid[x][4] = King.new(color, [x, 4], self)
      @grid[x][5] = Bishop.new(color, [x, 5], self)
      @grid[x][6] = Knight.new(color, [x, 6], self)
      @grid[x][7] = Rook.new(color, [x, 7], self)
      color, x = :black, 7
    end
    0.upto(BOARD_SIZE - 1) { |y| @grid[1][y] = Pawn.new(:white, [1, y], self) }
    0.upto(BOARD_SIZE - 1) { |y| @grid[6][y] = Pawn.new(:black, [6, y], self) }

    nil
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
end
